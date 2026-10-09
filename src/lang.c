/*******************************************************************************
* LANG.C - translated texts and runtime language switching (plan.txt section 8)
*
* ASCII only: no accented letters in the strings.
*******************************************************************************/

#include <string.h>

#include "lang.h"

int current_lang = LANG_EN;

const char *lang_strings[LANG_COUNT][STR_COUNT] =
{
    /* ---- English ------------------------------------------------------- */
    {
        "~Game",
        "~New Game\tCtrl+N",
        "~Computer Help\tCtrl+E",
        "E~xit\tCtrl+X",
        "~Options",
        "~Settings...",
        "~Language",
        "~Frame Controls\tCtrl+F",
        "~Save settings on exit",
        "~Help",
        "~Help for help...",
        "~Extended help...",
        "~Keys help...",
        "Help ~index...",
        "~About...",

        "Moves",
        "There are %d bombs around you.",
        "There are %d bombs in the game.",
        "Safe game is %s.",
        "Sound is %s.",
        "Verbose computer move is %s.",
        "ON",
        "OFF",
        "Walk to the house in the bottom right corner. A right click marks a mine.",

        "*** Invalid move. ***",
        " (you must unmark it)",
        "KABOOOOM!!!, you've stepped on a mine.",
        "*** You have won!! ***",
        " (With help)",
        "Cannot mark current position.",
        "Can only mark cells around your position.",
        "The computer cleared %d cells and marked %d mines.",
        "Cannot deduce anything further, you're on your own.",
        "Start new game?",
        "Are you sure you want the computer to evaluate?",
        "Game over. Start a new game?",

        "Settings",
        "Safe ~game",
        "~Sounds on",
        "~Verbose computer messages",
        "Con~firmations on",
        "~Random number of bombs",
        "Number of bombs:",
        "(10-40)",
        "Number of bombs must be between 10 and 40.",
        "OK",
        "Cancel",

        "Can't open the help file '%s'. Put it in the 'help' folder next to Kaboooom.exe."
    },

    /* ---- Spanish ------------------------------------------------------- */
    {
        "~Juego",
        "~Nuevo Juego\tCtrl+N",
        "~Ayuda del Ordenador\tCtrl+E",
        "~Salir\tCtrl+X",
        "~Opciones",
        "~Ajustes...",
        "~Idioma",
        "~Controles de marco\tCtrl+F",
        "Guardar ajustes al sa~lir",
        "A~yuda",
        "~Como usar la ayuda...",
        "Ayuda ~extendida...",
        "A~yuda de teclas...",
        "~Indice de ayuda...",
        "~Acerca de...",

        "Movimientos",
        "Hay %d bombas a su alrededor.",
        "Hay %d bombas en el juego.",
        "Juego seguro: %s.",
        "Sonido: %s.",
        "Mensajes del ordenador: %s.",
        "SI",
        "NO",
        "Camine hasta la casa de la esquina inferior derecha. El boton derecho marca una mina.",

        "*** Movimiento no valido. ***",
        " (debe quitar la marca)",
        "KABOOOOM!!!, ha pisado una mina.",
        "*** Ha ganado!! ***",
        " (Con ayuda)",
        "No se puede marcar la posicion actual.",
        "Solo se pueden marcar las celdas a su alrededor.",
        "El ordenador despejo %d celdas y marco %d minas.",
        "No se puede deducir nada mas, esta solo.",
        "Empezar un juego nuevo?",
        "Seguro que quiere que el ordenador evalue?",
        "Fin del juego. Empezar uno nuevo?",

        "Ajustes",
        "~Juego seguro",
        "~Sonidos",
        "Mensajes ~detallados",
        "~Confirmaciones",
        "Numero ~aleatorio de bombas",
        "Numero de bombas:",
        "(10-40)",
        "El numero de bombas debe estar entre 10 y 40.",
        "Aceptar",
        "Cancelar",

        "No se puede abrir el archivo de ayuda '%s'. Pongalo en la carpeta 'help' junto a Kaboooom.exe."
    },

    /* ---- Dutch --------------------------------------------------------- */
    {
        "~Spel",
        "~Nieuw Spel\tCtrl+N",
        "~Computerhulp\tCtrl+E",
        "~Afsluiten\tCtrl+X",
        "~Opties",
        "~Instellingen...",
        "~Taal",
        "~Vensterbesturing\tCtrl+F",
        "Instellingen ~bewaren bij afsluiten",
        "~Help",
        "~Help bij help...",
        "~Uitgebreide help...",
        "~Toetsenhelp...",
        "Help~index...",
        "~Info...",

        "Zetten",
        "Er zijn %d bommen om u heen.",
        "Er zijn %d bommen in het spel.",
        "Veilig spel is %s.",
        "Geluid is %s.",
        "Computermeldingen zijn %s.",
        "AAN",
        "UIT",
        "Loop naar het huis rechtsonder. Met de rechtermuisknop markeert u een mijn.",

        "*** Ongeldige zet. ***",
        " (u moet de markering eerst weghalen)",
        "KABOOOOM!!!, u bent op een mijn gestapt.",
        "*** U heeft gewonnen!! ***",
        " (Met hulp)",
        "De huidige plaats kan niet worden gemarkeerd.",
        "Alleen cellen om u heen kunnen worden gemarkeerd.",
        "De computer maakte %d cellen vrij en markeerde %d mijnen.",
        "De computer kan niets meer afleiden, u moet het zelf doen.",
        "Nieuw spel beginnen?",
        "Weet u zeker dat de computer moet rekenen?",
        "Einde van het spel. Nieuw spel beginnen?",

        "Instellingen",
        "~Veilig spel",
        "~Geluid aan",
        "Uitgebreide ~meldingen",
        "~Bevestigingen",
        "~Willekeurig aantal bommen",
        "Aantal bommen:",
        "(10-40)",
        "Het aantal bommen moet tussen 10 en 40 liggen.",
        "OK",
        "Annuleren",

        "Kan het helpbestand '%s' niet openen. Zet het in de map 'help' naast Kaboooom.exe."
    },

    /* ---- German -------------------------------------------------------- */
    {
        "~Spiel",
        "~Neues Spiel\tCtrl+N",
        "~Computerhilfe\tCtrl+E",
        "~Verlassen\tCtrl+X",
        "~Optionen",
        "~Einstellungen...",
        "~Sprache",
        "~Fensterelemente\tCtrl+F",
        "Einstellungen beim Beenden ~speichern",
        "~Hilfe",
        "~Hilfe zur Hilfe...",
        "~Erweiterte Hilfe...",
        "~Tastenhilfe...",
        "Hilfe~index...",
        "~Info...",

        "Zuege",
        "Um Sie herum sind %d Bomben.",
        "Im Spiel sind %d Bomben.",
        "Sicheres Spiel ist %s.",
        "Ton ist %s.",
        "Computermeldungen sind %s.",
        "AN",
        "AUS",
        "Gehen Sie zum Haus unten rechts. Rechtsklick markiert eine Mine.",

        "*** Ungueltiger Zug. ***",
        " (die Markierung muss erst entfernt werden)",
        "KABOOOOM!!!, Sie sind auf eine Mine getreten.",
        "*** Sie haben gewonnen!! ***",
        " (Mit Hilfe)",
        "Die aktuelle Position kann nicht markiert werden.",
        "Nur Felder um Ihre Position koennen markiert werden.",
        "Der Computer hat %d Felder freigelegt und %d Minen markiert.",
        "Der Computer kann nichts weiter ableiten, Sie sind allein.",
        "Neues Spiel beginnen?",
        "Soll der Computer wirklich rechnen?",
        "Spiel zu Ende. Neues Spiel beginnen?",

        "Einstellungen",
        "~Sicheres Spiel",
        "~Ton an",
        "~Ausfuehrliche Computermeldungen",
        "~Bestaetigungen",
        "~Zufaellige Anzahl Bomben",
        "Anzahl Bomben:",
        "(10-40)",
        "Die Anzahl der Bomben muss zwischen 10 und 40 liegen.",
        "OK",
        "Abbrechen",

        "Die Hilfedatei '%s' kann nicht geoeffnet werden. Legen Sie sie in den Ordner 'help' neben Kaboooom.exe."
    },

    /* ---- French -------------------------------------------------------- */
    {
        "~Jeu",
        "~Nouvelle Partie\tCtrl+N",
        "~Aide de l'ordinateur\tCtrl+E",
        "Q~uitter\tCtrl+X",
        "~Options",
        "~Parametres...",
        "~Langue",
        "~Controles du cadre\tCtrl+F",
        "~Enregistrer les parametres en quittant",
        "~Aide",
        "~Aide sur l'aide...",
        "Aide ~etendue...",
        "Aide des ~touches...",
        "~Index de l'aide...",
        "A ~propos...",

        "Deplacements",
        "Il y a %d bombes autour de vous.",
        "Il y a %d bombes dans le jeu.",
        "Jeu sur: %s.",
        "Son: %s.",
        "Messages de l'ordinateur: %s.",
        "OUI",
        "NON",
        "Allez a la maison en bas a droite. Le clic droit marque une mine.",

        "*** Deplacement invalide. ***",
        " (retirez d'abord la marque)",
        "KABOOOOM!!!, vous avez marche sur une mine.",
        "*** Vous avez gagne!! ***",
        " (Avec aide)",
        "Impossible de marquer la position actuelle.",
        "On ne peut marquer que les cases autour de vous.",
        "L'ordinateur a degage %d cases et marque %d mines.",
        "L'ordinateur ne peut rien deduire de plus, vous etes seul.",
        "Commencer une nouvelle partie ?",
        "Voulez-vous vraiment que l'ordinateur calcule ?",
        "Partie terminee. Commencer une nouvelle partie ?",

        "Parametres",
        "~Jeu sur",
        "~Son active",
        "Messages ~detailles",
        "~Confirmations",
        "Nombre ~aleatoire de bombes",
        "Nombre de bombes:",
        "(10-40)",
        "Le nombre de bombes doit etre entre 10 et 40.",
        "OK",
        "Annuler",

        "Impossible d'ouvrir le fichier d'aide '%s'. Placez-le dans le dossier 'help' a cote de Kaboooom.exe."
    },

    /* ---- Italian ------------------------------------------------------- */
    {
        "~Gioco",
        "~Nuova Partita\tCtrl+N",
        "~Aiuto del computer\tCtrl+E",
        "~Esci\tCtrl+X",
        "~Opzioni",
        "~Impostazioni...",
        "~Lingua",
        "~Controlli della cornice\tCtrl+F",
        "~Salva impostazioni all'uscita",
        "~Aiuto",
        "~Aiuto sull'aiuto...",
        "Aiuto ~esteso...",
        "Aiuto sui ~tasti...",
        "~Indice dell'aiuto...",
        "~Informazioni...",

        "Mosse",
        "Ci sono %d bombe intorno a te.",
        "Ci sono %d bombe nel gioco.",
        "Gioco sicuro: %s.",
        "Suono: %s.",
        "Messaggi del computer: %s.",
        "SI",
        "NO",
        "Raggiungi la casa in basso a destra. Il clic destro segna una mina.",

        "*** Mossa non valida. ***",
        " (devi prima togliere il segno)",
        "KABOOOOM!!!, hai calpestato una mina.",
        "*** Hai vinto!! ***",
        " (Con aiuto)",
        "Non si puo segnare la posizione attuale.",
        "Si possono segnare solo le caselle intorno a te.",
        "Il computer ha liberato %d caselle e segnato %d mine.",
        "Il computer non puo dedurre altro, sei solo.",
        "Iniziare una nuova partita?",
        "Vuoi davvero che il computer valuti?",
        "Partita finita. Iniziare una nuova partita?",

        "Impostazioni",
        "Gioco ~sicuro",
        "~Suoni attivi",
        "Messaggi ~dettagliati",
        "~Conferme",
        "Numero ~casuale di bombe",
        "Numero di bombe:",
        "(10-40)",
        "Il numero di bombe deve essere tra 10 e 40.",
        "OK",
        "Annulla",

        "Impossibile aprire il file di aiuto '%s'. Mettilo nella cartella 'help' accanto a Kaboooom.exe."
    }
};


