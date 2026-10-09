/*******************************************************************************
* GAME.H - the rules of Kaboooom!, no user interface in here
*
* You walk from the top left corner to the bottom right corner of a field of
* 15 x 9 cells. Mines are hidden on the way. Every cell you have walked on
* shows how many mines are around it. You can mark cells next to you where
* you think a mine is, and the computer can try to work out your position.
*******************************************************************************/

#ifndef GAME_H
#define GAME_H

#define GRID_X          15
#define GRID_Y          9
#define MIN_MINES       10
#define MAX_MINES       40

/* cell types */
enum { B_EMPTY = 0, B_VISITED, B_BOMB, B_CURRENT, B_FINISH, B_EXPLODED };

/* result of a move */
enum { TR_OK = 0, TR_OUTSIDE, TR_MARKED, TR_BOOM, TR_WON };

/* result of marking */
enum { MK_OK = 0, MK_CURRENT, MK_FAR };

/* options used by the rules */
extern int  SafeGame;                   /* never step on a marked cell       */
extern int  RandomBomb;                 /* a new random number of mines      */
extern int  NumberOfMines;

/* the game */
extern int  GameBoard[GRID_X][GRID_Y];
extern int  UserMarked[GRID_X][GRID_Y];
extern int  UserX, UserY;
extern int  ShowBombs;                  /* end of the game: show every mine  */
extern int  I_Helped;                   /* the computer evaluated            */
extern int  GameOver;

/* what the last evaluation did */
extern int  EvalVisited, EvalMarked;

void GameSeed(void);
void GameNew(void);                     /* new field (new count if random)   */
int  CountMines(int x, int y);          /* mines around (and in) a cell      */
int  GameTravel(int dx, int dy);
int  GameMark(int x, int y);            /* toggles the mark of a cell        */
void GameEvaluate(void);                /* computer help                     */

#endif /* GAME_H */
