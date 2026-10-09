:userdoc.
:title.Kaboooom Help
:docprof toc=12.
:h1 res=1000.General
:p.Kaboooom! is a puzzle game&colon. walk from the top left corner of a field to the house in the bottom right corner without stepping on a mine. It is based on a game published by Alex Lane in Dr. Dobb's Journal in 1990 and was written for OS/2 by Michael G. Slack.
:p.:link reftype=hd res=1100.How to play:elink.
:p.:link reftype=hd res=1200.Keys and mouse:elink.
:p.:link reftype=hd res=1300.Settings:elink.
:p.:link reftype=hd res=1400.Computer Help:elink.
:p.:link reftype=hd res=1500.About Kaboooom:elink.
:h1 res=1100.How to play
:ul.
:li.You are the little man in the top left corner. Move one cell at a time, in any of the eight directions.
:li.Every cell you have walked on shows how many mines are in the cells around it (and in the cell itself). Use these numbers to find the safe way.
:li.If you think there is a mine in a cell next to you, mark it with the right mouse button. With Safe Game on you can not walk on a marked cell. Marks are only a help for you; they can be wrong.
:li.You win when you reach the house. You lose when you step on a mine. After the game all mines are shown.
:eul.
:h1 res=1200.Keys and mouse
:p.Move with the mouse, the pad on the right, the cursor keys or the numeric keypad&colon.
:table cols='18 34 36' rules=both frame=box.
:row.:c.:hp2.Action:ehp2.:c.:hp2.Key:ehp2.:c.:hp2.What it does:ehp2.
:row.:c.Move:c.Left click on a cell next to you:c.Walk to that cell
:row.:c.Move:c.Cursor keys, Home, End, Page Up, Page Down:c.Eight directions
:row.:c.Move:c.Numeric keypad 7 8 9 / 4 6 / 1 2 3:c.Eight directions
:row.:c.Mark:c.Right click on a cell next to you:c.Mark or unmark it
:row.:c.Mark:c.Ctrl and a cursor key:c.Mark or unmark that cell
:row.:c.Computer Help:c.Ctrl+E or 5 or the ? button:c.The computer works out what it can
:row.:c.New Game:c.Ctrl+N:c.Start a new field
:row.:c.Exit:c.Ctrl+X:c.Close the program
:row.:c.Frame Controls:c.Ctrl+F:c.Hide or show the title bar and menu
:etable.
:h1 res=1300.Settings
:p.Options - Settings changes the game. The settings are saved when you exit if Save settings on exit is checked.
:parml tsize=24 break=none.
:pt.Safe game
:pd.You can not walk on a cell you have marked.
:pt.Sounds on
:pd.Plays a sound for the events of the game&colon. the wave files beep.wav, finish.wav, explode.wav and negative.wav in the sounds folder next to the program. You can replace them with your own sounds.
:pt.Verbose computer messages
:pd.The computer also beeps when it has finished.
:pt.Confirmations on
:pd.Asks before a new game and before the computer helps.
:pt.Random number of bombs
:pd.Every new game has between 10 and 40 mines. Without it you choose the number of bombs (10-40).
:pt.Language
:pd.Language of the program and of the help (Options - Language).
:eparml.
:h1 res=1400.Computer Help
:p.The computer looks at the numbers you have uncovered and works out which cells must be safe and which must be mines. Safe cells are opened (they show their number) and the mines are marked. Then it looks again, until it can find nothing more.
:p.If it can not deduce anything it tells you so. You are not moved by the computer; you walk yourself. If you win after using the help, the message says so.
:p.The help only uses the numbers on the board, never the hidden mines. Your own marks are ignored while it thinks.
:h1 res=1500.About Kaboooom
:p.Kaboooom 1.07 for OS/2, ArcaOS and eComStation.
:p.Original author&colon. Michael G. Slack (1997-1998).
:p.Based on Kaboooom! by Alex Lane, Dr. Dobb's Journal #163, April 1990.
:p.Port to Open Watcom 2.0&colon. OS2World community (2026).
:p.Licence&colon. BSD 3-Clause.
:euserdoc.
