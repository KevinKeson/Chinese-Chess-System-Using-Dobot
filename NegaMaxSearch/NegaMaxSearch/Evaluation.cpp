#include "stdafx.h"
#include "stdlib.h"
#include "NegaMaxSearch.h"

//-----------some global variables-------------------------
int m_BaseValue[15];		 //存放棋子基本价值
int m_FlexValue[15];		 //存放棋子灵活性分值
short m_AttackPos[10][9];	 //存放每一位置被威胁的信息
BYTE m_GuardPos[10][9];      //存放每一位置被保护的信息
BYTE m_FlexibilityPos[10][9];//存放每一位置上棋子的灵活性分值
int m_chessValue[10][9];	 //存放每一位置上棋子的总价值
int nPosCount;				 //记录一棋子的相关位置个数
POINT RelatePos[20];		 //记录一棋子的相关位置
long m_nAccessCount;
//---------------------------------------------------------

int Evaluate(BYTE position[10][9], BOOL bIsRedTurn, int nUserChessColor)
{
	int i, j, k;
	int nChessType, nTargetType;

	m_nAccessCount++;//每调用一次就增加一次

	//初始化
	memset(m_chessValue, 0, 360);
	memset(m_AttackPos, 0, 180);
	memset(m_GuardPos, 0, 90);
	memset(m_FlexibilityPos, 0, 90);

	//扫描棋盘，找出每一个棋子，及其威胁/保护的棋子，还有其灵活性
	for (i = 0; i < 10; i++)
		for (j = 0; j < 9; j++)
		{
			if (position[i][j] != NOCHESS)
			{
				nChessType = position[i][j];   //取棋子类型
				GetRelatePiece(position, j, i);//找出该棋子所有相关位置
				for (k = 0; k < nPosCount; k++)     //对每一目标位置
				{
					nTargetType = position[RelatePos[k].y][RelatePos[k].x];//取目标棋子类型
					if (nTargetType == NOCHESS)//如果是空白，灵活性增加
						m_FlexibilityPos[i][j]++;
					else//有棋子
					{
						if (IsSameSide(nChessType, nTargetType))
						{
							//己方棋子，目标受保护
							m_GuardPos[RelatePos[k].y][RelatePos[k].x]++;
						}
						else
						{
							//敌方棋子，目标受威胁
							m_AttackPos[RelatePos[k].y][RelatePos[k].x]++;
							m_FlexibilityPos[i][j]++;//灵活性增加
							switch (nTargetType)
							{
							case R_KING://红帅
								if (!bIsRedTurn)//轮到黑棋走
									return 18888;//返回失败极值
								break;

							case B_KING://黑将
								if (bIsRedTurn)//轮到红棋走
									return 18888;//返回失败极值
								break;

							default:
								//根据威胁的棋子加上威胁分值
								m_AttackPos[RelatePos[k].y][RelatePos[k].x] += (30 + (m_BaseValue[nTargetType] - m_BaseValue[nChessType]) / 10) / 10;
								break;
							}
						}
					}
				}
			}
		}

	//下面的循环统计扫描到的数据
	for (i = 0; i < 10; i++)
		for (j = 0; j < 9; j++)
		{
			if (position[i][j] != NOCHESS)
			{
				nChessType = position[i][j];
				m_chessValue[i][j]++;
				//如果棋子存在其价值不为0，把每一棋子的灵活性价值加进棋子价值
				m_chessValue[i][j] += m_FlexValue[nChessType] * m_FlexibilityPos[i][j];
				//加上兵的附加值
				m_chessValue[i][j] += GetBingValue(j, i, position);
			}
		}

	//下面的循环继续统计扫描到的数据
	int nHalfvalue;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 9; j++)
		{
			if (position[i][j] != NOCHESS)
			{
				nChessType = position[i][j];
				nHalfvalue = m_BaseValue[nChessType] / 16;      //棋子基本价值的1/16作为威胁/保护增量			
				m_chessValue[i][j] += m_BaseValue[nChessType];//每个棋子的基本价值加入其总价值
				if (IsRed(nChessType))//红棋
				{
					if (m_AttackPos[i][j])//当前红棋如果被威胁
					{
						if (bIsRedTurn)//轮到红棋走
						{
							if (nChessType == R_KING)//如果是红将
								m_chessValue[i][j] -= 20;//价值降低20
							else
							{
								//价值减去2倍nHalfvalue
								m_chessValue[i][j] -= nHalfvalue * 2;
								if (m_GuardPos[i][j])//是否被己方棋子保护
									m_chessValue[i][j] += nHalfvalue;//被保护再加上nHalfvalue
							}
						}
						else//当前红棋被威胁，轮到黑棋走
						{
							if (nChessType == R_KING)//是否是红帅
								return 18888;//返回失败极值	
							m_chessValue[i][j] -= nHalfvalue * 10;//减去10倍的nHalfvalue,表示威胁程度高
							if (m_GuardPos[i][j])//如果被保护
								m_chessValue[i][j] += nHalfvalue * 9;//被保护再加上9倍的nHalfvalue
						}
						//被威胁的棋子加上威胁差，防止一个兵威胁
						//一个被保护的车，而估值函数没有反映此类问题
						m_chessValue[i][j] -= m_AttackPos[i][j];
					}
					else
					{
						//没受威胁
						if (m_GuardPos[i][j])
							m_chessValue[i][j] += 5;//受保护，加一点分
					}
				}
				else
				{
					//如果是黑棋
					if (m_AttackPos[i][j])
					{
						//受威胁
						if (!bIsRedTurn)
						{
							//轮到黑棋走
							if (nChessType == B_KING)//如果是黑将
								m_chessValue[i][j] -= 20;//棋子价值降低20
							else
							{
								//棋子价值降低2倍nHalfvalue
								m_chessValue[i][j] -= nHalfvalue * 2;
								if (m_GuardPos[i][j])//如果受保护									
									m_chessValue[i][j] += nHalfvalue;//棋子价值增加nHalfvalue
							}
						}
						else
						{
							//轮到红棋走
							if (nChessType == B_KING)//是黑将
								return 18888;//返回失败极值							
							m_chessValue[i][j] -= nHalfvalue * 10;//棋子价值减少10倍nHalfvalue
							if (m_GuardPos[i][j])//受保护
								m_chessValue[i][j] += nHalfvalue * 9;//被保护再加上9倍nHalfvalue
						}
						//被威胁的棋子再加上威胁差
						//防止一个兵威胁一个被保护的车,而估值函数没有反映此类的问题
						m_chessValue[i][j] -= m_AttackPos[i][j];
					}
					else
					{
						//不受威胁
						if (m_GuardPos[i][j])
							m_chessValue[i][j] += 5;//受保护，加一点分
					}
				}
			}
		}

	//以上统计了每个棋子的总价值
	//下面统计红黑两方总分
	int nRedValue = 0; int nBlackValue = 0;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 9; j++)
		{
			nChessType = position[i][j];
			if (nChessType != NOCHESS)
			{
				if (IsRed(nChessType))
					nRedValue += m_chessValue[i][j];  //把红棋的值加总
				else
					nBlackValue += m_chessValue[i][j];//把红棋的值加总
			}
		}

	
	if (nUserChessColor == REDCHESS)
	{
		if (bIsRedTurn)
			return nRedValue - nBlackValue;//如果轮到红棋走返回估值

		return nBlackValue - nRedValue;//如果轮到黑棋走返回负估值
	}

	if (bIsRedTurn)
		return nBlackValue - nRedValue;//如果轮到黑棋走返回负估值			

	return nRedValue - nBlackValue;//如果轮到红棋走返回估值
}

