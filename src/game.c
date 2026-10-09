/*******************************************************************************
* GAME.C - the rules of Kaboooom!
*
* Ported from the Sibyl Pascal units KBWin.pas and KBCommon.pas by
* Michael G. Slack. The computer evaluation is a new, simpler solver: it
* repeats three rules until nothing new is found, so it can not run endlessly
* (the Pascal version could, as its readme says).
*******************************************************************************/

#include <stdlib.h>
#include <time.h>
#include <string.h>

#include "game.h"

int     SafeGame      = 1;
int     RandomBomb    = 1;
int     NumberOfMines = 25;

int     GameBoard[GRID_X][GRID_Y];
int     UserMarked[GRID_X][GRID_Y];
int     UserX, UserY;
int     ShowBombs;
int     I_Helped;
int     GameOver;
int     EvalVisited, EvalMarked;


void GameSeed(void)
{
    srand( (unsigned)time(NULL) );
}


static int Rnd(int n)
{
    return rand() % n;
}


int CountMines(int x, int y)
{
    int i, j, n = 0;

    for( i = -1; i <= 1; i++ )
        for( j = -1; j <= 1; j++ )
            if( x + i >= 0 && x + i < GRID_X && y + j >= 0 && y + j < GRID_Y )
                if( GameBoard[x + i][y + j] == B_BOMB ||
                    GameBoard[x + i][y + j] == B_EXPLODED )
                    n++;
    return n;
}


/* Start and home must not be walled in: at most two of the three cells in
   front of them may hold a mine. */
static int WallsIn(int x, int y, int start)
{
    int k = 0;

    if( GameBoard[x - 1][y] == B_BOMB ) k++;
    if( GameBoard[x][y - 1] == B_BOMB ) k++;
    if( start )
    {
        if( GameBoard[x][y] == B_BOMB ) k++;
    }
    else if( GameBoard[x - 1][y - 1] == B_BOMB )
        k++;

    return k >= 2;
}


void GameNew(void)
{
    int n, i, j, ok;

    if( RandomBomb )
        NumberOfMines = Rnd( MAX_MINES - MIN_MINES + 1 ) + MIN_MINES;

    memset( GameBoard, 0, sizeof(GameBoard) );
    memset( UserMarked, 0, sizeof(UserMarked) );
    UserX = UserY = 0;
    ShowBombs = I_Helped = GameOver = 0;
    EvalVisited = EvalMarked = 0;

    GameBoard[0][0] = B_CURRENT;
    GameBoard[GRID_X - 1][GRID_Y - 1] = B_FINISH;

    for( n = 0; n < NumberOfMines; n++ )
    {
        do
        {
            i = Rnd( GRID_X );
            j = Rnd( GRID_Y );
            ok = (GameBoard[i][j] == B_EMPTY);

            if( ok )
            {
                if( i <= 1 && j <= 1 )
                    ok = !WallsIn( 1, 1, 1 );
                else if( i >= GRID_X - 2 && j >= GRID_Y - 2 )
                    ok = !WallsIn( GRID_X - 1, GRID_Y - 1, 0 );
            }
        } while( !ok );

        GameBoard[i][j] = B_BOMB;
    }
}


int GameTravel(int dx, int dy)
{
    int nx = UserX + dx, ny = UserY + dy;

    if( GameOver )
        return TR_OUTSIDE;
    if( nx < 0 || nx >= GRID_X || ny < 0 || ny >= GRID_Y )
        return TR_OUTSIDE;
    if( SafeGame && UserMarked[nx][ny] > 0 )
        return TR_MARKED;

    GameBoard[UserX][UserY] = B_VISITED;

    if( GameBoard[nx][ny] == B_BOMB )
    {
        GameBoard[nx][ny] = B_EXPLODED;
        GameOver  = 1;
        ShowBombs = 1;
        return TR_BOOM;
    }

    UserX = nx;
    UserY = ny;
    GameBoard[UserX][UserY] = B_CURRENT;

    if( UserX == GRID_X - 1 && UserY == GRID_Y - 1 )
    {
        GameOver  = 1;
        ShowBombs = 1;
        return TR_WON;
    }

    return TR_OK;
}


int GameMark(int x, int y)
{
    if( GameOver )
        return MK_FAR;
    if( x < UserX - 1 || x > UserX + 1 || y < UserY - 1 || y > UserY + 1 )
        return MK_FAR;
    if( x == UserX && y == UserY )
        return MK_CURRENT;

    UserMarked[x][y] = UserMarked[x][y] > 0 ? 0 : 1;
    return MK_OK;
}


/*** Computer evaluation ******************************************************/

