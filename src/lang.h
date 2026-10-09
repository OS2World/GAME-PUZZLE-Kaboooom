/*******************************************************************************
* LANG.H - translated texts (plan.txt section 8). ASCII only.
*******************************************************************************/

#ifndef LANG_H
#define LANG_H

#include "kaboooom.h"

enum
{
    STR_GAME = 0,           /* menu bar and menus                            */
    STR_NEW,
    STR_EVAL,
    STR_EXIT,
    STR_OPTIONS,
    STR_SETTINGS,
    STR_LANGUAGE,
    STR_FRAME,
    STR_SAVEONEXIT,
    STR_HELP,
    STR_USINGHELP,
    STR_EXTHELP,
    STR_KEYSHELP,
    STR_HELPINDEX,
    STR_ABOUT,

    STR_MOVES,              /* texts in the window                           */
    STR_BOMBS_AROUND,
    STR_BOMBS_IN_GAME,
    STR_SAFE_MSG,
    STR_SOUND_MSG,
    STR_VERBOSE_MSG,
    STR_ON,
    STR_OFF,
    STR_HINT,

    STR_INVALID,            /* messages                                      */
    STR_MUST_UNMARK,
    STR_STEPPED,
    STR_WON,
    STR_WITH_HELP,
    STR_CANT_MARK_CUR,
    STR_CANT_MARK_FAR,
    STR_EVAL_DONE,
    STR_CANT_DEDUCE,
    STR_CONFIRM_NEW,
    STR_CONFIRM_EVAL,
    STR_GAME_OVER_Q,

    STR_SET_TITLE,          /* settings dialog                               */
    STR_SET_SAFE,
    STR_SET_SOUND,
    STR_SET_VERBOSE,
    STR_SET_CONFIRM,
    STR_SET_RANDOM,
    STR_SET_NUM,
    STR_SET_RANGE,
    STR_ERR_BOMBS,
    STR_OK,
    STR_CANCEL,

    STR_HELP_ERR,

    STR_COUNT
};

extern int         current_lang;
extern const char *lang_strings[LANG_COUNT][STR_COUNT];

#define tr(id)  ((char *)lang_strings[current_lang][(id)])

void set_language(HWND hMenu, int lang);

#endif /* LANG_H */
