/*******************************************************************************
* KABOOOOM.H - Kaboooom! for OS/2 Presentation Manager
*
* Copyright (C) 1997-1998 Michael G. Slack (original, Sibyl)
* Copyright (C) 2026 OS2World
*
* Based on the game Kaboooom! written by Alex Lane in Dr. Dobb's Journal
* #163, April 1990.
*******************************************************************************/

#ifndef KABOOOOM_H
#define KABOOOOM_H

#define INCL_WIN
#define INCL_WINHELP
#define INCL_GPI
#define INCL_DOS
#define INCL_DOSPROCESS
#define INCL_DOSMODULEMGR
#define INCL_DOSFILEMGR
#include <os2.h>

#define PRG_NAME        "Kaboooom"
#define PRG_VERSION     "1.07"

/*** Resource ids *************************************************************/

#define ID_MAIN             555         /* menu, accelerator table and icon  */

/* Game menu 100-199 */
#define IDM_NEW             100
#define IDM_EVAL            101
#define IDM_NEW_NOASK       108         /* a new game without a question     */
#define IDM_EXIT            107
#define IDM_PAD0            130         /* 130..138: the 3 x 3 pad, row by row */
#define IDM_PAD_EVAL        134         /* the middle button: computer help  */
#define IDM_MARK0           150         /* 150..158: mark the cell in that direction */

/* Options menu 200-299 */
#define IDM_SETTINGS        200
#define IDM_FRAME           205
#define IDM_SAVEONEXIT      206

/* Language menu 300-399 */
#define IDM_LANG_EN         300
#define IDM_LANG_ES         301
#define IDM_LANG_NL         302
#define IDM_LANG_DE         303
#define IDM_LANG_FR         304
#define IDM_LANG_IT         305

/* Help menu 900-999 */
#define IDM_HELPUSING       901
#define IDM_HELPEXT         902
#define IDM_HELPKEYS        903
#define IDM_HELPINDEX       904
#define IDM_ABOUT           999
#define IDM_ESCAPE          998

/* Cascade ids 1000-1099 */
#define IDM_SUBMENU_GAME    1000
#define IDM_SUBMENU_OPTIONS 1001
#define IDM_SUBMENU_LANG    1002
#define IDM_SUBMENU_HELP    1003

/* Dialogs */
#define DLG_ABOUT           501
#define DLG_SETTINGS        502

#define IDD_SAFE            510
#define IDD_SOUND           511
#define IDD_VERBOSE         512
#define IDD_CONFIRM         513
#define IDD_RANDOM          514
#define IDD_NUMTXT          515
#define IDD_NUM             516
#define IDD_RANGE           517

/* Bitmaps */
#define BMP_DIGIT_BASE      1000        /* +0..9                             */
#define BMP_MARK            2000
#define BMP_BOMB            2001
#define BMP_CURRENT         2002
#define BMP_FINISH          2003
#define BMP_EXPLODED        2004

/* Help panels (the same numbers in every language file) */
#define HELP_GENERAL        1000
#define HELP_PLAY           1100
#define HELP_KEYS           1200
#define HELP_SETTINGS       1300
#define HELP_COMPUTER       1400
#define HELP_ABOUT          1500
#define HELP_TABLE_ID       555

/* Language ids (plan.txt section 8) */
#define LANG_EN             0
#define LANG_ES             1
#define LANG_NL             2
#define LANG_DE             3
#define LANG_FR             4
#define LANG_IT             5
#define LANG_COUNT          6

#endif /* KABOOOOM_H */
