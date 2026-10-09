/*******************************************************************************
* MAIN.C - Kaboooom! for OS/2 Presentation Manager
*
* Window, drawing and commands. The rules are in GAME.C.
*
* Copyright (C) 1997-1998 Michael G. Slack (original, Sibyl)
* Copyright (C) 2026 OS2World
*
* Based on the game Kaboooom! written by Alex Lane in Dr. Dobb's Journal
* #163, April 1990, ported to Pascal by M.G.S. in 1990.
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define INCL_OS2MM
#include "kaboooom.h"
#include <os2me.h>
#include "game.h"
#include "lang.h"
#include "prefs.h"
#include "help.h"
#include "dialogs.h"
#include "sounds.h"

/* BLDLEVEL record, readable with bldlevel.exe (plan.txt section 4) */
const char bldlevel[] =
    "@#Michael G. Slack:1.07#@##1## 09 Oct 2026 12:00:00      "
    "ARCAOS:::0::::@@Kaboooom - minefield walking puzzle game for OS/2\r\n\x1a";

/*** Layout (client window coordinates, origin bottom left) *******************/

#define CLIENT_W        980
#define CLIENT_H        500

#define CELL_W          46
#define CELL_H          46
#define GRID_X0         12
#define GRID_Y0         72              /* bottom of the field               */

#define PAD_SIZE        56
#define PAD_GAP         4
#define PAD_X0          763
#define PAD_TOP         466             /* top edge of the pad               */

#define MSG_X           12
#define MSG_Y           10
#define MSG_W           700
#define MSG_H           50

#define INFO_X          734
#define INFO_W          240
#define INFO_TOP        258
#define INFO_LINE_H     40

#define PICT_W          20              /* the 10 x 20 pictures, twice as big */
#define PICT_H          40

/*** Variables ****************************************************************/

HAB         hab;
HWND        hwndFrame;

static HMQ      hmq;
static HWND     hwndClient;
static HWND     hwndObject;             /* parking window for hidden controls */
static BOOL     bFrameHidden;
static HBITMAP  hbmDigit[10];
static HBITMAP  hbmMark, hbmBomb, hbmCurrent, hbmFinish, hbmExploded;
static char     szMsg[256];

#define RGBC(r, g, b)   (((LONG)(r) << 16) | ((LONG)(g) << 8) | (LONG)(b))

static MRESULT EXPENTRY ClientWndProc(HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);
static void Command(USHORT id);


/*** Helpers ******************************************************************/

/* The menu bar, also while the frame controls are hidden */
static HWND GetMenu(void)
{
    return WinWindowFromID( bFrameHidden ? hwndObject : hwndFrame, FID_MENU );
}


static void SetMsg(const char *text)
{
    strncpy( szMsg, text, sizeof(szMsg) - 1 );
    szMsg[sizeof(szMsg) - 1] = 0;
}


static void BombsAroundMsg(void)
{
    char buf[128];

    sprintf( buf, tr(STR_BOMBS_AROUND), CountMines( UserX, UserY ) );
    SetMsg( buf );
}


/* Sounds: the wave files of the sounds folder (a beep when they are missing) */
static void Sound(int kind)
{
    if( Prefs.sound )
        PlayGameSound( kind );
}


static void UpdateButtons(void)
{
    int i;

    for( i = 0; i < 9; i++ )
        WinEnableWindow( WinWindowFromID( hwndClient, IDM_PAD0 + i ), !GameOver );
}


static void Refresh(void)
{
    UpdateButtons();
    WinInvalidateRect( hwndClient, NULL, TRUE );
}


/*** Drawing ******************************************************************/

static void Pict(HPS hps, HBITMAP hbm, LONG x, LONG y, LONG w, LONG h)
{
    POINTL aptl[4];

    if( hbm == NULLHANDLE )
        return;

    aptl[0].x = x;          aptl[0].y = y;
    aptl[1].x = x + w - 1;  aptl[1].y = y + h - 1;
    aptl[2].x = 0;          aptl[2].y = 0;
    aptl[3].x = 10;         aptl[3].y = 20;
    GpiWCBitBlt( hps, hbm, 4, aptl, ROP_SRCCOPY, BBO_IGNORE );
}


