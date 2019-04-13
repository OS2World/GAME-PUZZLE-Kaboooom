PROGRAM Kaboooom;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/07/26 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(* Originally based on Kaboooom! as written by Alex Lane in             *)
(*  Dr.Dobbs Journal, #163, April 1990.                                 *)
(* Rewritten in Turbo Pascal on 1990/03/18 by M.G.S.                    *)
(* Rewritten in Speedsoft Sibyl starting in 1997/07/26.                 *)
(*                                                                      *)
(* Program to run the game Kaboooom.                                    *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: 1997/09/01 - Various changes.  (1.01)                       *)
(*          1997/12/07 - Compiled with retail version, added end game   *)
(*                       dialog.  (1.03)                                *)
(*          1997/12/15 - Added conditional around bitmap resources for  *)
(*                       win32 compile.  (1.04)                         *)
(*                                                                      *)

 USES Forms, Graphics, KBCommon, KBWin, KBSetDlg, KBAbout, KBGamOvr;

{$r Kaboooom.scu}
{$IFDEF OS2}
 {$R KB_BMPs.SRF}
{$ELSE}
 {$R KB_BMPs.SRW}
{$ENDIF}

BEGIN (*main*)
 Application.Create;
 Application.CreateForm(TBoomWin, BoomWin);
 Application.Run;
 Application.Destroy;
END. (*main*)
