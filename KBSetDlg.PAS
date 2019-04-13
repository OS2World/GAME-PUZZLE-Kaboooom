UNIT KBSetDlg;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/08/03 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(*                                                                      *)
(* Unit defines settings dialog used by Kaboooom!.                      *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: 1997/09/01 - Removed restart prompt when OK is pressed.     *)
(*          1998/02/28 - Modified OK behavior to overcode a fixpack2    *)
(*                       error (added dismissdlg call).                 *)
(*                                                                      *)

INTERFACE

 USES Classes, Forms, Graphics, TabCtrls, Buttons, KBCommon, StdCtrls, Dialogs;

 TYPE TSETTINGSDLG = CLASS(TFORM)
                      TNB_Sets     : TTabbedNotebook;
                      CB_SafeG     : TCheckBox;
                      CB_SoundsOn  : TCheckBox;
                      CB_VMove     : TCheckBox;
                      CB_NumB      : TCheckBox;
                      Label1       : TLabel;
                      ENumB        : TEdit;
                      CB_Confirm   : TCheckBox;
                      Label2       : TLabel;
                      Label3       : TLabel;
                      EBSnd        : TEdit;
                      FBtn1        : TButton;
                      Label4       : TLabel;
                      EFSnd        : TEdit;
                      FBtn2        : TButton;
                      Label5       : TLabel;
                      EESnd        : TEdit;
                      FBtn3        : TButton;
                      Label6       : TLabel;
                      ENSnd        : TEdit;
                      FBtn4        : TButton;
                      OkButton     : TBitBtn;
                      CancelButton : TBitBtn;
                      OpenDlg      : TOpenDialog;
                      Procedure SettingsDlgOnShow(Sender : TObject);
                      Procedure CB_NumBOnClick(Sender : TObject);
                      Procedure FBtnXOnClick(Sender : TObject);
                      Procedure OkButtonOnClick(Sender : TObject);
                     PRIVATE
                      {Insert private declarations here}
                     PUBLIC
                      {Insert public declarations here}
                     END;

 VAR SettingsDlg : TSETTINGSDLG;

(************************************************************************)

IMPLEMENTATION

 USES SysUtils, Dialogs;

(************************************************************************)

 Procedure TSettingsDlg.SettingsDlgOnShow(Sender : TObject);
  Begin
   CB_SafeG.Checked := SafeGame;
   CB_SoundsOn.Checked := SoundOn;
   CB_VMove.Checked := VerboseMov;
   CB_NumB.Checked := RandomBomb;
   ENumB.Text := IntToStr(NumberOfMines);
   IF RandomBomb THEN ENumB.Enabled := FALSE;
   Label1.FocusControl := ENumB;
   CB_Confirm.Checked := ConfirmsOn;
   Label3.FocusControl := EBSnd;
   EBSnd.Text := sf_Beep;
   Label4.FocusControl := EFSnd;
   EFSnd.Text := sf_Finish;
   Label5.FocusControl := EESnd;
   EESnd.Text := sf_Explode;
   Label6.FocusControl := ENSnd;
   ENSnd.Text := sf_No;
  End;

(************************************************************************)

 Procedure TSettingsDlg.CB_NumBOnClick(Sender : TObject);
  Begin
   ENumB.Enabled := NOT CB_NumB.Checked;
  End;

(************************************************************************)

 Procedure TSettingsDlg.FBtnXOnClick(Sender : TObject);
    VAR TT : STRING[144];
  Begin
   IF Sender = FBtn1
    THEN TT := EBSnd.Text
   ELSE IF Sender = FBtn2
         THEN TT := EFSnd.Text
        ELSE IF Sender = FBtn3
              THEN TT := EESnd.Text
             ELSE IF Sender = FBtn4
                   THEN TT := ENSnd.Text;
   IF (TT <> '') AND (FileExists(TT))
    THEN OpenDlg.FileName := TT;
   IF OpenDlg.Execute
    THEN BEGIN {save new file name}
          TT := Trim(OpenDlg.FileName);
          IF (TT <> '') AND NOT(FileExists(TT)) THEN TT := '';
          IF Sender = FBtn1
           THEN EBSnd.Text := TT
          ELSE IF Sender = FBtn2
                THEN EFSnd.Text := TT
               ELSE IF Sender = FBtn3
                     THEN EESnd.Text := TT
                    ELSE IF Sender = FBtn4
                          THEN ENSnd.Text := TT;
         END; {then}
  End;

(************************************************************************)

 Procedure TSettingsDlg.OkButtonOnClick(Sender : TObject);
    VAR I : INTEGER;
        T : STRING[144];
  Begin
   IF NOT(CB_NumB.Checked)
    THEN BEGIN {check of number of bombs}
          T := Trim(ENumB.Text);
          IF T <> '' THEN I := StrToInt(T) ELSE I := 0;
          IF (I < 10) OR (I > 40)
           THEN BEGIN {bad number of bombs}
                 MessageBox(s_EMsg1,mtError,[mbOK]);
                 TNB_Sets.PageIndex := 0;
                 ENumB.Focus;
                 Exit;
                END; {then}
         END; {then}
   SafeGame := CB_SafeG.Checked;
   SoundOn := CB_SoundsOn.Checked;
   VerboseMov := CB_VMove.Checked;
   RandomBomb := CB_NumB.Checked;
   IF NOT(RandomBomb) THEN NumberOfMines := I;
   ConfirmsOn := CB_Confirm.Checked;
   {get sound file names}
   T := Trim(EBSnd.Text);
   IF (T <> '') AND NOT(FileExists(T)) THEN T := '';
   sf_Beep := T;
   T := Trim(EFSnd.Text);
   IF (T <> '') AND NOT(FileExists(T)) THEN T := '';
   sf_Finish := T;
   T := Trim(EESnd.Text);
   IF (T <> '') AND NOT(FileExists(T)) THEN T := '';
   sf_Explode := T;
   T := Trim(ENSnd.Text);
   IF (T <> '') AND NOT(FileExists(T)) THEN T := '';
   sf_No := T;
   DismissDlg(mrOK); {OK setup with no modalresult}
  End;

(************************************************************************)

INITIALIZATION
 RegisterClasses ([TSettingsDlg, TTabbedNotebook, TBitBtn, TCheckBox, TLabel,
                   TEdit, TButton, TOpenDialog]);
END. (*of unit*)