static void Box(HPS hps, LONG x0, LONG y0, LONG x1, LONG y1, LONG fill)
{
    POINTL pt;

    GpiSetColor( hps, fill );
    pt.x = x0;  pt.y = y0;  GpiMove( hps, &pt );
    pt.x = x1;  pt.y = y1;  GpiBox( hps, DRO_FILL, &pt, 0, 0 );
}


static void Text(HPS hps, LONG x, LONG y, LONG w, LONG h, const char *s, ULONG flags)
{
    RECTL rcl;

    rcl.xLeft = x;  rcl.yBottom = y;  rcl.xRight = x + w;  rcl.yTop = y + h;
    GpiSetColor( hps, RGBC(1, 1, 1) );
    WinDrawText( hps, -1, (PSZ)s, &rcl, RGBC(1, 1, 1), RGBC(204, 204, 204), flags );
}


/* Draw text wrapped to a width, from the top down; returns the lines used */
static int WrapText(HPS hps, LONG x, LONG top, LONG w, LONG lineh, const char *s, int maxlines)
{
    char    line[256], trial[256];
    int     n = 0;
    const char *p = s;

    line[0] = 0;
    while( *p && n < maxlines )
    {
        int         len = 0;
        POINTL      pt[TXTBOX_COUNT];
        const char *q = p;

        while( *q && *q != ' ' )
            q++;
        len = (int)(q - p);
        if( len > 120 )
            len = 120;

        sprintf( trial, "%s%s%.*s", line, line[0] ? " " : "", len, p );
        GpiQueryTextBox( hps, (LONG)strlen(trial), trial, TXTBOX_COUNT, pt );

        if( line[0] && pt[TXTBOX_BOTTOMRIGHT].x - pt[TXTBOX_BOTTOMLEFT].x > w )
        {
            Text( hps, x, top - (n + 1) * lineh, w, lineh, line, DT_LEFT | DT_VCENTER );
            n++;
            line[0] = 0;
            continue;                           /* try the same word on a new line */
        }

        strcpy( line, trial );
        p = q;
        while( *p == ' ' )
            p++;
    }

    if( line[0] && n < maxlines )
    {
        Text( hps, x, top - (n + 1) * lineh, w, lineh, line, DT_LEFT | DT_VCENTER );
        n++;
    }
    return n;
}


static void DrawCell(HPS hps, int cx, int cy)
{
    LONG    x = GRID_X0 + cx * CELL_W;
    LONG    y = GRID_Y0 + (GRID_Y - 1 - cy) * CELL_H;
    HBITMAP hbm = NULLHANDLE;
    POINTL  pt;

    switch( GameBoard[cx][cy] )
    {
        case B_VISITED:  hbm = hbmDigit[CountMines( cx, cy )];  break;
        case B_CURRENT:  hbm = hbmCurrent;                      break;
        case B_FINISH:   hbm = hbmFinish;                       break;
        case B_EXPLODED: hbm = hbmExploded;                     break;
        case B_BOMB:     if( ShowBombs ) hbm = hbmBomb;         break;
    }

    if( hbm )
        Box( hps, x, y, x + CELL_W - 1, y + CELL_H - 1, RGBC(255, 255, 255) );
    else
    {
        Box( hps, x, y, x + CELL_W - 1, y + CELL_H - 1, RGBC(196, 196, 196) );
        GpiSetColor( hps, RGBC(250, 250, 250) );                 /* raised   */
        pt.x = x + 1;  pt.y = y + 1;  GpiMove( hps, &pt );
        pt.y = y + CELL_H - 2;  GpiLine( hps, &pt );
        pt.x = x + CELL_W - 2;  GpiLine( hps, &pt );
        GpiSetColor( hps, RGBC(120, 120, 120) );
        pt.y = y + 1;  GpiLine( hps, &pt );
        pt.x = x + 1;  GpiLine( hps, &pt );
    }

    GpiSetColor( hps, RGBC(140, 140, 140) );                     /* grid line */
    pt.x = x;  pt.y = y;  GpiMove( hps, &pt );
    pt.x = x + CELL_W - 1;  pt.y = y + CELL_H - 1;
    GpiBox( hps, DRO_OUTLINE, &pt, 0, 0 );

    if( hbm )
        Pict( hps, hbm, x + (CELL_W - PICT_W) / 2, y + (CELL_H - PICT_H) / 2, PICT_W, PICT_H );

    if( UserMarked[cx][cy] > 0 )
    {
        Pict( hps, hbmMark, x + 3, y + (CELL_H - 20) / 2, 10, 20 );
        Pict( hps, hbmMark, x + CELL_W - 13, y + (CELL_H - 20) / 2, 10, 20 );
    }
}


