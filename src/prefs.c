/*******************************************************************************
* PREFS.C - load and save the settings
*******************************************************************************/

#include <stdio.h>
#include <string.h>

#include "kaboooom.h"
#include "game.h"
#include "prefs.h"

struct PrefsStruct Prefs;


void InitPrefs(void)
{
    memset( &Prefs, 0, sizeof(Prefs) );

    Prefs.saveonexit   = 1;
    Prefs.detaillevel  = 1;
    Prefs.current_lang = LANG_EN;
    Prefs.safegame     = 1;
    Prefs.sound        = 1;
    Prefs.verbose      = 0;
    Prefs.randombomb   = 1;
    Prefs.bombcount    = 25;
    Prefs.confirms     = 0;
}


/* Reset everything that is outside its range */
static void Validate(void)
{
    if( Prefs.saveonexit != 0 && Prefs.saveonexit != 1 )
        Prefs.saveonexit = 1;
    if( Prefs.detaillevel < 0 || Prefs.detaillevel > 2 )
        Prefs.detaillevel = 1;
    if( Prefs.current_lang < 0 || Prefs.current_lang >= LANG_COUNT )
        Prefs.current_lang = LANG_EN;
    Prefs.safegame   = (Prefs.safegame != 0);
    Prefs.sound      = (Prefs.sound != 0);
    Prefs.verbose    = (Prefs.verbose != 0);
    Prefs.randombomb = (Prefs.randombomb != 0);
    Prefs.confirms   = (Prefs.confirms != 0);
    if( Prefs.bombcount < MIN_MINES || Prefs.bombcount > MAX_MINES )
        Prefs.bombcount = 25;
}


void LoadPrefs(void)
{
    FILE *f;

    InitPrefs();

    f = fopen( CFG_FILE, "rb" );
    if( f )
    {
        fread( &Prefs, 1, sizeof(Prefs), f );   /* a shorter file is fine    */
        fclose( f );
    }

    Validate();
}


int SavePrefs(void)
{
    FILE *f = fopen( CFG_FILE, "wb" );

    if( !f )
        return 0;

    fwrite( &Prefs, 1, sizeof(Prefs), f );
    fclose( f );
    return 1;
}
