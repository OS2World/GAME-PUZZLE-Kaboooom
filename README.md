# Kaboooom for ArcaOS / eComStation / OS/2

Kaboooom! is a minefield walking puzzle for the OS/2 Presentation Manager: walk from the top left corner to the house in the bottom right corner without stepping on a hidden mine. Every cell you have walked on shows how many mines are around it.

![Kaboooom ScreenShot](/doc/Kaboooom.png)

Based on the game Kaboooom! by Alex Lane (Dr. Dobb's Journal #163, April 1990), written for OS/2 by Michael G. Slack in 1997-1998 (Sibyl). Ported to C and Open Watcom 2.0 in 2026.

## Version

1.07

## License

BSD 3-Clause - see `doc/LICENSE.txt`

## Features

- 15 x 9 field, 10 to 40 mines (or a random number)
- Walk with the mouse, the cursor keys, the numeric keypad or the pad of buttons; right click (or Ctrl + cursor key) marks a mine
- Computer Help: the computer works out the safe cells and the mines from the numbers on the board
- Safe game, sounds, verbose messages and confirmations as settings; the game events play wave files from the `sounds` folder
- 6-language interface **and** online help: English, Spanish, Dutch, German, French, Italian (Options - Language)
- Frame Controls toggle (Ctrl+F) for borderless play
- Settings saved to `Kaboooom.cfg` on exit (can be switched off)

## Keys

| Key | Action |
|-----|--------|
| Cursor keys, Home, End, PgUp, PgDn / keypad 7 8 9 4 6 1 2 3 | Walk |
| Ctrl + cursor key / right click | Mark or unmark a cell |
| Ctrl+E or 5 | Computer Help |
| Ctrl+N | New game |
| Ctrl+X | Exit |
| Ctrl+F | Frame Controls on/off |

## Installation

Run `Kaboooom.exe`. Keep the `help\` folder (one `.hlp` per language) and the `sounds\` folder (`beep.wav`, `finish.wav`, `explode.wav`, `negative.wav` - replace them with your own if you like) next to it. `Kaboooom.cfg` is created in the folder you start the program from.

## Compile Tools

- OpenWatcom 2.0 (`wmake`, `wcc386`, `wlink`, `wrc`, `wipfc`)
- OS/2 Toolkit 4.5

## Build

```
compile-wat.cmd
```

Output: `bin\Kaboooom.exe`, `bin\help\Kaboooom_xx.hlp` and `bin\sounds\*.wav`. The Pascal source is in `legacy\`.

## Requirements

- OS/2 Warp 4, eComStation, or ArcaOS
- 32-bit Presentation Manager

## Authors

- Original game: Alex Lane - 1990
- OS/2 version: Michael G. Slack - 1997-1998
- OS/2 port: OS2World community - 2026

## Links

- OS2World: https://www.os2world.com