static void PaintGame(HPS hps)
{
    int   i, j;
    char  buf[160], tmp[8];
    LONG  y;

    GpiCreateLogColorTable( hps, 0, LCOLF_RGB, 0, 0, NULL );
    Box( hps, 0, 0, CLIENT_W, CLIENT_H, RGBC(204, 204, 204) );

    for( i = 0; i < GRID_X; i++ )
        for( j = 0; j < GRID_Y; j++ )
            DrawCell( hps, i, j );

    /* messages */
    WrapText( hps, MSG_X, MSG_Y + MSG_H, MSG_W, 22, szMsg, 2 );

    Text( hps, PAD_X0, PAD_TOP + 6, 3 * PAD_SIZE + 2 * PAD_GAP, 22, tr(STR_MOVES),
          DT_CENTER | DT_VCENTER );

    y = INFO_TOP;
    sprintf( buf, tr(STR_BOMBS_IN_GAME), NumberOfMines );
    WrapText( hps, INFO_X, y, INFO_W, 20, buf, 2 );
    y -= INFO_LINE_H;
    sprintf( buf, tr(STR_SAFE_MSG), tr(SafeGame ? STR_ON : STR_OFF) );
    WrapText( hps, INFO_X, y, INFO_W, 20, buf, 2 );
    y -= INFO_LINE_H;
    sprintf( buf, tr(STR_SOUND_MSG), tr(Prefs.sound ? STR_ON : STR_OFF) );
    WrapText( hps, INFO_X, y, INFO_W, 20, buf, 2 );
    y -= INFO_LINE_H;
    sprintf( buf, tr(STR_VERBOSE_MSG), tr(Prefs.verbose ? STR_ON : STR_OFF) );
    WrapText( hps, INFO_X, y, INFO_W, 20, buf, 2 );
    (void)tmp;
}


/* The nine pad buttons are drawn here: an arrow in each direction and a
   question mark in the middle (the computer helps). */
