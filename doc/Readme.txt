Kaboooom for ArcaOS / eComStation / OS/2
=========================================
Version 1.07

OVERVIEW
--------
Kaboooom! is a puzzle game for OS/2 Presentation Manager. You walk across
a field of 15 x 9 cells, from the top left corner to the house in the
bottom right corner, without stepping on a hidden mine. Every cell you
have walked on shows how many mines are around it.

Based on the game Kaboooom! written by Alex Lane (Dr. Dobb's Journal #163,
April 1990), ported to Pascal by Michael G. Slack in 1990 and to OS/2
(Sibyl) in 1997-1998. Ported to C and OpenWatcom 2.0 by the OS2World
community in 2026.

  - Six languages for the interface and the online help: English,
    Spanish, Dutch, German, French, Italian (Options - Language)
  - "Computer Help": the computer works out the safe cells and the mines
    from the numbers on the board
  - Safe game, sounds, verbose messages, confirmations and the number of
    bombs (10-40, or random) can be set
  - Frame Controls (Ctrl+F) for borderless play
  - Settings are saved to Kaboooom.cfg on exit (can be switched off)

HOW TO PLAY
-----------
  You are the little man in the top left corner. Move one cell at a time
  in any of the eight directions. A cell you have walked on shows the
  number of mines around it (and in it). Use the numbers to find a safe way.

  If you think a cell next to you holds a mine, mark it. With "Safe game"
  on you can not walk on a marked cell. The marks are only a help for you
  and can be wrong.

  You win when you reach the house. You lose when you step on a mine; at
  the end all the mines are shown.

CONTROLS
--------
  Mouse
    Left click on a cell next to you      walk to that cell
    Right click on a cell next to you     mark / unmark it
  Keyboard
    Cursor keys, Home, End, PgUp, PgDn    walk in eight directions
    Numeric keypad 7 8 9 / 4 6 / 1 2 3    walk in eight directions
    Ctrl + a cursor key                   mark / unmark that cell
    Ctrl+E or 5                           Computer Help
    Ctrl+N                                new game
    Ctrl+X                                exit
    Ctrl+F                                Frame Controls (borderless)
  The pad of nine buttons on the right does the same as the keypad; the
  middle button (?) is the Computer Help.

COMPUTER HELP
-------------
  The computer looks at the numbers you have uncovered. Cells that must be
  safe are opened (they show their number) and cells that must be mines
  are marked, again and again until nothing more can be found. It never
  looks at the hidden mines and ignores your own marks while it thinks. It
  does not move you. If you win after asking for help, the message says so.

SETTINGS (Options - Settings)
-----------------------------
  Safe game, Sounds on (on by default), Verbose computer messages,
  Confirmations on, Random number of bombs, or a fixed Number of bombs
  (10-40). The new number of bombs counts from the next game.
  Settings are stored in Kaboooom.cfg in the current directory; delete it
  to go back to the defaults.

FILE LIST
---------
  Kaboooom.exe         the program
  sounds\*.wav         beep, finish, explode and negative: the sounds of the game
                       events; keep the sounds folder next to the program. You
                       can replace them with your own wave files of the same name
  help\Kaboooom_xx.hlp the online help, one file per language (en es nl de
                       fr it); keep the help folder next to the program
  doc\Readme.txt       this file
  doc\Changelog.txt    the changes
  doc\LICENSE.txt      the license
  Kaboooom.cfg         your settings (created by the program)

REQUIREMENTS
------------
  OS/2 Warp 4, eComStation or ArcaOS (32-bit Presentation Manager)

COMPILING FROM SOURCE
---------------------
  OpenWatcom 2.0 (wmake, wcc386, wlink, wrc, wipfc) and the OS/2 Toolkit 4.5.
  Run compile-wat.cmd; the output is bin\Kaboooom.exe, bin\help\Kaboooom_xx.hlp
  and bin\sounds\*.wav (copied from sounds\). The Pascal source is kept in legacy\.

DISCLAIMER
----------
  The software is provided "as is" without warranty of any kind, see
  doc\LICENSE.txt. Use it at your own risk.

AUTHOR
------
  Original author:  Michael G. Slack (1997-1998)
  Original game:    Alex Lane (Dr. Dobb's Journal, 1990)
  OS/2 port:        OS2World community (2026)
  OS2World site:    https://www.os2world.com
