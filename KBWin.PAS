UNIT KBWin;

(*                                                                      *)
(* AUTHOR: Michael G. Slack                    DATE WRITTEN: 1997/07/27 *)
(* ENVIRONMENT: Speedsoft Sibyl                                         *)
(*                                                                      *)
(* Main window of the game Kaboooom!.                                   *)
(* NOTE: Computer help (evaluation) walks the board similar to how a    *)
(*       user would walk the board.                                     *)
(*                                                                      *)
(* -------------------------------------------------------------------- *)
(*                                                                      *)
(* REVISED: 1997/09/01 - Removed start new game when new settings are   *)
(*                       entered.  In addition, changed the method used *)
(*                       to repaint game grid (used 'repaint' method    *)
(*                       instead of looping and redrawing each cell one *)
(*                       at a time).                                    *)
(*          1997/10/05 - Added in code so that start and home are not   *)
(*                       surrounded by bombs.                           *)
(*                                                                      *)

INTERFACE

 USES Classes, Forms, Graphics, Grids, StdCtrls, Buttons, MMedia, Messages,
      KBCommon;

 CONST wm_EvalMe = wm_User + 101;

 TYPE TBOOMWIN = CLASS(TFORM)
                  DG_Board     : TDrawGrid;
                  PM_Board     : TPopupMenu;
                  Mark_UnM     : TMenuItem;
                  GB_Moves     : TGroupBox;
                  SB_UpLeft    : TSpeedButton;
                  SB_Up        : TSpeedButton;
                  SB_UpRight   : TSpeedButton;
                  SB_Left      : TSpeedButton;
                  SB_Cheat     : TSpeedButton;
                  SB_Right     : TSpeedButton;
                  SB_DownLeft  : TSpeedButton;
                  SB_Down      : TSpeedButton;
                  SB_DownRight : TSpeedButton;
                  MsgLine      : TLabel;
                  NewBtn       : TBitBtn;
                  SettingsBtn  : TBitBtn;
                  ExitBtn      : TBitBtn;
                  MovCanBtn    : TBitBtn;
                  GB_Params    : TGroupBox;
                  BombCntMsg   : TLabel;
                  SafeGameMsg  : TLabel;
                  SndMsg       : TLabel;
                  VerbCMovMsg  : TLabel;
                  AD_Sound     : TAudioDevice;
                  PU_Win       : TPopupMenu;
                  MI_About     : TMenuItem;
                  Procedure BoomWinOnCreate(Sender : TObject);
                  Procedure BoomWinOnShow(Sender : TObject);
                  Procedure BoomWinOnDestroy(Sender : TObject);
                  Procedure MovBtnOnClick(Sender : TObject);
                  Procedure NewBtnOnClick(Sender : TObject);
                  Procedure SettingsBtnOnClick(Sender : TObject);
                  Procedure MovCanBtnOnClick(Sender : TObject);
                  Procedure Mark_UnMOnClick(Sender : TObject);
                  Procedure MI_AboutOnClick(Sender : TObject);
                  Procedure DG_BoardOnMouseDown(Sender : TObject;
                                                Button : TMouseButton;
                                                Shift  : TShiftState;
                                                X, Y   : LONGINT);
                  Procedure DG_BoardOnDrawCell(Sender : TObject;
                                               ACol : LongInt; ARow : LongInt;
                                               rc : TRect;
                                               State : TGridDrawState);
                 PRIVATE
                  M_C, M_R,         {mark position}
                  DlgX, DlgY,       {message dialog position}
                  OldTop, OldLeft : LONGINT;     {saved window pos}
                  Images          : TBITMAPLIST; {images used in drawing}
                  I_Helped,         {computer evaluation used}
                  ShowBombs,        {end game flag - show bombs}
                  StopComputer,     {flag used to stop evaluaution during eval}
                  NewGameFlg      : BOOLEAN;     {start new game flag}
                 PUBLIC
                  PROCEDURE Read_INI;
                  PROCEDURE Write_INI;
                  PROCEDURE DisplayParams(CONST ShwMCnt : BOOLEAN);
                  FUNCTION  CountMines(X, Y : INTEGER) : INTEGER;
                  PROCEDURE DisplayCell(C, R : INTEGER);
                  PROCEDURE PaintBoard;
                  PROCEDURE SetupBoard;
                  PROCEDURE StartNewGame;
                  PROCEDURE Travel(DX, DY : INTEGER);
                  PROCEDURE EnDisAble(Enab : BOOLEAN);
                  PROCEDURE ComputeAdjacency(X, Y : INTEGER);
                  PROCEDURE MarkBombCell(X, Y : INTEGER);
                  FUNCTION  AddToPositionList(VAR PL : TPLIST;
                                              PLH, X, Y : INTEGER) : INTEGER;
                  FUNCTION  AddSurroundingToPositionList(VAR PL : TPLIST;
                                              PLH, X, Y : INTEGER) : INTEGER;
                  PROCEDURE VisitCell(X, Y : INTEGER);
                  FUNCTION  FindPositionInAG(PAG : ADJACENCYGROUP;
                                             X, Y : INTEGER) : BOOLEAN;
                  FUNCTION  CountCommonCells(PGrp1,
                                             PGrp2 : ADJACENCYGROUP) : INTEGER;
                  FUNCTION  ProcessRule3(VAR CurrAG, TempAG : ADJACENCYGROUP;
                                         VAR PL : TPLIST;
                                         VAR PLH : INTEGER) : BOOLEAN;
                  PROCEDURE Do_Eval;
                  PROCEDURE EvaluatePosition;
                  PROCEDURE DoTheSound(Which : INTEGER);
                  PROCEDURE WMEvalMe(VAR Msg : TMESSAGE);
                   MESSAGE wm_EvalMe;
                 END;

 VAR BoomWin : TBOOMWIN;

