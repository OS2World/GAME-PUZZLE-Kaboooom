/*******************************************************************************
* DIALOGS.C - About and settings dialogs
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "kaboooom.h"
#include "game.h"
#include "lang.h"
#include "prefs.h"
#include "dialogs.h"


/* Center a dialog over its owner */
static void CenterDialog(HWND hwnd)
{
    HWND  hwndOwner = WinQueryWindow( hwnd, QW_OWNER );
    SWP   swpDlg, swpOwner;
    LONG  x, y;

    if( hwndOwner == NULLHANDLE )
        return;

    WinQueryWindowPos( hwnd,      &swpDlg );
    WinQueryWindowPos( hwndOwner, &swpOwner );

    x = swpOwner.x + (swpOwner.cx - swpDlg.cx) / 2;
    y = swpOwner.y + (swpOwner.cy - swpDlg.cy) / 2;
    if( x < 0 ) x = 0;
    if( y < 0 ) y = 0;

    WinSetWindowPos( hwnd, HWND_TOP, x, y, 0, 0, SWP_MOVE );
}


/*** About ********************************************************************/

static MRESULT EXPENTRY AboutDlgProc(HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2)
{
    switch( msg )
    {
        case WM_INITDLG:
            CenterDialog( hwnd );
            return 0;

        case WM_COMMAND:
            switch( COMMANDMSG(&msg)->cmd )
            {
                case DID_OK:
                case DID_CANCEL:
                    WinDismissDlg( hwnd, TRUE );
                    return 0;
            }
            break;
    }

    return WinDefDlgProc( hwnd, msg, mp1, mp2 );
}


void AboutDialog(HWND owner)
{
    WinDlgBox( HWND_DESKTOP, owner, AboutDlgProc, NULLHANDLE, DLG_ABOUT, NULL );
}


/*** Settings *****************************************************************/

static void EnableNumber(HWND hwnd)
{
    BOOL random = WinQueryButtonCheckstate( hwnd, IDD_RANDOM ) ? TRUE : FALSE;

    WinEnableWindow( WinWindowFromID( hwnd, IDD_NUM ), !random );
}


static MRESULT EXPENTRY SettingsDlgProc(HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2)
{
    char  buf[32];
    char *end;
    long  v;

    switch( msg )
    {
        case WM_INITDLG:
            CenterDialog( hwnd );
            WinSetWindowText( hwnd, tr(STR_SET_TITLE) );
            WinSetDlgItemText( hwnd, IDD_SAFE,    tr(STR_SET_SAFE) );
            WinSetDlgItemText( hwnd, IDD_SOUND,   tr(STR_SET_SOUND) );
            WinSetDlgItemText( hwnd, IDD_VERBOSE, tr(STR_SET_VERBOSE) );
            WinSetDlgItemText( hwnd, IDD_CONFIRM, tr(STR_SET_CONFIRM) );
            WinSetDlgItemText( hwnd, IDD_RANDOM,  tr(STR_SET_RANDOM) );
            WinSetDlgItemText( hwnd, IDD_NUMTXT,  tr(STR_SET_NUM) );
            WinSetDlgItemText( hwnd, IDD_RANGE,   tr(STR_SET_RANGE) );
            WinSetDlgItemText( hwnd, DID_OK,      tr(STR_OK) );
            WinSetDlgItemText( hwnd, DID_CANCEL,  tr(STR_CANCEL) );

            WinCheckButton( hwnd, IDD_SAFE,    Prefs.safegame ? TRUE : FALSE );
            WinCheckButton( hwnd, IDD_SOUND,   Prefs.sound ? TRUE : FALSE );
            WinCheckButton( hwnd, IDD_VERBOSE, Prefs.verbose ? TRUE : FALSE );
            WinCheckButton( hwnd, IDD_CONFIRM, Prefs.confirms ? TRUE : FALSE );
            WinCheckButton( hwnd, IDD_RANDOM,  Prefs.randombomb ? TRUE : FALSE );
            sprintf( buf, "%d", Prefs.bombcount );
            WinSetDlgItemText( hwnd, IDD_NUM, buf );
            EnableNumber( hwnd );
            return 0;

        case WM_CONTROL:
            if( SHORT1FROMMP(mp1) == IDD_RANDOM )
                EnableNumber( hwnd );
            return 0;

        case WM_COMMAND:
            switch( COMMANDMSG(&msg)->cmd )
            {
                case DID_OK:
                    v = Prefs.bombcount;
                    if( !WinQueryButtonCheckstate( hwnd, IDD_RANDOM ) )
                    {
                        WinQueryDlgItemText( hwnd, IDD_NUM, sizeof(buf), buf );
                        v = strtol( buf, &end, 10 );
                        while( *end == ' ' )
                            end++;
                        if( buf[0] == 0 || *end != 0 || v < MIN_MINES || v > MAX_MINES )
                        {
                            WinMessageBox( HWND_DESKTOP, hwnd, tr(STR_ERR_BOMBS), PRG_NAME, 0,
                                           MB_OK | MB_ERROR | MB_MOVEABLE );
                            WinSetFocus( HWND_DESKTOP, WinWindowFromID( hwnd, IDD_NUM ) );
                            return 0;
                        }
                    }

                    Prefs.safegame   = WinQueryButtonCheckstate( hwnd, IDD_SAFE ) ? 1 : 0;
                    Prefs.sound      = WinQueryButtonCheckstate( hwnd, IDD_SOUND ) ? 1 : 0;
                    Prefs.verbose    = WinQueryButtonCheckstate( hwnd, IDD_VERBOSE ) ? 1 : 0;
                    Prefs.confirms   = WinQueryButtonCheckstate( hwnd, IDD_CONFIRM ) ? 1 : 0;
                    Prefs.randombomb = WinQueryButtonCheckstate( hwnd, IDD_RANDOM ) ? 1 : 0;
                    Prefs.bombcount  = (int)v;
                    WinDismissDlg( hwnd, TRUE );
                    return 0;

                case DID_CANCEL:
                    WinDismissDlg( hwnd, FALSE );
                    return 0;
            }
            break;
    }

    return WinDefDlgProc( hwnd, msg, mp1, mp2 );
}


/* TRUE when the settings were changed with OK */
int SettingsDialog(HWND owner)
{
    return WinDlgBox( HWND_DESKTOP, owner, SettingsDlgProc, NULLHANDLE,
                      DLG_SETTINGS, NULL ) == TRUE ? 1 : 0;
}