static void DrawPad(PUSERBUTTON pub, int idx)
{
    HPS    hps = pub->hps;
    RECTL  rcl;
    BOOL   down = (pub->fsState & BDS_HILITED) != 0;
    BOOL   dis  = (pub->fsState & BDS_DISABLED) != 0;
    POINTL pt, p[7];
    LONG   cx, cy, o = down ? 1 : 0;

    WinQueryWindowRect( pub->hwnd, &rcl );
    GpiCreateLogColorTable( hps, 0, LCOLF_RGB, 0, 0, NULL );

    Box( hps, rcl.xLeft, rcl.yBottom, rcl.xRight - 1, rcl.yTop - 1, RGBC(204, 204, 204) );
    GpiSetColor( hps, RGBC(60, 60, 60) );
    pt.x = rcl.xLeft;  pt.y = rcl.yBottom;  GpiMove( hps, &pt );
    pt.x = rcl.xRight - 1;  pt.y = rcl.yTop - 1;
    GpiBox( hps, DRO_OUTLINE, &pt, 0, 0 );

    GpiSetColor( hps, down ? RGBC(110, 110, 110) : RGBC(255, 255, 255) );
    pt.x = rcl.xLeft + 1;  pt.y = rcl.yBottom + 1;  GpiMove( hps, &pt );
    pt.y = rcl.yTop - 2;   GpiLine( hps, &pt );
    pt.x = rcl.xRight - 2; GpiLine( hps, &pt );
    GpiSetColor( hps, down ? RGBC(255, 255, 255) : RGBC(110, 110, 110) );
    pt.y = rcl.yBottom + 1;  GpiLine( hps, &pt );
    pt.x = rcl.xLeft + 1;    GpiLine( hps, &pt );

    cx = (rcl.xRight - rcl.xLeft) / 2 + o;
    cy = (rcl.yTop - rcl.yBottom) / 2 - o;

    if( idx == 4 )                              /* the computer helps       */
    {
        RECTL rt = rcl;
        POINTL c;

        GpiSetColor( hps, dis ? RGBC(150, 150, 150) : RGBC(190, 20, 20) );
        c.x = cx;  c.y = cy;  GpiMove( hps, &c );
        GpiFullArc( hps, DRO_FILL, MAKEFIXED(15, 0) );
        GpiSetColor( hps, dis ? RGBC(110, 110, 110) : RGBC(100, 0, 0) );
        GpiMove( hps, &c );
        GpiFullArc( hps, DRO_OUTLINE, MAKEFIXED(15, 0) );

        rt.xLeft += o;  rt.xRight += o;  rt.yBottom -= o;  rt.yTop -= o;
        WinDrawText( hps, -1, (PSZ)"?", &rt, RGBC(255, 255, 255),
                     dis ? RGBC(150, 150, 150) : RGBC(190, 20, 20),
                     DT_CENTER | DT_VCENTER | DT_TEXTATTRS );
        return;
    }
    else
    {
        double ux = (idx % 3) - 1, uy = -((idx / 3) - 1), len;
        double px, py;

        len = sqrt( ux * ux + uy * uy );
        ux /= len;  uy /= len;
        px = -uy;   py = ux;

#define PNT(i, a, b)  p[i].x = cx + (LONG)((a) * ux + (b) * px); p[i].y = cy + (LONG)((a) * uy + (b) * py)
        /* a arrow: shaft and head, in the direction of (ux,uy) */
        PNT(0, -17, -4);  PNT(1, 2, -4);  PNT(2, 2, -11);  PNT(3, 18, 0);
        PNT(4, 2, 11);    PNT(5, 2, 4);   PNT(6, -17, 4);
#undef PNT
        GpiSetColor( hps, dis ? RGBC(150, 150, 150) : RGBC(20, 20, 20) );
        GpiBeginArea( hps, BA_NOBOUNDARY | BA_ALTERNATE );
        GpiMove( hps, &p[0] );
        GpiPolyLine( hps, 6, &p[1] );
        GpiEndArea( hps );
    }
}


/*** Commands *****************************************************************/

static void GameOverPrompt(void)
{
    WinUpdateWindow( hwndClient );

    if( WinMessageBox( HWND_DESKTOP, hwndFrame, tr(STR_GAME_OVER_Q), PRG_NAME, 0,
                       MB_YESNO | MB_QUERY | MB_MOVEABLE ) == MBID_YES )
    {
        Command( IDM_NEW_NOASK );              /* a new game, no question   */
    }
}


static void NewGame(void)
{
    RandomBomb = Prefs.randombomb;
    if( !RandomBomb )
        NumberOfMines = Prefs.bombcount;

    GameNew();
    SetMsg( tr(STR_HINT) );
    Refresh();
}


static void DoNew(void)
{
    if( Prefs.confirms && !GameOver )
        if( WinMessageBox( HWND_DESKTOP, hwndFrame, tr(STR_CONFIRM_NEW), PRG_NAME, 0,
                           MB_YESNO | MB_QUERY | MB_MOVEABLE ) != MBID_YES )
            return;
    NewGame();
}