(************************************************************************)

IMPLEMENTATION

 USES SysUtils, IniFiles, Dialogs, KBSetDlg, KBAbout, KBGamOvr;

(************************************************************************)

 Procedure TBoomWin.BoomWinOnCreate(Sender : TObject);
    VAR I : INTEGER;
  Begin
   Randomize;
   Images := TBITMAPLIST.Create;
   {load bitmaps to list (by id from resource)}
   FOR I := bmid_0 TO bmid_9 DO
    Images.AddResourceID(I);   {[0] to [9] = number bitmaps}
   FOR I := bmid_Start TO bmid_End DO
    Images.AddResourceID(I);   {[10] to [14] = others}
  End;

(************************************************************************)

 Procedure TBoomWin.BoomWinOnShow(Sender : TObject);
  Begin
   Top := (Screen.Height DIV 2) - (Height DIV 2); {default position}
   Left := (Screen.Width DIV 2) - (Width DIV 2);
   {message dialog position}
   DlgX := DG_Board.Top + DG_Board.Height + 5;
   DlgY := DG_Board.Left + 15;
   DG_Board.OnMouseDown := DG_BoardOnMouseDown;
   NewGameFlg := FALSE; M_C := 1; M_R := 1;
   Read_INI;
   OldTop := Top; OldLeft := Left;
   DisplayParams(TRUE);
   SetupBoard;
  End;

(************************************************************************)

 Procedure TBoomWin.BoomWinOnDestroy(Sender : TObject);
    VAR Ini : TINIFILE;
        Pth : STRING;
  Begin
   Images.Free;
   IF (Top <> OldTop) OR (Left <> OldLeft)
    THEN BEGIN {only save if changed}
          Pth := GetDefaultINI;
          Ini := TINIFILE.Create(Pth);
          Ini.WriteInteger(Ini_Pos,I_1,Top);
          Ini.WriteInteger(Ini_Pos,I_2,Left);
          Ini.Free;
         END; {then}
  End;

(************************************************************************)

 PROCEDURE TBOOMWIN.MovBtnOnClick(Sender : TObject);
  BEGIN
   IF Sender = SB_UpLeft
    THEN Travel(-1,-1)
   ELSE
    IF Sender = SB_Up
     THEN Travel(0,-1)
    ELSE
     IF Sender = SB_UpRight
      THEN Travel(1,-1)
     ELSE
      IF Sender = SB_Left
       THEN Travel(-1,0)
      ELSE
       IF Sender = SB_Right
        THEN Travel(1,0)
       ELSE
        IF Sender = SB_DownLeft
         THEN Travel(-1,1)
        ELSE
         IF Sender = SB_Down
          THEN Travel(0,1)
         ELSE
          IF Sender = SB_DownRight
           THEN Travel(1,1)
          ELSE
           IF Sender = SB_Cheat
            THEN EvaluatePosition;
  END;

(************************************************************************)

 Procedure TBoomWin.NewBtnOnClick(Sender : TObject);
  Begin
   IF ConfirmsOn
    THEN IF MessageBox(s_CMsg1,mtConfirmation,mbYesNo) <> mrYes
          THEN Exit;
   StartNewGame;
  End;

(************************************************************************)

 Procedure TBoomWin.SettingsBtnOnClick(Sender : TObject);
    VAR Ret : TMSGDLGRETURN;
  Begin
   SettingsDlg := TSETTINGSDLG.Create(Self);
   SettingsDlg.Left := Left + 55; SettingsDlg.Top := Top + 10;
   Ret := SettingsDlg.ShowModal;
   SettingsDlg.Free;
   IF Ret = mrOK
    THEN BEGIN {settings entered}
          Write_INI;
          DisplayParams(FALSE);
         END; {then}
  End;

(************************************************************************)

 Procedure TBoomWin.MovCanBtnOnClick(Sender : TObject);
  Begin
   StopComputer := TRUE;
  End;

