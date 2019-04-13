UNIT KBGamOvr;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/12/07 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(*                                                                      *)
(* Unit defines the end game dialog used by Kaboooom!.                  *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: yyyy/mm/dd -                                                *)
(*                                                                      *)

INTERFACE

 USES Classes, Forms, Graphics, Buttons, ExtCtrls, StdCtrls;

 TYPE TENDDLG = CLASS(TFORM)
                 Image1 : TImage;
                 Label1 : TLabel;
                 YesBtn : TBitBtn;
                 NoBtn  : TBitBtn;
                PRIVATE
                 {Insert private declarations here}
                PUBLIC
                 {Insert public declarations here}
                END;

 VAR EndDlg : TENDDLG;

(************************************************************************)

IMPLEMENTATION

(************************************************************************)

INITIALIZATION
 RegisterClasses ([TEndDlg, TBitBtn, TImage, TLabel]);
END. (*of unit*)