static void DoMove(int dx, int dy)
{
    char buf[160];
    int  r;

    r = GameTravel( dx, dy );

    switch( r )
    {
        case TR_OUTSIDE:
        case TR_MARKED:
            Sound( 4 );
            strcpy( buf, tr(STR_INVALID) );
            if( r == TR_MARKED )
                strcat( buf, tr(STR_MUST_UNMARK) );
            SetMsg( buf );
            WinInvalidateRect( hwndClient, NULL, TRUE );
            break;

        case TR_BOOM:
            Sound( 3 );
            SetMsg( tr(STR_STEPPED) );
            Refresh();
            GameOverPrompt();
            break;

        case TR_WON:
            Sound( 2 );
            strcpy( buf, tr(STR_WON) );
            if( I_Helped )
                strcat( buf, tr(STR_WITH_HELP) );
            SetMsg( buf );
            Refresh();
            GameOverPrompt();
            break;

        default:
            BombsAroundMsg();
            WinInvalidateRect( hwndClient, NULL, TRUE );
            break;
    }
}


static void DoMark(int x, int y)
{
    int r = GameMark( x, y );

    if( r == MK_CURRENT )
    {
        Sound( 1 );
        SetMsg( tr(STR_CANT_MARK_CUR) );
    }
    else if( r == MK_FAR )
    {
        Sound( 1 );
        SetMsg( tr(STR_CANT_MARK_FAR) );
    }
    WinInvalidateRect( hwndClient, NULL, TRUE );
}


static void DoEval(void)
{
    char buf[160];

    if( GameOver )
        return;

    if( Prefs.confirms )
        if( WinMessageBox( HWND_DESKTOP, hwndFrame, tr(STR_CONFIRM_EVAL), PRG_NAME, 0,
                           MB_YESNO | MB_QUERY | MB_MOVEABLE ) != MBID_YES )
            return;

    GameEvaluate();

    if( EvalVisited + EvalMarked == 0 )
        SetMsg( tr(STR_CANT_DEDUCE) );
    else
    {
        sprintf( buf, tr(STR_EVAL_DONE), EvalVisited, EvalMarked );
        SetMsg( buf );
    }
    if( Prefs.verbose )
        Sound( 1 );

    WinInvalidateRect( hwndClient, NULL, TRUE );
}


/* Hide or show title bar, system menu, minimize button and menu */
static void DoFrame(void)
{
    HWND  hwndNew = bFrameHidden ? hwndFrame : hwndObject;
    HWND  hwndOld = bFrameHidden ? hwndObject : hwndFrame;
    HWND  hMenu;
    RECTL rcl;
    ULONG flChange = FCF_TITLEBAR | FCF_SYSMENU | FCF_MINBUTTON | FCF_MENU;

    WinSetParent( WinWindowFromID( hwndOld, FID_TITLEBAR ), hwndNew, FALSE );
    WinSetParent( WinWindowFromID( hwndOld, FID_SYSMENU ),  hwndNew, FALSE );
    WinSetParent( WinWindowFromID( hwndOld, FID_MINMAX ),   hwndNew, FALSE );
    WinSetParent( WinWindowFromID( hwndOld, FID_MENU ),     hwndNew, FALSE );

    bFrameHidden = !bFrameHidden;

    WinSendMsg( hwndFrame, WM_UPDATEFRAME, MPFROMLONG(flChange), 0 );

    /* keep the client size: the frame loses or regains the decorations */
    rcl.xLeft = 0; rcl.yBottom = 0; rcl.xRight = CLIENT_W; rcl.yTop = CLIENT_H;
    WinCalcFrameRect( hwndFrame, &rcl, FALSE );
    WinSetWindowPos( hwndFrame, HWND_TOP, 0, 0,
                     rcl.xRight - rcl.xLeft, rcl.yTop - rcl.yBottom, SWP_SIZE );

    WinInvalidateRect( hwndFrame, NULL, TRUE );
    WinUpdateWindow( hwndFrame );

    hMenu = GetMenu();
    if( hMenu )
        WinCheckMenuItem( hMenu, IDM_FRAME, bFrameHidden );
}