(************************************************************************)

 Procedure TBoomWin.Mark_UnMOnClick(Sender : TObject);
    VAR Flg : INTEGER;
        SS  : STRING[80];
  Begin
   Flg := 0;
   IF (M_C >= (UserX-1)) AND (M_C <= (UserX+1)) AND
      (M_R >= (UserY-1)) AND (M_R <= (UserY+1))
    THEN BEGIN {mark board if unmarked, else unmark}
          IF (M_C = UserX) AND (M_R = UserY)
           THEN Flg := 1
          ELSE BEGIN {do mark/unmark}
                IF UserMarked[M_C,M_R] > 0
                 THEN UserMarked[M_C,M_R] := 0
                ELSE UserMarked[M_C,M_R] := 1;
                DisplayCell(M_C,M_R);
               END; {else}
         END {then}
   ELSE Flg := 2;
   IF Flg > 0
    THEN BEGIN {can't mark position}
          IF SoundOn THEN DoTheSound(sid_Beep);
          CASE Flg OF
           1 : SS := s_EMsg3;
           2 : SS := s_EMsg4;
          END; {case}
          MessageBox(SS,mtError,[mbOK]); 
         END; {then}
  End;

(************************************************************************)

 Procedure TBoomWin.MI_AboutOnClick(Sender : TObject);
  Begin
   AboutBox := TABOUTBOX.Create(Self);
   AboutBox.Left := Left + 74; AboutBox.Top := Top + 55;
   AboutBox.ShowModal;
   AboutBox.Free;
  End;

(************************************************************************)

 Procedure TBoomWin.DG_BoardOnMouseDown(Sender : TObject;
                                        Button : TMouseButton;
                                        Shift  : TShiftState;
                                        X, Y   : LONGINT);
  Begin
   IF (Button IN [mbRight]) AND (Shift = [ssRight])
    THEN DG_Board.MouseToCell(X,Y,M_C,M_R);
  End;

(************************************************************************)

 Procedure TBoomWin.DG_BoardOnDrawCell(Sender : TObject;
                                       ACol : LongInt; ARow : LongInt;
                                       rc : TRect; State : TGridDrawState);
    VAR T : TRECT;
        I : INTEGER;
  Begin
   DG_Board.Canvas.FillRect(rc,DG_Board.EntryColor);
   IF UserMarked[ACol,ARow] > 0
    THEN BEGIN {display marked square}
          T := rc; T.Top := T.Top - 1;
          T.Left := T.Left + 1; T.Right := rc.Left + 8;
          Images.Bitmaps[10].Draw(DG_Board.Canvas,T);
          T.Left := rc.Right - 8; T.Right := rc.Right - 1;
          Images.Bitmaps[10].Draw(DG_Board.Canvas,T);
         END; {then}
   T := rc; T.Top := T.Top - 1;
   T.Left := T.Left + 10; T.Right := T.Right - 10;
   CASE GameBoard[ACol,ARow] OF
    b_Empty    : {already clear - do nothing else};
    b_Visited  : BEGIN {already been there, done that}
                  I := CountMines(ACol,ARow);
                  Images.Bitmaps[I].Draw(DG_Board.Canvas,T);
                 END; {b_Visited}
    b_Bomb     : BEGIN {mine is here}
                  IF ShowBombs
                   THEN Images.Bitmaps[11].Draw(DG_Board.Canvas,T);
                 END; {b_Bomb}
    b_Current  : BEGIN {you are here}
                  Images.Bitmaps[12].Draw(DG_Board.Canvas,T);
                 END; {b_Current}
    b_Finish   : BEGIN {home is here}
                  Images.Bitmaps[13].Draw(DG_Board.Canvas,T);
                 END; {b_Finish}
    b_Exploded : BEGIN {whooops!}
                  Images.Bitmaps[14].Draw(DG_Board.Canvas,T);
                 END; {b_Exploded}
   END; {case}
  End;

(************************************************************************)

 PROCEDURE TBOOMWIN.Read_INI;
     (* procedure to read ini, if exists *)

    VAR Ini : TINIFILE;
        Pth : STRING;

  BEGIN (*tboomwin.read_ini*)
   Pth := GetDefaultINI;
   NumberOfMines := Random(31)+10;
   IF NOT(FileExists(Pth)) THEN Exit; {no ini file}
   Ini := TINIFILE.Create(Pth);
   {read in window position (just top and left)}
   Top := Ini.ReadInteger(Ini_Pos,I_1,Top);
   Left := Ini.ReadInteger(Ini_Pos,I_2,Left);
   {read in game parameters}
   SafeGame := Ini.ReadBool(Ini_Parms,I_PKey1,SafeGame);
   SoundOn := Ini.ReadBool(Ini_Parms,I_PKey2,SoundOn);
   VerboseMov := Ini.ReadBool(Ini_Parms,I_PKey3,VerboseMov);
   RandomBomb := Ini.ReadBool(Ini_Parms,I_PKey4,RandomBomb);
   IF NOT(RandomBomb)
    THEN NumberOfMines := Ini.ReadInteger(Ini_Parms,I_PKey5,NumberOfMines);
   ConfirmsOn := Ini.ReadBool(Ini_Parms,I_PKey7,ConfirmsOn);
   {only settable in a ini editor}
   DebugOn := Ini.ReadBool(Ini_Parms,I_PKey6,DebugOn);
   {read in sound files picked}
   sf_Beep := Ini.ReadString(Ini_Sounds,I_SKey1,sf_Beep);
   sf_Finish := Ini.ReadString(Ini_Sounds,I_SKey2,sf_Finish);
   sf_Explode := Ini.ReadString(Ini_Sounds,I_SKey3,sf_Explode);
   sf_No := Ini.ReadString(Ini_Sounds,I_SKey4,sf_No);
   Ini.Free;
  END; (*tboomwin.read_ini*)

(************************************************************************)

 PROCEDURE TBOOMWIN.Write_INI;
     (* procedure to write out parameters to ini file *)

    VAR Ini : TINIFILE;
        Pth : STRING;

  BEGIN (*tboomwin.write_ini*)
   Pth := GetDefaultINI;
   Ini := TINIFILE.Create(Pth);
   {write out game parameters}
   Ini.WriteBool(Ini_Parms,I_PKey1,SafeGame);
   Ini.WriteBool(Ini_Parms,I_PKey2,SoundOn);
   Ini.WriteBool(Ini_Parms,I_PKey3,VerboseMov);
   Ini.WriteBool(Ini_Parms,I_PKey4,RandomBomb);
   Ini.WriteInteger(Ini_Parms,I_PKey5,NumberOfMines);
   {debug entry is read only (settable by ini editor only)}
   Ini.WriteBool(Ini_Parms,I_PKey7,ConfirmsOn);
   {write out sounds picked}
   Ini.WriteString(Ini_Sounds,I_SKey1,sf_Beep);
   Ini.WriteString(Ini_Sounds,I_SKey2,sf_Finish);
   Ini.WriteString(Ini_Sounds,I_SKey3,sf_Explode);
   Ini.WriteString(Ini_Sounds,I_SKey4,sf_No);
   Ini.Free;
  END; (*tboomwin.write_ini*)

(************************************************************************)

 PROCEDURE TBOOMWIN.DisplayParams(CONST ShwMCnt : BOOLEAN);
     (* procedure to display parameters currently in effect *)

    VAR TT : STRING[3];

  BEGIN (*tboomwin.displayparams*)
   IF ShwMCnt
    THEN BombCntMsg.Caption := Format(s_BombsInGame,[NumberOfMines]);
   IF SafeGame THEN TT := s_On ELSE TT := s_Off;
   SafeGameMsg.Caption := Format(s_SafeGameMsg,[TT]);
   IF SoundOn THEN TT := s_On ELSE TT := s_Off;
   SndMsg.Caption := Format(s_SoundMsg,[TT]);
   IF VerboseMov THEN TT := s_On ELSE TT := s_Off;
   VerbCMovMsg.Caption := Format(s_VerboseMsg,[TT]);
  END; (*tboomwin.displayparams*)

(************************************************************************)

 FUNCTION TBOOMWIN.CountMines(X, Y : INTEGER) : INTEGER;
     (* function to count mines around given location *)

    VAR I, J, TCount : INTEGER;

  BEGIN (*tboomwin.countmines*)
   TCount := 0;
   FOR I := -1 TO 1 DO
    FOR J := -1 TO 1 DO
     IF ((X+I) >= 0) AND ((X+I) < Grid_X) AND
        ((Y+J) >= 0) AND ((Y+J) < Grid_Y)
      THEN IF (GameBoard[X+I,Y+J] = b_Bomb) OR
              (GameBoard[X+I,Y+J] = b_Exploded)
            THEN Inc(TCount);
   CountMines := TCount;
  END; (*tboomwin.countmines*)

(************************************************************************)

 PROCEDURE TBOOMWIN.DisplayCell(C, R : INTEGER);
     (* procedure to redraw a particular cell *)

    VAR rc : TRECT;

  BEGIN (*tboomwin.displaycell*)
   rc := DG_Board.GridRects[C,R];
   DG_Board.Redraw(rc);
  END; (*tboomwin.displaycell*)

(************************************************************************)

 PROCEDURE TBOOMWIN.PaintBoard;
     (* procedure to paint all board cells *)

  BEGIN (*tboomwin.paintboard*)
   DG_Board.BeginUpdate;
   DG_Board.Repaint;
   DG_Board.EndUpdate;
  END; (*tboomwin.paintboard*)

(************************************************************************)

 PROCEDURE TBOOMWIN.SetupBoard;
     (* procedure to setup board for game play *)

    FUNCTION CheckTheThree(X, Y : INTEGER; St : BOOLEAN) : BOOLEAN;
        (* local func will check the three locations at start/home *)
        (*  - if k >= 2, already enough bombs there.               *)
       VAR K : INTEGER;
     BEGIN (*checkthethree*)
      K := 0;
      IF GameBoard[X-1,Y] = b_Bomb THEN Inc(K);
      IF GameBoard[X,Y-1] = b_Bomb THEN Inc(K);
      IF St
       THEN BEGIN {check final start position}
             IF GameBoard[X,Y] = b_Bomb THEN Inc(K);
            END {then}
      ELSE BEGIN {check final home position}
            IF GameBoard[X-1,Y-1] = b_Bomb THEN Inc(K);
           END; {else}
      CheckTheThree := K >= 2;
     END; (*checkthethree*)

    VAR I, J, NMines : INTEGER;
        BDone        : BOOLEAN;

  BEGIN (*tboomwin.setupboard*)
   FillChar(UserMarked,SizeOf(UserMarked),0);
   FillChar(GameBoard,SizeOf(GameBoard),0);
   UserX := 0; UserY := 0; ShowBombs := FALSE; I_Helped := FALSE;
   GameBoard[0,0] := b_Current; GameBoard[Grid_X-1,Grid_Y-1] := b_Finish;
   FOR NMines := 1 TO NumberOfMines DO
    BEGIN {place bombs in board}
     BDone := FALSE;
     WHILE NOT(BDone) DO
      BEGIN {place bombs}
       I := Random(Grid_X); J := Random(Grid_Y);
       IF (GameBoard[I,J] = b_Empty) THEN BDone := TRUE;
       IF BDone
        THEN BEGIN {check if placing around start/home}
              IF (I <= 1) AND (J <= 1)
               THEN BEGIN {around start, make sure not surrounded}
                     IF CheckTheThree(1,1,TRUE) THEN BDone := FALSE;
                    END {then}
              ELSE IF (I >= Grid_X-2) AND (J >= Grid_Y-2)
                    THEN BEGIN {around home, surrounded?}
                          IF CheckTheThree(Grid_X-1,Grid_Y-1,FALSE)
                           THEN BDone := FALSE;
                         END; {else/then}
             END; {then}
      END; {while}
     GameBoard[I,J] := b_Bomb;
    END; {for loop}
   IF DebugOn THEN ShowBombs := TRUE; {show all bombs}
   {paint board - only if not at startup}
   IF NewGameFlg THEN PaintBoard;
   Travel(0,0);
  END; (*tboomwin.setupboard*)

(************************************************************************)

 PROCEDURE TBOOMWIN.StartNewGame;
     (* procedure to respond to start new request *)

  BEGIN (*tboomwin.startnewgame*)
   IF RandomBomb THEN NumberOfMines := Random(31) + 10;
   DisplayParams(TRUE);
   NewGameFlg := TRUE;
   SetupBoard;
  END; (*tboomwin.startnewgame*)

(************************************************************************)

 PROCEDURE TBOOMWIN.Travel(DX, DY : INTEGER);
     (* procedure to move user one cell grid *)

    VAR I, NX, NY : INTEGER;
        GameOver,
        InvFlg    : BOOLEAN;
        TT        : STRING;
        Ret       : TMSGDLGRETURN;

  BEGIN (*tboomwin.travel*)
   NX := UserX + DX; NY := UserY + DY; InvFlg := FALSE; GameOver := FALSE;
   {check if outside grid}
   IF (NX < 0) OR (NX >= Grid_X) THEN InvFlg := TRUE;
   IF (NY < 0) OR (NY >= Grid_Y) THEN InvFlg := TRUE;
   {safe game on and grid square marked}
   IF NOT(InvFlg) AND (SafeGame) AND(UserMarked[NX,NY] > 0)
    THEN InvFlg := TRUE;
   IF InvFlg
    THEN BEGIN {bad move dude}
          IF SoundOn THEN DoTheSound(sid_Negative);
          TT := s_MMsg1;
          IF UserMarked[NX,NY] > 0 THEN TT := TT + s_MMsg2;
          MessageBox(TT,mtInformation,[mbOK]);
         END {then}
   ELSE BEGIN {move user}
         GameBoard[UserX,UserY] := b_Visited;
         DisplayCell(UserX,UserY);
         IF GameBoard[NX,NY] = b_Bomb
          THEN BEGIN {damn, hit a bomb}
                GameBoard[NX,NY] := b_Exploded; GameOver := TRUE;
                DisplayCell(NX,NY);
                IF SoundOn THEN DoTheSound(sid_Explode);
                {display message}
                MessageBox(s_MMsg3,mtInformation,[mbOK]);
               END {then}
         ELSE BEGIN {just move}
               UserX := NX; UserY := NY;
               GameBoard[UserX,UserY] := b_Current;
               DisplayCell(UserX,UserY);
               IF (UserX = Grid_X-1) AND (UserY = Grid_Y-1)
                THEN BEGIN {you've won - celebration time}
                      GameOver := TRUE;
                      TT := s_MMsg4;
                      IF I_Helped THEN TT := TT + s_MMsg5;
                      IF SoundOn THEN DoTheSound(sid_Finish);
                      MessageBox(TT,mtInformation,[mbOK]);
                     END; {then}
              END; {else}
        END; {else}
   I := CountMines(UserX,UserY);
   MsgLine.Caption := Format(s_BombsAround,[I]);
   IF GameOver
    THEN BEGIN {prompt for new game (or quit)}
          ShowBombs := TRUE;
          PaintBoard;
          EndDlg := TENDDLG.Create(Self);
          EndDlg.Left := Left + 130; EndDlg.Top := Top + 250;
          Ret := EndDlg.ShowModal;
          EndDlg.Free;
          IF Ret = mrYes THEN StartNewGame ELSE Close;
         END; {then}
  END; (*tboomwin.travel*)

(************************************************************************)

 PROCEDURE TBOOMWIN.EnDisAble(Enab : BOOLEAN);
     (* procedure to enable/disable controls in form (comp eval) *)

  BEGIN (*tboomwin.endisable*)
   SB_UpLeft.Enabled := Enab;
   SB_Up.Enabled := Enab;
   SB_UpRight.Enabled := Enab;
   SB_Left.Enabled := Enab;
   SB_Cheat.Enabled := Enab;
   SB_Right.Enabled := Enab;
   SB_DownLeft.Enabled := Enab;
   SB_Down.Enabled := Enab;
   SB_DownRight.Enabled := Enab;
   NewBtn.Enabled := Enab;
   SettingsBtn.Enabled := Enab;
   ExitBtn.Enabled := Enab;
   MovCanBtn.Visible := NOT(Enab);
   MovCanBtn.Enabled := NOT(Enab);
  END; (*tboomwin.endisable*)

(************************************************************************)

 PROCEDURE TBOOMWIN.ComputeAdjacency(X, Y : INTEGER);
     (* procedure to figure out adjacent squares *)

    VAR DX, DY, BCnt, Cel : INTEGER;

  BEGIN (*tboomwin.computeadjacency*)
   Application.ProcessMessages; IF StopComputer THEN Exit;
   IF (X >= 0) AND (X < Grid_X) AND (Y >= 0) AND (Y < Grid_Y)
    THEN BEGIN {do it}
          IF (GameBoard[X,Y] = b_Visited) OR (GameBoard[X,Y] = b_Current)
           THEN BEGIN {compute adjacent cells}
                 BCnt := CountMines(X,Y); Cel := 0;
                 FOR DX := -1 TO 1 DO
                  FOR DY := -1 TO 1 DO
                   BEGIN {loop around the cells around}
                    Application.ProcessMessages; IF StopComputer THEN Break;
                    IF NOT((DX = 0) AND (DY = 0))
                     THEN BEGIN {figure it out}
                           IF ((DX+X) >= 0) AND ((X+DX) < Grid_X) AND
                              ((DY+Y) >= 0) AND ((Y+DY) < Grid_Y)
                            THEN BEGIN {on game board}
                                  IF (GameBoard[DX+X,DY+Y] <> b_Visited) AND
                                     (GameBoard[DX+X,DY+Y] <> b_Current)
                                   THEN BEGIN {check it}
                                         IF UserMarked[X+DX,Y+DY] <> 0
                                          THEN Dec(BCnt)
                                         ELSE BEGIN {load cells around}
                                        AdjacentGroup[X,Y].Cell[Cel,0] := X+DX;
                                        AdjacentGroup[X,Y].Cell[Cel,1] := Y+DY;
                                               Inc(Cel);
                                              END; {else}
                                        END; {then}
                                 END; {then}
                          END; {then}
                   END; {for dx/dy}
                 AdjacentGroup[X,Y].BombCount := BCnt;
                 AdjacentGroup[X,Y].CellCount := Cel;
                END {then}
          ELSE BEGIN {no compution needed}
                AdjacentGroup[X,Y].CellCount := 0;
                AdjacentGroup[X,Y].BombCount := -1;
               END; {else}
         END; {then}
   Application.ProcessMessages;
  END; (*tboomwin.computeadjacency*)

(************************************************************************)

 PROCEDURE TBOOMWIN.MarkBombCell(X, Y : INTEGER);
     (* procedure to set marker in cell containing bomb *)

    VAR SS : STRING[80];

  BEGIN (*tboomwin.markbombcell*)
   UserMarked[X,Y] := 1;
   DisplayCell(X,Y);
   IF GameBoard[X,Y] <> b_Bomb
    THEN BEGIN {marked in error}
          IF VerboseMov
           THEN BEGIN {show message}
                 SS := s_VMsg3 + IntToStr(X) + ',' + IntToStr(Y);
                 IF SoundOn THEN DoTheSound(sid_Beep);
                 IF MessageBox(SS,mtInformation,mbOKCancel) <> mrOK
                  THEN StopComputer := TRUE;
                END; {then}
          UserMarked[X,Y] := 0;
          DisplayCell(X,Y);
         END; {then}
   Application.ProcessMessages;
  END; (*tboomwin.markbombcell*)

(************************************************************************)

 FUNCTION TBOOMWIN.AddToPositionList(VAR PL : TPLIST;
                                     PLH, X, Y : INTEGER) : INTEGER;
     (* function to add position to list *)

    VAR NIndex : INTEGER;
        FoundF : BOOLEAN;

  BEGIN (*tboomwin.addtopositionlist*)
   ComputeAdjacency(X,Y); FoundF := FALSE; NIndex := 0;
   WHILE (NIndex < PLH) AND NOT(FoundF) DO
    BEGIN {find it}
     IF(PL[NIndex,0] = X) AND (PL[NIndex,1] = Y)
      THEN FoundF := TRUE;
     Inc(NIndex);
    END; {while}
   IF NOT(FoundF)
    THEN BEGIN {not here - add in then}
          PL[PLH,0] := X; PL[PLH,1] := Y; Inc(PLH);
         END; {then}
   IF (PLH > (Grid_X*Grid_Y)) AND (VerboseMov)
    THEN BEGIN {display error}
          IF SoundOn THEN DoTheSound(sid_Beep);
          IF MessageBox(s_VMsg4,mtInformation,mbOKCancel) <> mrOK
           THEN StopComputer := TRUE;
         END; {then}
   Application.ProcessMessages;
   AddToPositionList := PLH;
  END; (*tboomwin.addtopositionlist*)

(************************************************************************)

 FUNCTION TBOOMWIN.AddSurroundingToPositionList(VAR PL : TPLIST;
                                                PLH, X, Y : INTEGER) : INTEGER;
     (* function to add surrounding cells to list *)

    VAR DX, DY : INTEGER;

  BEGIN (*tboomwin.addsurroundingtopositionlist*)
   FOR DX := -1 TO 1 DO
    FOR DY := -1 TO 1 DO
     BEGIN {do it}
      IF ((X+DX) >= 0) AND ((X+DX) < Grid_X) AND
         ((Y+DY) >= 0) AND ((Y+DY) < Grid_Y)
       THEN IF (GameBoard[X+DX,Y+DY] = b_Visited) OR
               (GameBoard[X+DX,Y+DY] = b_Current)
             THEN PLH := AddToPositionList(PL,PLH,X+DX,Y+DY);
     END; {for dx/dy}
   Application.ProcessMessages;
   AddSurroundingToPositionList := PLH;
  END; (*tboomwin.addsurroundingtopositionlist*)

(************************************************************************)

 PROCEDURE TBOOMWIN.VisitCell(X, Y : INTEGER);
     (* procedure to visit a cell and mark it visited *)

    VAR SS : STRING[80];

  BEGIN (*tboomwin.visitcell*)
   IF GameBoard[X,Y] <> b_Current
    THEN BEGIN {visit it}
          IF GameBoard[X,Y] = b_Bomb
           THEN BEGIN {whoops, walked on bomb}
                 IF VerboseMov
                  THEN BEGIN {show message}
                        SS := s_VMsg5 + IntToStr(X) + ',' + IntToStr(Y);
                        IF SoundOn THEN DoTheSound(sid_Beep);
                        IF MessageBox(SS,mtInformation,mbOKCancel) <> mrOK
                         THEN StopComputer := TRUE;
                       END; {then}
                END {then}
          ELSE BEGIN {mark it visited}
                GameBoard[X,Y] := b_Visited;
                DisplayCell(X,Y);
               END; {else}
         END; {then}
  END; (*tboomwin.visitcell*)

(************************************************************************)

 FUNCTION TBOOMWIN.FindPositionInAG(PAG : ADJACENCYGROUP;
                                    X, Y : INTEGER) : BOOLEAN;
     (* function to return position of ag in ag list *)

    VAR NIndex : INTEGER;
        FoundF : BOOLEAN;

  BEGIN (*tboomwin.findpositioninag*)
   FoundF := FALSE;
   FOR NIndex := 0 TO (PAG.CellCount-1) DO
    IF (PAG.Cell[NIndex,0] = X) AND (PAG.Cell[NIndex,1] = Y)
     THEN FoundF := TRUE;
   FindPositionInAG := FoundF;
  END; (*tboomwin.findpositioninag*)

(************************************************************************)

 FUNCTION TBOOMWIN.CountCommonCells(PGrp1, PGrp2 : ADJACENCYGROUP) : INTEGER;
     (* function to sum the common cells between groups *)

    VAR Cel, Cnt : INTEGER;

  BEGIN (*tboomwin.countcommoncells*)
   Cnt := 0;
   FOR Cel := 0 TO PGrp1.CellCount-1 DO
    BEGIN {roll through and count}
     IF FindPositionInAG(PGrp2,PGrp1.Cell[Cel,0],PGrp1.Cell[Cel,1])
      THEN Inc(Cnt);
    END; {for}
   Application.ProcessMessages;
   CountCommonCells := Cnt;
  END; (*tboomwin.countcommoncells*)

(************************************************************************)

 FUNCTION TBOOMWIN.ProcessRule3(VAR CurrAG, TempAG : ADJACENCYGROUP;
                                VAR PL : TPLIST; VAR PLH : INTEGER) : BOOLEAN;
     (* function to do rule 3 evaluation *)

    VAR X, BCnt, CCnt, PPLH, CHoldHead : INTEGER;
        CellHolder                     : ARRAY[0..9,0..1] OF INTEGER;
        RetVal                         : BOOLEAN;

  BEGIN (*tboomwin.processrule3*)
   PPLH := PLH; RetVal := FALSE;
   BCnt := CurrAG.BombCount; CCnt := CurrAG.CellCount;
   TempAG.CellCount := CountCommonCells(TempAG,CurrAG);
   IF TempAG.CellCount > 0
    THEN BEGIN {processing...}
          BCnt := BCnt - TempAG.BombCount;
          CCnt := CCnt - TempAG.CellCount;
          IF (CCnt > 0) AND ((BCnt = CCnt) OR (BCnt = 0))
           THEN BEGIN {processing...}
                 RetVal := TRUE; CHoldHead := 0; CCnt := CurrAG.CellCount;
                 FOR X := 0 TO CCnt-1 DO
                  BEGIN {processing ...}
                   IF NOT(FindPositionInAG(TempAG,CurrAG.Cell[X,0],
                                                  CurrAG.Cell[X,1]))
                    THEN BEGIN {processing...}
                          IF BCnt = 0
                           THEN VisitCell(CurrAG.Cell[X,0],CurrAG.Cell[X,1])
                          ELSE MarkBombCell(CurrAG.Cell[X,0],CurrAG.Cell[X,1]);
                          CellHolder[CHoldHead,0] := CurrAG.Cell[X,0];
                          CellHolder[CHoldHead,1] := CurrAG.Cell[X,1];
                          Inc(CHoldHead);
                         END; {then}
                  END; {for loop}
                 Application.ProcessMessages;
                 FOR X := 0 TO CHoldHead-1 DO
                  BEGIN {processing...}
                   PPLH := AddSurroundingToPositionList(PL,PPLH,
                                                        CellHolder[X,0],
                                                        CellHolder[X,1]);
                  END; {for loop}
                END; {then}
         END; {then}
   PLH := PPLH;
   ProcessRule3 := RetVal;
  END; (*tboomwin.processrule3*)

(************************************************************************)

 PROCEDURE TBOOMWIN.Do_Eval;
     (* procedure used to do computer evaluation procedure *)

    VAR Modified, DoneF         : BOOLEAN;
        PositionListHead, DX, DY,
        CurrentX, CurrentY,
        X, Y, BCnt, CCnt, Cel   : INTEGER;
        PositionList            : TPLIST;
        TempAG                  : ADJACENCYGROUP;

  BEGIN (*tboomwin.do_eval*)
   I_Helped := TRUE; Modified := TRUE;
   FOR X := 0 TO Grid_X-1 DO
    FOR Y := 0 TO Grid_Y-1 DO
     ComputeAdjacency(X,Y);
   Application.ProcessMessages;
   PositionList[0,0] := UserX; PositionList[0,1] := UserY;
   PositionListHead := 1;
   WHILE (Modified) AND NOT(StopComputer) DO
    BEGIN {do evaluation}
     Modified := FALSE;
     WHILE (PositionListHead > 0) AND NOT(StopComputer) DO
      BEGIN {do each position}
       CurrentX := PositionList[0,0]; CurrentY := PositionList[0,1];
       FOR X := 0 TO PositionListHead-2 DO
        BEGIN {move back}
         PositionList[X,0] := PositionList[X+1,0];
         PositionList[X,1] := PositionList[X+1,1];
        END; {for x}
       Dec(PositionListHead);
       ComputeAdjacency(CurrentX,CurrentY);
       BCnt := AdjacentGroup[CurrentX,CurrentY].BombCount;
       CCnt := AdjacentGroup[CurrentX,CurrentY].CellCount;
       IF (CCnt > 0) AND (BCnt > -1)
        THEN BEGIN {run the rules}
         {rule 1, if number of bombs = number of cells, all are bombs}
         IF CCnt = BCnt
          THEN FOR Cel := 0 TO CCnt-1 DO
                BEGIN {mark them all}
                 X := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,0];
                 Y := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,1];
                 MarkBombCell(X,Y); IF StopComputer THEN Break;
                 Modified := TRUE;
                 PositionListHead := AddSurroundingToPositionList(
                                                              PositionList,
                                                              PositionListHead,
                                                              X,Y);
                END {for cel}
         ELSE IF (BCnt = 0) AND (CCnt > 0)
               THEN FOR Cel := 0 TO CCnt DO
                     BEGIN {rule 2, # bombs = 0, all cells ok}
                      X := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,0];
                      Y := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,1];
                      VisitCell(X,Y); IF StopComputer THEN Break;
                      Modified := TRUE;
                      PositionListHead := AddToPositionList(PositionList,
                                                            PositionListHead,
                                                            X,Y);
                      PositionListHead := AddSurroundingToPositionList(
                                                              PositionList,
                                                              PositionListHead,
                                                              X,Y);
                     END {for cel}
              ELSE BEGIN {rule 3, if AGs overlaps, subtract, ck rule 1 and 2}
                    DoneF := FALSE; Cel := 0;
                    WHILE (Cel < CCnt) AND NOT(DoneF) DO
                     BEGIN {checking...}
                      Application.ProcessMessages; IF StopComputer THEN Break;
                      X := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,0];
                      Y := AdjacentGroup[CurrentX,CurrentY].Cell[Cel,1];
                      DX := -1;
                      WHILE (DX <= 1) AND NOT(DoneF) DO
                       BEGIN {checking...}
                        DY := -1;
                        WHILE (DY <= 1) AND NOT(DoneF) DO
                         BEGIN {checking...}
                          IF ((X+DX) >= 0) AND ((X+DX) < Grid_X) AND
                             ((Y+DY) >= 0) AND ((Y+DY) < Grid_Y)
                           THEN BEGIN {on board}
                                 TempAG := AdjacentGroup[X+DX,Y+DY];
                                 IF TempAG.BombCount > 0
                                  THEN BEGIN {process for rule 3}
                                        DoneF := ProcessRule3(
                                              AdjacentGroup[CurrentX,CurrentY],
                                              TempAG,PositionList,
                                              PositionListHead);
                                        IF StopComputer THEN Break;
                                        IF DoneF THEN Modified := TRUE;
                                       END; {then}
                                 AdjacentGroup[X+DX,Y+DY] := TempAG;
                                END; {then}
                          Inc(DY);
                         END; {while}
                        Inc(DX);
                       END; {while}
                      Inc(Cel);
                     END; {while}
                   END; {else}
             END; {then}
      END; {while}
     IF (Modified) AND NOT(StopComputer)
      THEN FOR X := 0 TO Grid_X-1 DO
            FOR Y := 0 TO Grid_Y-1 DO
             BEGIN {rework grid}
              Application.ProcessMessages; IF StopComputer THEN Break;
              IF (GameBoard[X,Y] = b_Visited) OR (GameBoard[X,Y] = b_Current)
               THEN PositionListHead := AddToPositionList(PositionList,
                                                          PositionListHead,
                                                          X,Y);
             END; {for x/y}
    END; {while loop}
   GameBoard[Grid_X-1,Grid_Y-1] := b_Finish;
   DisplayCell(Grid_X-1,Grid_Y-1);
   IF VerboseMov
    THEN BEGIN {show message - all done}
          IF SoundOn THEN DoTheSound(sid_Beep);
          MessageBox(s_VMsg2,mtInformation,[mbOK]);
         END; {then}
  END; (*tboomwin.do_eval*)

