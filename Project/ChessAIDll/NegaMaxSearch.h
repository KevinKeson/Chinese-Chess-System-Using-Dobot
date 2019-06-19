#pragma once
#ifndef NEGAMAXSEARCH_H
#define NEGAMAXSEARCH_H
#include "windows.h"

#define BLACKCHESS 1//黑方
#define REDCHESS   2//红方

//--------棋子--------
#define NOCHESS    0 //没有棋子

#define B_KING	   1 //黑帅
#define B_CAR	   2 //黑车
#define B_HORSE	   3 //黑马
#define B_CANON	   4 //黑炮
#define B_BISHOP   5 //黑士
#define B_ELEPHANT 6 //黑象
#define B_PAWN     7 //黑卒
#define B_BEGIN    B_KING
#define B_END      B_PAWN

#define R_KING	   8 //红将
#define R_CAR      9 //红车
#define R_HORSE    10//红马
#define R_CANON    11//红炮
#define R_BISHOP   12//红士
#define R_ELEPHANT 13//红相
#define R_PAWN     14//红兵
#define R_BEGIN    R_KING
#define R_END      R_PAWN
//--------------------

#define IsBlack(x) (x>=B_BEGIN && x<=B_END)//判断某个棋子是不是黑色
#define IsRed(x)   (x>=R_BEGIN && x<=R_END)//判断某个棋子是不是红色

#define IsSameSide(x,y) ((IsBlack(x) && IsBlack(y)) || (IsRed(x) && IsRed(y)))


//---------------------Evaluation------------------------
//定义每种棋子价值
//兵100，士250，象250，车500，马350，炮350，王无穷大
//#define BASEVALUE_PAWN       100
//#define BASEVALUE_BISHOP	 250
//#define BASEVALUE_ELEPHANT   250
//#define BASEVALUE_CAR		 700
//#define BASEVALUE_HORSE		 350
//#define BASEVALUE_CANON		 350
//#define BASEVALUE_KING	     10000
#define BASEVALUE_PAWN       100
#define BASEVALUE_BISHOP	 250
#define BASEVALUE_ELEPHANT   250
#define BASEVALUE_HORSE		 700
#define BASEVALUE_CANON		 700
#define BASEVALUE_CAR		 1400
#define BASEVALUE_KING	     10000

//定义棋子灵活性，也就是每多一个可走位置应加的分值
//兵15，士1，象1，车6，马12，炮6，王0
#define FLEXIBILITY_PAWN	 15
#define FLEXIBILITY_BISHOP   1
#define FLEXIBILITY_ELEPHANT 1
#define FLEXIBILITY_CAR		 6
#define FLEXIBILITY_HORSE	 12
#define FLEXIBILITY_CANON	 6
#define FLEXIBILITY_KING     0

//红兵的附加值矩阵
const int BA0[10][9] =
{
	{0,0,0,0,0,0,0,0,0},
	{120,120,140,150,150,150,140,120,120},
	{120,120,140,150,150,150,140,120,120},
	{100,120,140,140,140,140,140,120,100},
	{100,100,100,100,100,100,100,100,100},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
};

//黑卒的附加值矩阵
const int BA1[10][9] =
{
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{100,100,100,100,100,100,100,100,100},
	{100,120,140,140,140,140,140,120,100},
	{120,120,140,150,150,150,140,120,120},
	{120,120,140,150,150,150,140,120,120},
	{0,0,0,0,0,0,0,0,0},
};
//----------------------------------------------------

//棋子位置
typedef struct
{
	BYTE x;
	BYTE y;
}CHESSMANPOS;

//棋子走法
typedef struct
{
	short nChessID;  //表明是什么棋子
	CHESSMANPOS From;//起始位置
	CHESSMANPOS To;  //走到什么位置
	int Score;       //走法的分数
}CHESSMOVE;

#ifdef __cplusplus
extern "C"
{
#endif
	//---------------------NegaMaxSearch------------------------------------------
	__declspec(dllexport) void SearchAGoodMove(BYTE position[10][9], int UserChessColor);
	__declspec(dllexport) int get_from_x(void);
	__declspec(dllexport) int get_from_y(void);
	__declspec(dllexport) int get_to_x(void);
	__declspec(dllexport) int get_to_y(void);
	void InitEval(void);
	int NegaMax(int nDepth);
	int IsGameOver(BYTE position[][9], int nDepth);//判断游戏是否结束
	BYTE MakeMove(CHESSMOVE* move);
	void UnMakeMove(CHESSMOVE* move, BYTE nChessID);
	//-------------------------------------------------------------------------------

	//--------------------Evaluation-------------------------------------------------
	int Evaluate(BYTE position[10][9], BOOL bIsRedTurn, int nUserChessColor);
	int GetRelatePiece(BYTE position[][9], int j, int i);
	bool CanTouch(BYTE position[][9], int nFromX, int nFromY, int nToX, int nToY);
	void AddPoint(int x, int y);
	int GetBingValue(int x, int y, BYTE CurSituation[][9]);
	//---------------------------------------------------------------------------------

	//--------------------MoveGenerator-----------------------
	int CreatePossibleMove(BYTE position[10][9], int nPly, int nSide);//产生所有可能的走法
	void Gen_KingMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_RBishopMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_BBishopMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_ElephantMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_HorseMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_RPawnMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_BPawnMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_CarMove(BYTE position[10][9], int i, int j, int nPly);
	void Gen_CanonMove(BYTE position[10][9], int i, int j, int nPly);
	BOOL IsValidMove(BYTE position[10][9], int nFromX, int nFromY, int nToX, int nToY, int nUserChessColor);
	int AddMove(int nFromX, int nFromY, int nToX, int nToY, int nPly, int nChessID);
	//--------------------------------------------------------

	//-----------------some gloabl variables--------------------
	extern int m_nUserChessColor;
	extern CHESSMOVE m_cmBestMove;
	extern BYTE CurPosition[10][9];

	extern int m_BaseValue[15];		 //存放棋子基本价值
	extern int m_FlexValue[15];		 //存放棋子灵活性分值
	extern short m_AttackPos[10][9];	 //存放每一位置被威胁的信息
	extern BYTE m_GuardPos[10][9];      //存放每一位置被保护的信息
	extern BYTE m_FlexibilityPos[10][9];//存放每一位置上棋子的灵活性分值
	extern int m_chessValue[10][9];	 //存放每一位置上棋子的总价值
	extern int nPosCount;				 //记录一棋子的相关位置个数
	extern POINT RelatePos[20];		 //记录一棋子的相关位置
	extern long m_nAccessCount;

	extern int m_nMoveCount;//记录m_MoveList中走法的数量
	extern CHESSMOVE m_MoveList[8][80];//存放CreatePossibleMove产生的所有走法的队列
	//---------------------------------------------------------
#ifdef __cplusplus
}
#endif
#endif