static void DoSettings(void)
{
    if( SettingsDialog( hwndFrame ) )
    {
        SafeGame      = Prefs.safegame;
        RandomBomb    = Prefs.randombomb;
    }
    WinInvalidateRect( hwndClient, NULL, TRUE );
}


static void DoLanguage(USHORT id)
{
    set_language( GetMenu(), id - IDM_LANG_EN );
    Prefs.current_lang = current_lang;
    SetHelpLanguage();

    if( !GameOver && UserX == 0 && UserY == 0 )
        SetMsg( tr(STR_HINT) );
    else if( !GameOver )
        BombsAroundMsg();
    WinInvalidateRect( hwndClient, NULL, TRUE );
}


static void Command(USHORT id)
{
    HWND hMenu;

    if( id >= IDM_PAD0 && id < IDM_PAD0 + 9 )
    {
        int i = id - IDM_PAD0;

        if( i == 4 )
            DoEval();
        else if( !GameOver )
            DoMove( (i % 3) - 1, (i / 3) - 1 );
        return;
    }

    if( id >= IDM_MARK0 && id < IDM_MARK0 + 9 )
    {
        int i = id - IDM_MARK0;

        if( i != 4 )
            DoMark( UserX + (i % 3) - 1, UserY + (i / 3) - 1 );
        return;
    }

    switch( id )
    {
        case IDM_NEW:        DoNew();                        break;
        case IDM_NEW_NOASK: NewGame();                      break;
        case IDM_EVAL:       DoEval();                       break;
        case IDM_EXIT:       WinPostMsg( hwndClient, WM_CLOSE, 0, 0 ); break;

        case IDM_SETTINGS:   DoSettings();                   break;
        case IDM_FRAME:      DoFrame();                      break;
        case IDM_SAVEONEXIT:
            Prefs.saveonexit = Prefs.saveonexit ? 0 : 1;
            hMenu = GetMenu();
            if( hMenu )
                WinCheckMenuItem( hMenu, IDM_SAVEONEXIT, Prefs.saveonexit );
            break;

        case IDM_LANG_EN: case IDM_LANG_ES: case IDM_LANG_NL:
        case IDM_LANG_DE: case IDM_LANG_FR: case IDM_LANG_IT:
                             DoLanguage( id );               break;

        case IDM_HELPUSING:  HelpForHelp();                  break;
        case IDM_HELPEXT:    HelpContents();                 break;
        case IDM_HELPKEYS:   HelpPanel( HELP_KEYS );         break;
        case IDM_HELPINDEX:  HelpIndex();                    break;
        case IDM_ABOUT:      AboutDialog( hwndFrame );       break;
    }
}


/* A click on a button can reach us as WM_CONTROL (BN_CLICKED) and as
   WM_COMMAND: run it only once. */
static void ButtonClick(USHORT id)
{
    static ULONG  lastTime;
    static USHORT lastId;
    ULONG         now = WinGetCurrentTime( hab );

    if( id == lastId && now - lastTime < 400 )
        return;
    lastId   = id;
    lastTime = now;
    Command( id );
}


/*** Window procedure *********************************************************/

