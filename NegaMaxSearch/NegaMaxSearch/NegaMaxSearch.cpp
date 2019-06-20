// NegaMaxSearch.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "NegaMaxSearch.h"

//-----------------some gloabl variables--------------------
int m_nUserChessColor;
CHESSMOVE m_cmBestMove;
BYTE CurPosition[10][9];
int m_nMaxDepth = 3;
//---------------------------------------------------------

void SearchAGoodMove(BYTE position[10][9], int UserChessColor)
{
	InitEval();
	memcpy(CurPosition, position, 90);//将传入的棋盘复制到成员变量中
	m_nUserChessColor = UserChessColor;
	int nDepth = m_nMaxDepth;
	m_cmBestMove.Score = NegaMax(nDepth);			//调用负极大值搜索函数找最佳走法
}
int get_from_x(void)
{
	return static_cast<int>(m_cmBestMove.From.x);
}
int get_from_y(void)
{
	return static_cast<int>(m_cmBestMove.From.y);
}
int get_to_x(void)
{
	return static_cast<int>(m_cmBestMove.To.x);
}
int get_to_y(void)
{
	return static_cast<int>(m_cmBestMove.To.y);
}
//-----------------------------------------------
int NegaMax(int nDepth)
{
	int current = -20000;
	int score;
	int Count, i;
	BYTE type;

	i = IsGameOver(CurPosition, nDepth);//检查棋局是否结束
	if (i != 0)
		return i;//棋局结束，返回极大/极小值

	if (nDepth <= 0)//叶子节点取估值
		return Evaluate(CurPosition, (m_nMaxDepth - nDepth) % 2, m_nUserChessColor);

	//列举当前棋局下一步所有可能的走法
	Count = CreatePossibleMove(CurPosition, nDepth, (m_nMaxDepth - nDepth) % 2);

	for (i = 0; i < Count; i++)
	{
		type = MakeMove(&m_MoveList[nDepth][i]);     //根据走法产生新局面    		
		score = -NegaMax(nDepth - 1);					      //递归调用负极大值搜索下一层节点		
		UnMakeMove(&m_MoveList[nDepth][i], type);   //恢复当前局面

		if (score > current)							      //如果score大于已知的最大值
		{
			current = score;								  //修改当前最大值为score
			if (nDepth == m_nMaxDepth)
				m_cmBestMove = m_MoveList[nDepth][i];//靠近根部时保存最佳走法
		}
	}

	return current;//返回极大值
}
//--------------------------------------------------------------

int IsGameOver(BYTE position[][9], int nDepth)//判断游戏是否结束
{
	int i, j;
	BOOL RedLive = FALSE, BlackLive = FALSE;

	//检查红方九宫是否有帅
	for (i = 7; i < 10; i++)
		for (j = 3; j < 6; j++)
		{
			if (position[i][j] == B_KING)
				BlackLive = TRUE;
			if (position[i][j] == R_KING)
				RedLive = TRUE;
		}

	//检查黑方九宫是否有将
	for (i = 0; i < 3; i++)
		for (j = 3; j < 6; j++)
		{
			if (position[i][j] == B_KING)
				BlackLive = TRUE;
			if (position[i][j] == R_KING)
				RedLive = TRUE;
		}
	i = (m_nMaxDepth - nDepth + 1) % 2;//取当前奇偶标志,奇数层为电脑方,偶数层为用户方
		//红方不在
	if (!RedLive)
		if (i)
			return 19990 + nDepth; //奇数层返回极大值
		else
			return -19990 - nDepth;//偶数层返回极小值

	//黑方不在
	if (!BlackLive)
		if (i)
			return -19990 - nDepth;//奇数层返回极小值
		else
			return 19990 + nDepth; //偶数层返回极大值

	return 0;//将帅都在，返回0
}

BYTE MakeMove(CHESSMOVE* move)
{
	BYTE nChessID;

	nChessID = CurPosition[move->To.y][move->To.x];   //取目标位置棋子
	CurPosition[move->To.y][move->To.x] = CurPosition[move->From.y][move->From.x];
	//把棋子移动到目标位置	
	CurPosition[move->From.y][move->From.x] = NOCHESS;//将原位置清空

	return nChessID;//返回被吃掉的棋子
}

void UnMakeMove(CHESSMOVE* move, BYTE nChessID)
{
	CurPosition[move->From.y][move->From.x] = CurPosition[move->To.y][move->To.x];//将目标位置棋子拷回原位  	
	CurPosition[move->To.y][move->To.x] = nChessID;								//恢复目标位置的棋子
}