void InitEval(void)
{
	//初始化每种棋子的基本价值数组
	m_BaseValue[B_KING] = BASEVALUE_KING;
	m_BaseValue[B_CAR] = BASEVALUE_CAR;
	m_BaseValue[B_HORSE] = BASEVALUE_HORSE;
	m_BaseValue[B_BISHOP] = BASEVALUE_BISHOP;
	m_BaseValue[B_ELEPHANT] = BASEVALUE_ELEPHANT;
	m_BaseValue[B_CANON] = BASEVALUE_CANON;
	m_BaseValue[B_PAWN] = BASEVALUE_PAWN;

	m_BaseValue[R_KING] = BASEVALUE_KING;
	m_BaseValue[R_CAR] = BASEVALUE_CAR;
	m_BaseValue[R_HORSE] = BASEVALUE_HORSE;
	m_BaseValue[R_BISHOP] = BASEVALUE_BISHOP;
	m_BaseValue[R_ELEPHANT] = BASEVALUE_ELEPHANT;
	m_BaseValue[R_CANON] = BASEVALUE_CANON;
	m_BaseValue[R_PAWN] = BASEVALUE_PAWN;

	//初始化灵活性分值数组
	m_FlexValue[B_KING] = FLEXIBILITY_KING;
	m_FlexValue[B_CAR] = FLEXIBILITY_CAR;
	m_FlexValue[B_HORSE] = FLEXIBILITY_HORSE;
	m_FlexValue[B_BISHOP] = FLEXIBILITY_BISHOP;
	m_FlexValue[B_ELEPHANT] = FLEXIBILITY_ELEPHANT;
	m_FlexValue[B_CANON] = FLEXIBILITY_CANON;
	m_FlexValue[B_PAWN] = FLEXIBILITY_PAWN;

	m_FlexValue[R_KING] = FLEXIBILITY_KING;
	m_FlexValue[R_CAR] = FLEXIBILITY_CAR;
	m_FlexValue[R_HORSE] = FLEXIBILITY_HORSE;
	m_FlexValue[R_BISHOP] = FLEXIBILITY_BISHOP;
	m_FlexValue[R_ELEPHANT] = FLEXIBILITY_ELEPHANT;
	m_FlexValue[R_CANON] = FLEXIBILITY_CANON;
	m_FlexValue[R_PAWN] = FLEXIBILITY_PAWN;

	m_nAccessCount = 0;
}

