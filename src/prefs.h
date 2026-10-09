/*******************************************************************************
* PREFS.H - settings kept in Kaboooom.cfg (plan.txt section 10)
*
* Binary file, sequential int fields. Older, shorter files are fine: the
* missing fields keep their defaults. Never reorder the fields, only append.
*******************************************************************************/

#ifndef PREFS_H
#define PREFS_H

#define CFG_FILE        "Kaboooom.cfg"

struct PrefsStruct
{
    int saveonexit;             /* 0 or 1                                    */
    int detaillevel;            /* kept for the common file layout           */
    int current_lang;           /* LANG_EN .. LANG_IT                        */

    /* game specific */
    int safegame;
    int sound;
    int verbose;
    int randombomb;
    int bombcount;              /* 10 .. 40, used when randombomb is 0       */
    int confirms;
};

extern struct PrefsStruct Prefs;

void InitPrefs(void);
void LoadPrefs(void);
int  SavePrefs(void);

#endif /* PREFS_H */