static MRESULT EXPENTRY ClientWndProc(HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2)
{
    HPS   hps;
    RECTL rcl;
    int   i, cx, cy;

    switch( msg )
    {
        case WM_CREATE:
            for( i = 0; i < 9; i++ )
            {
                WinCreateWindow( hwnd, WC_BUTTON, "", WS_VISIBLE | BS_USERBUTTON,
                                 PAD_X0 + (i % 3) * (PAD_SIZE + PAD_GAP),
                                 PAD_TOP - PAD_SIZE - (i / 3) * (PAD_SIZE + PAD_GAP),
                                 PAD_SIZE, PAD_SIZE, hwnd, HWND_TOP, IDM_PAD0 + i, NULL, NULL );
            }
            return 0;

        case WM_ERASEBACKGROUND:
            return 0;

        case MM_MCINOTIFY:
            SoundNotify( mp1, mp2 );
            return 0;

        case WM_PAINT:
            hps = WinBeginPaint( hwnd, NULLHANDLE, &rcl );
            PaintGame( hps );
            WinEndPaint( hps );
            return 0;

        case WM_BUTTON1DOWN:
        case WM_BUTTON2DOWN:
            WinSetFocus( HWND_DESKTOP, hwnd );
            cx = (SHORT1FROMMP(mp1) - GRID_X0);
            cy = (SHORT2FROMMP(mp1) - GRID_Y0);
            if( cx >= 0 && cy >= 0 && cx < GRID_X * CELL_W && cy < GRID_Y * CELL_H && !GameOver )
            {
                cx /= CELL_W;
                cy = GRID_Y - 1 - cy / CELL_H;
                if( msg == WM_BUTTON1DOWN )
                {
                    int dx = cx - UserX, dy = cy - UserY;

                    if( dx >= -1 && dx <= 1 && dy >= -1 && dy <= 1 && (dx || dy) )
                        DoMove( dx, dy );
                    else
                    {
                        Sound( 4 );
                        SetMsg( tr(STR_INVALID) );
                        WinInvalidateRect( hwnd, NULL, TRUE );
                    }
                }
                else
                    DoMark( cx, cy );
            }
            return MRFROMLONG(TRUE);

        case WM_CONTROL:
            for( i = 0; i < 9; i++ )
                if( IDM_PAD0 + i == SHORT1FROMMP(mp1) )
                    break;
            if( i < 9 )
            {
                if( SHORT2FROMMP(mp1) == BN_PAINT )
                    DrawPad( (PUSERBUTTON)PVOIDFROMMP(mp2), i );
                else if( SHORT2FROMMP(mp1) == BN_CLICKED )
                    ButtonClick( SHORT1FROMMP(mp1) );
            }
            return 0;

        case WM_COMMAND:
            if( SHORT1FROMMP(mp2) == CMDSRC_ACCELERATOR || SHORT1FROMMP(mp2) == CMDSRC_MENU )
                Command( SHORT1FROMMP(mp1) );
            else
                ButtonClick( SHORT1FROMMP(mp1) );       /* from a button */
            return 0;
    }

    return WinDefWindowProc( hwnd, msg, mp1, mp2 );
}


/*** Start up and shut down ***************************************************/

static BOOL LoadBitmaps(void)
{
    HPS hps = WinGetPS( hwndClient );
    int i;

    for( i = 0; i < 10; i++ )
        hbmDigit[i] = GpiLoadBitmap( hps, NULLHANDLE, BMP_DIGIT_BASE + i, 0, 0 );
    hbmMark     = GpiLoadBitmap( hps, NULLHANDLE, BMP_MARK, 0, 0 );
    hbmBomb     = GpiLoadBitmap( hps, NULLHANDLE, BMP_BOMB, 0, 0 );
    hbmCurrent  = GpiLoadBitmap( hps, NULLHANDLE, BMP_CURRENT, 0, 0 );
    hbmFinish   = GpiLoadBitmap( hps, NULLHANDLE, BMP_FINISH, 0, 0 );
    hbmExploded = GpiLoadBitmap( hps, NULLHANDLE, BMP_EXPLODED, 0, 0 );

    WinReleasePS( hps );

    for( i = 0; i < 10; i++ )
        if( hbmDigit[i] == NULLHANDLE )
            return FALSE;
    return hbmMark && hbmBomb && hbmCurrent && hbmFinish && hbmExploded;
}


