/*******************************************************************************
* SOUNDS.H - the wave files of the game events (MMPM/2, loaded when needed)
*
* The files are looked for in the "sounds" folder next to the program:
*   beep.wav  finish.wav  explode.wav  negative.wav
* Without the files, or without MMPM/2, a simple beep is used instead.
*******************************************************************************/

#ifndef SOUNDS_H
#define SOUNDS_H

enum { SND_BEEP = 1, SND_FINISH, SND_EXPLODE, SND_NEGATIVE };

void PlayGameSound(int which);
void SoundNotify(MPARAM mp1, MPARAM mp2);       /* MM_MCINOTIFY of the window */
void SoundOwner(HWND hwnd);                     /* window that gets the notify */
void CloseSounds(void);

#endif /* SOUNDS_H */