static int known[GRID_X][GRID_Y];       /* the number around it is known     */
static int mine[GRID_X][GRID_Y];        /* proven to be a mine               */

struct Cell { int x, y; };

/* The cells next to (x,y) that are neither known nor proven mines. */
static int Unknown(int x, int y, struct Cell *u, int *need)
{
    int dx, dy, n = 0, mines = 0;

    for( dx = -1; dx <= 1; dx++ )
        for( dy = -1; dy <= 1; dy++ )
        {
            int cx = x + dx, cy = y + dy;

            if( (dx == 0 && dy == 0) || cx < 0 || cx >= GRID_X || cy < 0 || cy >= GRID_Y )
                continue;
            if( mine[cx][cy] )
                mines++;
            else if( !known[cx][cy] )
            {
                u[n].x = cx;
                u[n].y = cy;
                n++;
            }
        }

    *need = CountMines( x, y ) - mines;
    return n;
}


static int Reveal(int x, int y)
{
    if( known[x][y] || GameBoard[x][y] == B_BOMB )
        return 0;

    known[x][y] = 1;
    if( GameBoard[x][y] == B_EMPTY )
        GameBoard[x][y] = B_VISITED;    /* home keeps its picture            */
    UserMarked[x][y] = 0;
    EvalVisited++;
    return 1;
}


static int SetMine(int x, int y)
{
    if( mine[x][y] )
        return 0;

    mine[x][y] = 1;
    if( !UserMarked[x][y] )
        EvalMarked++;
    UserMarked[x][y] = 1;
    return 1;
}


static int InList(const struct Cell *l, int n, int x, int y)
{
    int i;

    for( i = 0; i < n; i++ )
        if( l[i].x == x && l[i].y == y )
            return 1;
    return 0;
}


void GameEvaluate(void)
{
    int x, y, changed, i, k;
    int ax, ay, bx, by;

    I_Helped = 1;
    EvalVisited = EvalMarked = 0;

    memset( known, 0, sizeof(known) );
    memset( mine, 0, sizeof(mine) );

    for( x = 0; x < GRID_X; x++ )
        for( y = 0; y < GRID_Y; y++ )
            if( GameBoard[x][y] == B_VISITED || GameBoard[x][y] == B_CURRENT )
                known[x][y] = 1;

    do
    {
        changed = 0;

        for( x = 0; x < GRID_X; x++ )
            for( y = 0; y < GRID_Y; y++ )
            {
                struct Cell u[8];
                int need, n;

                if( !known[x][y] )
                    continue;

                n = Unknown( x, y, u, &need );
                if( n == 0 )
                    continue;

                if( need == 0 )                 /* no mines left: all safe   */
                {
                    for( i = 0; i < n; i++ )
                        changed |= Reveal( u[i].x, u[i].y );
                }
                else if( need == n )            /* as many mines as cells    */
                {
                    for( i = 0; i < n; i++ )
                        changed |= SetMine( u[i].x, u[i].y );
                }
            }

        /* two numbers whose unknown cells overlap: compare them */
        for( ax = 0; ax < GRID_X; ax++ )
            for( ay = 0; ay < GRID_Y; ay++ )
            {
                struct Cell ua[8];
                int na, needa;

                if( !known[ax][ay] )
                    continue;
                na = Unknown( ax, ay, ua, &needa );
                if( na == 0 )
                    continue;

                for( bx = ax - 2; bx <= ax + 2; bx++ )
                    for( by = ay - 2; by <= ay + 2; by++ )
                    {
                        struct Cell ub[8], diff[8];
                        int nb, needb, nd = 0, subset = 1;

                        if( bx < 0 || bx >= GRID_X || by < 0 || by >= GRID_Y )
                            continue;
                        if( (bx == ax && by == ay) || !known[bx][by] )
                            continue;

                        nb = Unknown( bx, by, ub, &needb );
                        if( nb <= na )
                            continue;

                        for( k = 0; k < na && subset; k++ )
                            if( !InList( ub, nb, ua[k].x, ua[k].y ) )
                                subset = 0;
                        if( !subset )
                            continue;

                        for( k = 0; k < nb; k++ )
                            if( !InList( ua, na, ub[k].x, ub[k].y ) )
                                diff[nd++] = ub[k];

                        if( needb - needa == 0 )
                        {
                            for( k = 0; k < nd; k++ )
                                changed |= Reveal( diff[k].x, diff[k].y );
                        }
                        else if( needb - needa == nd )
                        {
                            for( k = 0; k < nd; k++ )
                                changed |= SetMine( diff[k].x, diff[k].y );
                        }
                    }
            }
    } while( changed );
}
