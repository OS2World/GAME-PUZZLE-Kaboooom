UNIT KBAbout;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/08/13 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(*                                                                      *)
(* Unit defines about dialog used by Kaboooom!.                         *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: yyyy/mm/dd -                                                *)
(*                                                                      *)

INTERFACE

 USES Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls;

 TYPE TABOUTBOX = CLASS(TFORM)
                   Panel1      : TPanel;
                   ProgramIcon : TImage;
                   OkButton    : TBitBtn;
                   ProductName : TLabel;
                   Version     : TLabel;
                   Copyright   : TLabel;
                   Comment     : TLabel;
                   Procedure AboutBoxOnShow(Sender : TObject);
                  PRIVATE
                   {Insert private declarations here}
                  PUBLIC
                   {Insert public declarations here}
                  END;

 VAR AboutBox : TABOUTBOX;

(************************************************************************)

IMPLEMENTATION

 USES KBCommon;

(************************************************************************)

 Procedure TAboutBox.AboutBoxOnShow(Sender : TObject);
  Begin
   ProductName.Caption := s_ASys + Application.MainForm.Caption;
   Version.Caption := s_AVer;
   Copyright.Caption := s_ACpy;
   Comment.Caption := s_ACmn1 + s_ACmn2 + s_ACmn3 + s_ACmn4;
  End;

(************************************************************************)

INITIALIZATION
 RegisterClasses ([TAboutBox, TPanel, TImage, TBitBtn, TLabel]);
END. (*of unit*)
