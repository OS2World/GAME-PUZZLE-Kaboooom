/*******************************************************************************
* SOUNDS.C - play the wave files of the game events with MMPM/2
*
* MDM.DLL is loaded only when a sound is played, so the program also starts
* where MMPM/2 is not installed. One sound plays at a time; a new one stops
* the old one. If the wave file or MMPM/2 is missing a plain beep is played.
*******************************************************************************/

#define INCL_OS2MM
#include "kaboooom.h"
#include <os2me.h>
#include <stdio.h>
#include <string.h>

#include "sounds.h"

typedef ULONG (_System *PFNMCISEND)(USHORT, USHORT, ULONG, PVOID, USHORT);

static PFNMCISEND   pfnMciSend;
static HMODULE      hmodMDM;
static int          fTried;
static HWND         hwndOwner;
static USHORT       usDevice;                   /* open device, 0 = none     */

static const char  *szFiles[] = { "", "beep.wav", "finish.wav", "explode.wav", "negative.wav" };
static const int    Hz[]      = { 0, 750, 523, 400, 200 };    /* fallback beep */
static const int    Ms[]      = { 0, 150, 300, 300, 250 };


void SoundOwner(HWND hwnd)
{
    hwndOwner = hwnd;
}


static int LoadMDM(void)
{
    char err[64];

    if( fTried )
        return pfnMciSend != NULL;
    fTried = 1;

    if( DosLoadModule( err, sizeof(err), (PSZ)"MDM", &hmodMDM ) == 0 )
        DosQueryProcAddr( hmodMDM, 0, (PSZ)"mciSendCommand", (PFN *)&pfnMciSend );

    return pfnMciSend != NULL;
}


static void CloseDevice(void)
{
    if( usDevice && pfnMciSend )
        pfnMciSend( usDevice, MCI_CLOSE, MCI_WAIT, NULL, 0 );
    usDevice = 0;
}


/* The full name of a file in the sounds folder next to the program */
static int SoundPath(const char *file, char *out, size_t size)
{
    char         exe[CCHMAXPATH];
    PTIB         ptib;
    PPIB         ppib;
    char        *p;
    FILESTATUS3  fs;

    DosGetInfoBlocks( &ptib, &ppib );
    if( DosQueryModuleName( ppib->pib_hmte, sizeof(exe), exe ) )
        return 0;
    p = strrchr( exe, '\\' );
    if( !p )
        return 0;
    p[1] = 0;

    if( strlen(exe) + strlen("sounds\\") + strlen(file) + 1 > size )
        return 0;
    sprintf( out, "%ssounds\\%s", exe, file );

    return DosQueryPathInfo( out, FIL_STANDARD, &fs, sizeof(fs) ) == 0;
}


void PlayGameSound(int which)
{
    char            path[CCHMAXPATH];
    MCI_OPEN_PARMS  op;
    MCI_PLAY_PARMS  pp;
    ULONG           rc;

    if( which < 1 || which > 4 )
        return;

    if( !SoundPath( szFiles[which], path, sizeof(path) ) || !LoadMDM() )
    {
        DosBeep( Hz[which], Ms[which] );
        return;
    }

    CloseDevice();                              /* the old sound stops       */

    memset( &op, 0, sizeof(op) );
    op.pszDeviceType  = (PSZ)MAKEULONG( MCI_DEVTYPE_WAVEFORM_AUDIO, 0 );
    op.pszElementName = (PSZ)path;

    rc = pfnMciSend( 0, MCI_OPEN, MCI_WAIT | MCI_OPEN_ELEMENT | MCI_OPEN_TYPE_ID | MCI_OPEN_SHAREABLE,
                     &op, 0 );
    if( rc )
    {
        DosBeep( Hz[which], Ms[which] );
        return;
    }
    usDevice = op.usDeviceID;

    memset( &pp, 0, sizeof(pp) );
    pp.hwndCallback = hwndOwner;
    rc = pfnMciSend( usDevice, MCI_PLAY, MCI_NOTIFY, &pp, 0 );
    if( rc )
    {
        CloseDevice();
        DosBeep( Hz[which], Ms[which] );
    }
}


/* The sound has been played: free the device */
void SoundNotify(MPARAM mp1, MPARAM mp2)
{
    USHORT dev = SHORT1FROMMP(mp2);
    USHORT cmd = SHORT2FROMMP(mp2);

    (void)mp1;
    if( cmd == MCI_PLAY && dev == usDevice )
        CloseDevice();
}


void CloseSounds(void)
{
    CloseDevice();
    if( hmodMDM )
        DosFreeModule( hmodMDM );
    hmodMDM = NULLHANDLE;
    pfnMciSend = NULL;
}
