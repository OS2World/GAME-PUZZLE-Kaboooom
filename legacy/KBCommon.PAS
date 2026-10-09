UNIT KBCommon;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/07/26 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(*                                                                      *)
(* Unit defines settings dialog used by Kaboooom!.                      *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: 1997/09/01 - Removed restart message.                       *)
(*          1997/12/07 - Changed version, removed end game msg.         *)
(*          1997/12/15 - Changed version number.                        *)
(*          1998/02/28 -  " " "   " " "   " " "                         *)
(*                                                                      *)

INTERFACE

 CONST Grid_X     = 15;
       Grid_Y     = 9;
       {ini file stuff}
       Ini_Pos    : STRING[14] = 'WindowPosition';
       Ini_Parms  : STRING[10] = 'GameParams';
       Ini_Sounds : STRING[10] = 'GameSounds';
       I_1        : STRING[3] = 'Top';
       I_2        : STRING[4] = 'Left';
       I_PKey1    : STRING[5] = 'SafeG';
       I_PKey2    : STRING[6] = 'SoundO';
       I_PKey3    : STRING[5] = 'VerbM';
       I_PKey4    : STRING[5] = 'RandB';
       I_PKey5    : STRING[7] = 'BombCnt';
       I_PKey6    : STRING[9] = 'DebugMode';
       I_PKey7    : STRING[8] = 'Confirms';
       I_SKey1    : STRING[4] = 'Beep';
       I_SKey2    : STRING[6] = 'Finish';
       I_SKey3    : STRING[7] = 'Explode';
       I_SKey4    : STRING[8] = 'Negative';
       {initialized globals}
       SafeGame   : BOOLEAN = TRUE;
       SoundOn    : BOOLEAN = FALSE;
       VerboseMov : BOOLEAN = FALSE;
       RandomBomb : BOOLEAN = TRUE;
       DebugOn    : BOOLEAN = FALSE;
       ConfirmsOn : BOOLEAN = FALSE;
       {sound constants}
       sid_Beep     = 1;
       sid_Finish   = 2;
       sid_Explode  = 3;
       sid_Negative = 4;
       {sound files}
       sf_Beep    : STRING = '';
       sf_Finish  : STRING = '';
       sf_Explode : STRING = '';
       sf_No      : STRING = '';
       {bitmap id constants}
       bmid_0        = 1000; {to 1009, number bitmaps}
       { ... }
       bmid_9        = 1009; {end of number bitmaps}
       bmid_Start    = 2000; {start of other bitmaps}
       bmid_End      = 2004; {end of other bitmaps}
       bmid_Mark     = 2000; { - user marked location bitmap}
       bmid_Bomb     = 2001; { - bomb/mine bitmap}
       bmid_Current  = 2002; { - you/current bitmap}
       bmid_Finish   = 2003; { - home/goal bitmap}
       bmid_Exploded = 2004; { - exploded mine bitmap}
       {cell type constants}
       b_Empty    = 0;
       b_Visited  = 1;
       b_Bomb     = 2;
       b_Current  = 3;
       b_Finish   = 4;
       b_Exploded = 5;
       {message constants}
       s_On          : STRING[2]  = 'ON';
       s_Off         : STRING[3]  = 'OFF';
       s_BombsAround : STRING[30] = 'There are %D bombs around you.';
       s_BombsInGame : STRING[31] = 'There are %D bombs in the game.';
       s_SafeGameMsg : STRING[16] = 'Safe game is %S.';
       s_SoundMsg    : STRING[12] = 'Sound is %S.';
       s_VerboseMsg  : STRING[28] = 'Verbose computer move is %S.';
       s_MMsg1       : STRING[21] = '*** Invalid move. ***';
       s_MMsg2       : STRING[21] = ' (you must unmark it)';
       s_MMsg3       : STRING[38] = 'KABOOOOM!!!, you''ve stepped on a mine.';
       s_MMsg4       : STRING[22] = '*** You have won!! ***';
       s_MMsg5       : STRING[12] = ' (With help)';
       s_EMsg1       : STRING[42] =
                        'Number of bombs must be between 10 and 40.';
       s_EMsg3       : STRING[29] = 'Cannot mark current position.';
       s_EMsg4       : STRING[41] =
                        'Can only mark cells around your position.';
       s_VMsg1       : STRING[43] =
                        'Evaluating position, press cancel to abort.';
       s_VMsg2       : STRING[52] =
                        'Cannot deduce anything further, you''re on your own.';
       s_VMsg3       : STRING[36] = 'LOGIC ERROR: phantom bomb tagged at ';
       s_VMsg4       : STRING[25] = 'ERROR: PLH > Maximum PLH!';
       s_VMsg5       : STRING[26] = 'OUCH! walked on a bomb at ';
       s_CMsg1       : STRING[15] = 'Start new game?';
       s_CMsg2       : STRING[47] =
                        'Are you sure you want the computer to evaluate?';
       {$IFDEF OS2}
       s_ASys        : STRING[5]  = 'OS/2 ';
       {$ELSE}
       s_ASys        : STRING[6]  = 'Win32 ';
       {$ENDIF}
       s_AVer        : STRING[25] = 'Version 1.05 - 1998/02/28';
       s_ACpy        : STRING[38] = '1997-1998 Slack & Associates/M.G.Slack';
       s_ACmn1       : STRING[31] = 'Created with Speedsoft Sibyl.  ';
       s_ACmn2       : STRING[36] = 'Based on the game Kaboooom! written ';
       s_ACmn3       : STRING[34] = 'A. Lane in DDJ #163, April 1990.  ';
       s_ACmn4       : STRING[39] = 'Ported to Pascal by M.G.S., 1990/03/18.';

 TYPE ADJACENCYGROUP = RECORD
                        BombCount,
                        CellCount : INTEGER;
                        Cell      : ARRAY[0..8,0..1] OF INTEGER;
                       END;
      TPLIST         = ARRAY[0..Grid_X*Grid_Y,0..1] OF INTEGER;

 VAR GameBoard,
     UserMarked    : ARRAY[0..Grid_X,0..Grid_Y] OF INTEGER;
     NumberOfMines : INTEGER;
     UserX, UserY  : LONGINT;
     AdjacentGroup : ARRAY[0..Grid_X,0..Grid_Y] OF ADJACENCYGROUP;

(************************************************************************)

IMPLEMENTATION

(************************************************************************)

INITIALIZATION

END. (*of unit*)