int GetRelatePiece(BYTE position[][9], int j, int i)
{
	nPosCount = 0;
	BYTE nChessID;
	BYTE flag;
	int x, y;

	nChessID = position[i][j];

	switch (nChessID)
	{
	case R_KING://红帅
	case B_KING://黑将
		//循环检查九宫之内哪些位置可到达/保护
		//扫描两边就宫包含了照像的情况
		for (y = 0; y < 3; y++)
			for (x = 3; x < 6; x++)
				if (CanTouch(position, j, i, x, y))//能否到达
					AddPoint(x, y);//可达到/保护的位置加入数组

		//循环检查九宫之内哪些位置可到达/保护
		//扫描两边就宫包含了照像的情况
		for (y = 7; y < 10; y++)
			for (x = 3; x < 6; x++)
				if (CanTouch(position, j, i, x, y))//能否到达
					AddPoint(x, y);//可达到/保护的位置加入数组

		break;

	case R_BISHOP://红士
		//循环检查九宫之内哪些位置可到达/保护
		for (y = 7; y < 10; y++)
			for (x = 3; x < 6; x++)
				if (CanTouch(position, j, i, x, y))
					AddPoint(x, y);//可达到/保护的位置加入数组

		break;

	case B_BISHOP://黑士
		//循环检查九宫之内哪些位置可到达/保护
		for (y = 0; y < 3; y++)
			for (x = 3; x < 6; x++)
				if (CanTouch(position, j, i, x, y))
					AddPoint(x, y);//可达到/保护的位置加入数组

		break;

	case R_ELEPHANT://红相
	case B_ELEPHANT://黑象
		//右下
		x = j + 2;
		y = i + 2;
		if (x < 9 && y < 10 && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//右上
		x = j + 2;
		y = i - 2;
		if (x < 9 && y >= 0 && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//左下
		x = j - 2;
		y = i + 2;
		if (x >= 0 && y < 10 && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//左上
		x = j - 2;
		y = i - 2;
		if (x >= 0 && y >= 0 && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		break;

	case R_HORSE://红马
	case B_HORSE://黑马
		//检查右下方能否到达/保护
		x = j + 2;
		y = i + 1;
		if ((x < 9 && y < 10) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查右上方能否到达/保护
		x = j + 2;
		y = i - 1;
		if ((x < 9 && y >= 0) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查左下方能否到达/保护
		x = j - 2;
		y = i + 1;
		if ((x >= 0 && y < 10) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查左上方能否到达/保护
		x = j - 2;
		y = i - 1;
		if ((x >= 0 && y >= 0) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查右下方能否到达/保护
		x = j + 1;
		y = i + 2;
		if ((x < 9 && y < 10) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查右上方能否到达/保护
		x = j + 1;
		y = i - 2;
		if ((x < 9 && y >= 0) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查左下方能否到达/保护
		x = j - 1;
		y = i + 2;
		if ((x >= 0 && y < 10) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		//检查左上方能否到达/保护
		x = j - 1;
		y = i - 2;
		if ((x >= 0 && y >= 0) && CanTouch(position, j, i, x, y))
			AddPoint(x, y);

		break;

	case R_CAR://红车
	case B_CAR://黑车
		//检查向右能否到达/保护
		x = j + 1;
		y = i;
		while (x < 9)
		{
			if (NOCHESS == position[y][x])//空白
				AddPoint(x, y);
			else {
				//碰到第一个棋子
				AddPoint(x, y);
				break;//后面的位置不能走了
			}
			x++;
		}

		//检查向左能否到达/保护
		x = j - 1;
		y = i;
		while (x >= 0)
		{
			if (NOCHESS == position[y][x])//空白
				AddPoint(x, y);
			else {
				//碰到第一个棋子
				AddPoint(x, y);
				break;//后面的位置不能走了
			}
			x--;
		}

		//检查向下能否到达/保护
		x = j;
		y = i + 1;
		while (y < 10)
		{
			if (NOCHESS == position[y][x])//空白
				AddPoint(x, y);
			else {
				//碰到第一个棋子
				AddPoint(x, y);
				break;//后面的位置不能走了
			}
			y++;
		}

		//检查向上能否到达/保护
		x = j;
		y = i - 1;
		while (y >= 0)
		{
			if (NOCHESS == position[y][x])//空白
				AddPoint(x, y);
			else {
				//碰到第一个棋子
				AddPoint(x, y);
				break;//后面的位置不能走了
			}
			y--;
		}

		break;

	case R_PAWN://红兵
		//观看向前是否到底
		y = i - 1;
		x = j;
		if (y >= 0)
			AddPoint(x, y);//没到底，可走
		if (i < 5)
		{
			//如已过河
			y = i;
			x = j + 1;//向右
			if (x < 9)
				AddPoint(x, y);//未到右边，可走
			x = j - 1;//向左
			if (x >= 0)
				AddPoint(x, y);//未到左边，可走
		}

		break;

	case B_PAWN://黑卒
		//观看向前是否到底
		y = i + 1;
		x = j;
		if (y < 10)
			AddPoint(x, y);//没到底，可走
		if (i > 4)
		{
			//如已过河
			y = i;
			x = j + 1;//向右
			if (x < 9)
				AddPoint(x, y);//未到右边，可走
			x = j - 1;//向左
			if (x >= 0)
				AddPoint(x, y);//未到左边，可走
		}

		break;

	case B_CANON://黑炮
	case R_CANON://红炮
		//检查向右能否到达/保护的位置
		x = j + 1;
		y = i;
		flag = FALSE;
		while (x < 9)
		{
			if (NOCHESS == position[y][x])
			{
				//空白位置
				if (!flag)
					AddPoint(x, y);
			}
			else
			{
				if (!flag)
					flag = TRUE;//是第一个棋子
				else
				{
					//是第二个棋子
					AddPoint(x, y);
					break;
				}
			}
			x++;//继续向右
		}

		//检查向左能否到达/保护的位置
		x = j - 1;
		y = i;
		flag = FALSE;
		while (x >= 0)
		{
			if (NOCHESS == position[y][x])
			{
				//空白位置
				if (!flag)
					AddPoint(x, y);
			}
			else
			{
				if (!flag)
					flag = TRUE;//是第一个棋子
				else
				{
					//是第二个棋子
					AddPoint(x, y);
					break;
				}
			}
			x--;//继续向左
		}

		//检查向下能否到达/保护的位置
		x = j;
		y = i + 1;
		flag = FALSE;
		while (y < 10)
		{
			if (NOCHESS == position[y][x])
			{
				//空白位置
				if (!flag)
					AddPoint(x, y);
			}
			else
			{
				if (!flag)
					flag = TRUE;//是第一个棋子
				else
				{
					//是第二个棋子
					AddPoint(x, y);
					break;
				}
			}
			y++;//继续向下
		}

		//检查向上能否到达/保护的位置
		x = j;
		y = i - 1;
		flag = FALSE;
		while (y >= 0)
		{
			if (NOCHESS == position[y][x])
			{
				//空白位置
				if (!flag)
					AddPoint(x, y);
			}
			else
			{
				if (!flag)
					flag = TRUE;//是第一个棋子
				else
				{
					//是第二个棋子
					AddPoint(x, y);
					break;
				}
			}
			y--;//继续向上
		}

		break;

	default:
		break;
	}

	return nPosCount;
}

bool CanTouch(BYTE position[][9], int nFromX, int nFromY, int nToX, int nToY)
{
	int i, j;
	int nMoveChessID, nTargetID;

	if (nFromX == nToX && nFromY == nToY)
		return false;//目的与源相同，非法

	nMoveChessID = position[nFromX][nFromY];
	nTargetID = position[nToX][nToY];

	if (IsSameSide(nMoveChessID, nTargetID))
		return false;//吃自己的棋，非法

	switch (nMoveChessID)
	{
	case B_KING://黑将
		if (nTargetID == R_KING)//判断是否将帅见面
		{
			if (nFromX != nToX)//横坐标不相等
				return false;//将帅不在同一列

			for (i = nFromY + 1; i < nToY; i++)
				if (position[i][nFromX] != NOCHESS)
					return false;//中间隔有棋子
		}
		else
		{
			if (nToY > 2 || nToX > 5 || nToX < 3)
				return false;//目标点在九宫之外

			if (abs(nFromY - nToY) + abs(nFromX - nToX) > 1)
				return false;//将帅只走一步直线
		}

		break;

	case R_KING://红帅
		if (nTargetID == B_KING)//判断是否将帅见面
		{
			if (nFromX != nToX)//横坐标不相等
				return false;//将帅不在同一列

			for (i = nFromY - 1; i > nToY; i--)
				if (position[i][nFromX] != NOCHESS)
					return false;//中间隔有棋子
		}
		else
		{
			if (nToY < 7 || nToX>5 || nToX < 3)
				return false;//目标点在九宫之外

			if (abs(nFromY - nToY) + abs(nFromX - nToX) > 1)
				return false;//将帅只走一步直线
		}

		break;

	case R_BISHOP://红士
		if (nToY < 7 || nToX>5 || nToX < 3)
			return false;//士出九宫

		if (abs(nFromX - nToX) != 1 || abs(nFromY - nToY) != 1)
			return false;//士走斜线

		break;

	case B_BISHOP://黑士
		if (nToY > 2 || nToX > 5 || nToX < 3)
			return false;//士出九宫

		if (abs(nFromX - nToX) != 1 || abs(nFromY - nToY) != 1)
			return false;//士走斜线

		break;

	case R_ELEPHANT://红相
		if (nToY < 5)
			return false;//相不能过河

		if (abs(nFromX - nToX) != 2 || abs(nFromY - nToY) != 2)
			return false;//相走田字

		if (position[(nFromY + nToY) / 2][(nFromX + nToX) / 2] != NOCHESS)
			return FALSE;//相眼被塞

		break;

	case B_ELEPHANT://黑象
		if (nToY > 4)
			return false;//象不能过河

		if (abs(nFromX - nToX) != 2 || abs(nFromY - nToY) != 2)
			return false;//象走田字

		if (position[(nFromY + nToY) / 2][(nFromX + nToX) / 2] != NOCHESS)
			return FALSE;//象眼被塞

		break;

	case B_PAWN://黑卒
		if (nToY < nFromY)
			return false;//卒不能回头

		if (nFromY < 5 && nFromY == nToY)
			return FALSE;//卒过河前只能直走

		if (nToY - nFromY + abs(nToX - nFromX) > 1)
			return FALSE;//卒只走一步直线

		break;

	case R_PAWN://红兵
		if (nToY < nFromY)
			return false;//兵不能回头

		if (nFromY > 4 && nFromY == nToY)
			return FALSE;//兵过河前只能直走

		if (nToY - nFromY + abs(nToX - nFromX) > 1)
			return FALSE;//兵只走一步直线

		break;

	case B_CAR://黑车
	case R_CAR://红车
		if (nFromY != nToY && nFromX != nToX)
			return FALSE;//车走直线

		if (nFromY == nToY)
		{
			if (nFromX < nToX)
			{
				for (i = nFromX + 1; i < nToX; i++)
					if (position[nFromY][i] != NOCHESS)
						return FALSE;
			}
			else
			{
				for (i = nToX + 1; i < nFromX; i++)
					if (position[nFromY][i] != NOCHESS)
						return FALSE;
			}
		}
		else
		{
			if (nFromY < nToY)
			{
				for (j = nFromY + 1; j < nToY; j++)
					if (position[j][nFromX] != NOCHESS)
						return FALSE;
			}
			else
			{
				for (j = nToY + 1; j < nFromY; j++)
					if (position[j][nFromX] != NOCHESS)
						return FALSE;
			}
		}

		break;

	case B_HORSE://黑马
	case R_HORSE://红马
		if (!((abs(nToX - nFromX) == 1 && abs(nToY - nFromY) == 2) || (abs(nToX - nFromX) == 2 && abs(nToY - nFromY) == 1)))
			return FALSE;//马走日字

		if (nToX - nFromX == 2)
		{
			i = nFromX + 1;
			j = nFromY;
		}
		else
			if (nFromX - nToX == 2)
			{
				i = nFromX - 1;
				j = nFromY;
			}
			else
				if (nToY - nFromY == 2)
				{
					i = nFromX;
					j = nFromY + 1;
				}
				else
					if (nFromY - nToY == 2)
					{
						i = nFromX;
						j = nFromY - 1;
					}

		if (position[j][i] != NOCHESS)
			return FALSE;//绊马腿

		break;

	case B_CANON://黑炮
	case R_CANON://红炮
		if (nFromY != nToY && nFromX != nToX)
			return FALSE;//炮走直线

		//炮吃子时经过的路线中不能有棋子
		if (position[nToY][nToX] == NOCHESS)
		{
			if (nFromY == nToY)
			{
				if (nFromX < nToX)
				{
					for (i = nFromX + 1; i < nToX; i++)
						if (position[nFromY][i] != NOCHESS)
							return FALSE;
				}
				else
				{
					for (i = nToX + 1; i < nFromX; i++)
						if (position[nFromY][i] != NOCHESS)
							return FALSE;
				}
			}
			else
			{
				if (nFromY < nToY)
				{
					for (j = nFromY + 1; j < nToY; j++)
						if (position[j][nFromX] != NOCHESS)
							return FALSE;
				}
				else
				{
					for (j = nToY + 1; j < nFromY; j++)
						if (position[j][nFromX] != NOCHESS)
							return FALSE;
				}
			}
		}
		else//炮吃子时
		{
			int j = 0;
			if (nFromY == nToY)
			{
				if (nFromX < nToX)
				{
					for (i = nFromX + 1; i < nToX; i++)
						if (position[nFromY][i] != NOCHESS)
							j++;
					if (j != 1)
						return FALSE;
				}
				else
				{
					for (i = nToX + 1; i < nFromX; i++)
						if (position[nFromY][i] != NOCHESS)
							j++;
					if (j != 1)
						return FALSE;
				}
			}
			else
			{
				if (nFromY < nToY)
				{
					for (j = nFromY + 1; j < nToY; j++)
						if (position[j][nFromX] != NOCHESS)
							j++;
					if (j != 1)
						return FALSE;
				}
				else
				{
					for (j = nToY + 1; j < nFromY; j++)
						if (position[j][nFromX] != NOCHESS)
							j++;
					if (j != 1)
						return FALSE;
				}
			}
		}

		break;

	default:
		return false;
	}

	return true;
}

void AddPoint(int x, int y)
{
	RelatePos[nPosCount].x = x;
	RelatePos[nPosCount].y = y;

	nPosCount++;
}

int GetBingValue(int x, int y, BYTE CurSituation[][9])
{
	if (CurSituation[y][x] == R_PAWN)
		return BA0[y][x];

	if (CurSituation[y][x] == B_PAWN)
		return BA1[y][x];

	return 0;
}