(************************************************************************)

 PROCEDURE TBOOMWIN.EvaluatePosition;
     (* procedure used to run computer evaluation of position *)

  BEGIN (*tboomwin.evaluateposition*)
   IF ConfirmsOn
    THEN IF MessageBox(s_CMsg2,mtConfirmation,mbYesNo) <> mrYes
          THEN Exit;
   PostMsg(Handle,wm_EvalMe,0,0);
  END; (*tboomwin.evaluateposition*)

(************************************************************************)

 PROCEDURE TBOOMWIN.DoTheSound(Which : INTEGER);
     (* procedure to setup and play the sound *)

    VAR SS : STRING;

  BEGIN (*tboomwin.dothesound*)
   SS := '';
   CASE Which OF
    sid_Beep     : SS := sf_Beep;
    sid_Finish   : SS := sf_Finish;
    sid_Explode  : SS := sf_Explode;
    sid_Negative : SS := sf_No;
   END; {case}
   IF (SS = '') OR NOT(FileExists(SS))
    THEN Beep(750,150)
   ELSE BEGIN {try to play file}
         AD_Sound.FileName := SS;
         AD_Sound.Play;
        END; {else}
  END; (*tboomwin.dothesound*)

(************************************************************************)

 PROCEDURE TBOOMWIN.WMEvalMe(VAR Msg : TMESSAGE);
     (* procedure to run evaluation procedure *)

  BEGIN (*tboomwin.wmevalme*)
   StopComputer := FALSE;
   EnDisAble(FALSE);
   MsgLine.Caption := s_VMsg1;
   Application.ProcessMessages;
   Do_Eval;
   EnDisAble(TRUE);
   Travel(0,0); {reset msg line}
  END; (*tboomwin.wmevalme*)

(************************************************************************)

INITIALIZATION
 RegisterClasses([TBoomWin, TDrawGrid, TGroupBox, TSpeedButton, TLabel,
                  TBitBtn, TPopupMenu, TMenuItem, TAudioDevice]);
END. (*of unit*)