/*** Runtime switching ********************************************************/

static HWND get_submenu(HWND hMnu, USHORT id)
{
    MENUITEM mi;

    memset(&mi, 0, sizeof(mi));
    if( (BOOL)WinSendMsg(hMnu, MM_QUERYITEM, MPFROM2SHORT(id, FALSE), MPFROMP(&mi)) )
        return mi.hwndSubMenu;
    return NULLHANDLE;
}


static void menu_set_text(HWND hMnu, USHORT id, const char *text)
{
    WinSendMsg(hMnu, MM_SETITEMTEXT, MPFROMSHORT(id), MPFROMP((PSZ)text));
}


/* Re-label the menu bar for the current language */
void set_language(HWND hMenu, int lang)
{
    HWND hGame, hOptions, hHelp;
    int  i;

    if( lang < 0 || lang >= LANG_COUNT )
        lang = LANG_EN;
    current_lang = lang;

    if( hMenu == NULLHANDLE )
        return;

    hGame    = get_submenu(hMenu, IDM_SUBMENU_GAME);
    hOptions = get_submenu(hMenu, IDM_SUBMENU_OPTIONS);
    hHelp    = get_submenu(hMenu, IDM_SUBMENU_HELP);

    menu_set_text(hMenu, IDM_SUBMENU_GAME,    tr(STR_GAME));
    menu_set_text(hMenu, IDM_SUBMENU_OPTIONS, tr(STR_OPTIONS));
    menu_set_text(hMenu, IDM_SUBMENU_HELP,    tr(STR_HELP));

    if( hGame )
    {
        menu_set_text(hGame, IDM_NEW,  tr(STR_NEW));
        menu_set_text(hGame, IDM_EVAL, tr(STR_EVAL));
        menu_set_text(hGame, IDM_EXIT, tr(STR_EXIT));
    }

    if( hOptions )
    {
        menu_set_text(hOptions, IDM_SETTINGS,     tr(STR_SETTINGS));
        menu_set_text(hOptions, IDM_SUBMENU_LANG, tr(STR_LANGUAGE));
        menu_set_text(hOptions, IDM_FRAME,        tr(STR_FRAME));
        menu_set_text(hOptions, IDM_SAVEONEXIT,   tr(STR_SAVEONEXIT));
    }

    if( hHelp )
    {
        menu_set_text(hHelp, IDM_HELPUSING, tr(STR_USINGHELP));
        menu_set_text(hHelp, IDM_HELPEXT,   tr(STR_EXTHELP));
        menu_set_text(hHelp, IDM_HELPKEYS,  tr(STR_KEYSHELP));
        menu_set_text(hHelp, IDM_HELPINDEX, tr(STR_HELPINDEX));
        menu_set_text(hHelp, IDM_ABOUT,     tr(STR_ABOUT));
    }

    for( i = 0; i < LANG_COUNT; i++ )
        WinCheckMenuItem(hMenu, (USHORT)(IDM_LANG_EN + i), (current_lang == i));
}