static void FreeBitmaps(void)
{
    int i;

    for( i = 0; i < 10; i++ )
        if( hbmDigit[i] ) GpiDeleteBitmap( hbmDigit[i] );
    if( hbmMark )     GpiDeleteBitmap( hbmMark );
    if( hbmBomb )     GpiDeleteBitmap( hbmBomb );
    if( hbmCurrent )  GpiDeleteBitmap( hbmCurrent );
    if( hbmFinish )   GpiDeleteBitmap( hbmFinish );
    if( hbmExploded ) GpiDeleteBitmap( hbmExploded );
}


int main(void)
{
    QMSG    qmsg;
    ULONG   flFrame = FCF_TITLEBAR | FCF_SYSMENU | FCF_MINBUTTON | FCF_BORDER |
                      FCF_TASKLIST | FCF_MENU | FCF_ACCELTABLE | FCF_ICON;
    RECTL   rcl;
    LONG    cxScreen, cyScreen, w, h;
    HWND    hMenu;

    hab = WinInitialize( 0 );
    hmq = WinCreateMsgQueue( hab, 0 );

    LoadPrefs();
    current_lang  = Prefs.current_lang;
    SafeGame      = Prefs.safegame;
    RandomBomb    = Prefs.randombomb;
    NumberOfMines = Prefs.bombcount;

    GameSeed();

    if( !WinRegisterClass( hab, PRG_NAME, ClientWndProc,
                           CS_SIZEREDRAW | CS_SYNCPAINT | CS_CLIPCHILDREN, 0 ) )
        return 1;

    /* created invisible (style 0), shown after it is sized */
    hwndFrame = WinCreateStdWindow( HWND_DESKTOP, 0, &flFrame, PRG_NAME, PRG_NAME,
                                    0, NULLHANDLE, ID_MAIN, &hwndClient );
    if( !hwndFrame )
        return 1;

    hwndObject = WinCreateWindow( HWND_OBJECT, WC_FRAME, "", 0L, 0, 0, 0, 0,
                                  NULLHANDLE, HWND_TOP, 0, NULL, NULL );

    if( !LoadBitmaps() )
    {
        WinMessageBox( HWND_DESKTOP, HWND_DESKTOP, "Can't load the bitmaps.",
                       PRG_NAME, 0, MB_OK | MB_ERROR | MB_MOVEABLE );
        return 1;
    }

    hMenu = WinWindowFromID( hwndFrame, FID_MENU );
    set_language( hMenu, current_lang );
    WinCheckMenuItem( hMenu, IDM_SAVEONEXIT, Prefs.saveonexit );

    NewGame();

    /* size the frame around the client area and center it */
    rcl.xLeft = 0; rcl.yBottom = 0; rcl.xRight = CLIENT_W; rcl.yTop = CLIENT_H;
    WinCalcFrameRect( hwndFrame, &rcl, FALSE );
    w = rcl.xRight - rcl.xLeft;
    h = rcl.yTop - rcl.yBottom;
    cxScreen = WinQuerySysValue( HWND_DESKTOP, SV_CXSCREEN );
    cyScreen = WinQuerySysValue( HWND_DESKTOP, SV_CYSCREEN );
    WinSetWindowPos( hwndFrame, HWND_TOP, (cxScreen - w) / 2, (cyScreen - h) / 2, w, h,
                     SWP_SIZE | SWP_MOVE | SWP_ACTIVATE | SWP_SHOW );

    SoundOwner( hwndClient );
    SetHelpLanguage();

    while( WinGetMsg( hab, &qmsg, NULLHANDLE, 0, 0 ) )
        WinDispatchMsg( hab, &qmsg );

    if( Prefs.saveonexit )
        SavePrefs();

    CloseHelp();
    CloseSounds();
    FreeBitmaps();
    if( hwndObject )
        WinDestroyWindow( hwndObject );
    WinDestroyWindow( hwndFrame );
    WinDestroyMsgQueue( hmq );
    WinTerminate( hab );

    return 0;
}
