# Makefile for Kaboooom (Open Watcom C on OS/2 / ArcaOS)
# wmake 2.0.1 on ArcaOS - explicit per-file rules (no pattern rules)

# ============================================================================
# Configuration
# ============================================================================

NAME    = Kaboooom
SRCDIR  = src
BINDIR  = bin

!ifndef WATCOM
WATCOM  = C:\WATCOM
!endif

!ifndef WIPFC
WIPFC   = $(WATCOM)\wipfc
!endif

!ifndef OS2TK
OS2TK   = C:\OS2TK45
!endif

# ============================================================================
# Tools
# ============================================================================

CC      = wcc386
LINK    = wlink
RC      = wrc
IPFC    = wipfc

# ============================================================================
# Flags (per plan.txt section 2)
# ============================================================================

CFLAGS  = -bt=os2 -mf -5 -fpi -Oaxt -W3 -ze -d0
CFLAGS  = $(CFLAGS) -i=$(OS2TK)\h -i=$(SRCDIR)

RCFLAGS = -r -bt=os2 -i=$(OS2TK)\h -i=$(SRCDIR)

LFLAGS  = system os2v2_pm
LFLAGS  = $(LFLAGS) option stack=65536
LFLAGS  = $(LFLAGS) option map=$(BINDIR)\$(NAME).map

# ============================================================================
# Source files
# ============================================================================

GAME_OBJS = $(BINDIR)\main.obj $(BINDIR)\game.obj $(BINDIR)\lang.obj $(BINDIR)\prefs.obj $(BINDIR)\help.obj $(BINDIR)\dialogs.obj $(BINDIR)\sounds.obj

OBJS    = $(GAME_OBJS)

HLPDIR  = $(BINDIR)\help
SNDDIR  = $(BINDIR)\sounds
SOUNDS  = $(SNDDIR)\beep.wav $(SNDDIR)\finish.wav $(SNDDIR)\explode.wav $(SNDDIR)\negative.wav
HELPS   = $(HLPDIR)\Kaboooom_en.hlp $(HLPDIR)\Kaboooom_es.hlp $(HLPDIR)\Kaboooom_nl.hlp $(HLPDIR)\Kaboooom_de.hlp $(HLPDIR)\Kaboooom_fr.hlp $(HLPDIR)\Kaboooom_it.hlp

ROBJ    = $(BINDIR)\$(NAME).res
RCFILE  = $(SRCDIR)\$(NAME).rc
DEFFILE = $(SRCDIR)\$(NAME).def

# ============================================================================
# Targets
# ============================================================================

all : $(BINDIR)\$(NAME).exe helpfiles soundfiles .SYMBOLIC

soundfiles : $(SOUNDS) .SYMBOLIC
	@echo Sound files done

helpfiles : $(HELPS) .SYMBOLIC
	@echo Help files done

$(BINDIR) :
	@if not exist $(BINDIR) mkdir $(BINDIR)

$(BINDIR)\$(NAME).exe : $(OBJS) $(ROBJ) $(DEFFILE)
	@echo Linking $(NAME).exe...
	@$(LINK) $(LFLAGS) name $(BINDIR)\$(NAME).exe file $(BINDIR)\*.obj library os2386.lib
	@echo Binding resources...
	@$(RC) -q -bt=os2 -fe=$(BINDIR)\$(NAME).exe $(ROBJ) $(BINDIR)\$(NAME).exe
	@if exist $(BINDIR)\$(NAME).exe echo BUILD OK

# ============================================================================
# Game objects
# ============================================================================

$(BINDIR)\main.obj : $(SRCDIR)\main.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\main.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\main.c

$(BINDIR)\game.obj : $(SRCDIR)\game.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\game.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\game.c

$(BINDIR)\lang.obj : $(SRCDIR)\lang.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\lang.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\lang.c

$(BINDIR)\prefs.obj : $(SRCDIR)\prefs.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\prefs.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\prefs.c

$(BINDIR)\help.obj : $(SRCDIR)\help.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\help.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\help.c

$(BINDIR)\dialogs.obj : $(SRCDIR)\dialogs.c $(SRCDIR)\kaboooom.h $(BINDIR)
	@echo Compiling src\dialogs.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\dialogs.c

$(BINDIR)\sounds.obj : $(SRCDIR)\sounds.c $(SRCDIR)\kaboooom.h $(SRCDIR)\sounds.h $(BINDIR)
	@echo Compiling src\sounds.c
	@$(CC) $(CFLAGS) -fo=$@ $(SRCDIR)\sounds.c

# ============================================================================
# Resources. The bitmap files are referenced relative to the working
# directory, so wmake must run from the project root (see compile-wat.cmd).
# ============================================================================

$(ROBJ) : $(RCFILE) $(SRCDIR)\kaboooom.h src\Kaboooom.ico $(BINDIR)
	@echo Compiling resources...
	@$(RC) $(RCFLAGS) -fo=$(ROBJ) $(RCFILE)

# ============================================================================
# Help files (one per language, wipfc)
# ============================================================================

$(HLPDIR) :
	@if not exist $(HLPDIR) mkdir $(HLPDIR)

$(HLPDIR)\Kaboooom_en.hlp : help\Kaboooom_en.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_en.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l en_US -o $@ help\Kaboooom_en.ipf

$(HLPDIR)\Kaboooom_es.hlp : help\Kaboooom_es.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_es.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l en_US -o $@ help\Kaboooom_es.ipf

$(HLPDIR)\Kaboooom_nl.hlp : help\Kaboooom_nl.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_nl.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l en_US -o $@ help\Kaboooom_nl.ipf

$(HLPDIR)\Kaboooom_de.hlp : help\Kaboooom_de.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_de.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l de_DE -o $@ help\Kaboooom_de.ipf

$(HLPDIR)\Kaboooom_fr.hlp : help\Kaboooom_fr.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_fr.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l fr_FR -o $@ help\Kaboooom_fr.ipf

$(HLPDIR)\Kaboooom_it.hlp : help\Kaboooom_it.ipf $(HLPDIR)
	@echo Compiling help\Kaboooom_it.ipf
	@set WIPFC=$(WIPFC)
	@$(IPFC) -l en_US -o $@ help\Kaboooom_it.ipf

# ============================================================================
# Sound files: copied to bin\sounds, next to the program
# ============================================================================

$(SNDDIR) :
	@if not exist $(SNDDIR) mkdir $(SNDDIR)

$(SNDDIR)\beep.wav : sounds\beep.wav $(SNDDIR)
	@copy sounds\beep.wav $@ >nul

$(SNDDIR)\finish.wav : sounds\finish.wav $(SNDDIR)
	@copy sounds\finish.wav $@ >nul

$(SNDDIR)\explode.wav : sounds\explode.wav $(SNDDIR)
	@copy sounds\explode.wav $@ >nul

$(SNDDIR)\negative.wav : sounds\negative.wav $(SNDDIR)
	@copy sounds\negative.wav $@ >nul

# ============================================================================
# Clean
# ============================================================================

clean : .SYMBOLIC
	@if exist $(BINDIR)\*.obj del $(BINDIR)\*.obj >nul
	@if exist $(BINDIR)\$(NAME).res del $(BINDIR)\$(NAME).res >nul
	@if exist $(BINDIR)\$(NAME).exe del $(BINDIR)\$(NAME).exe >nul
	@if exist $(BINDIR)\$(NAME).map del $(BINDIR)\$(NAME).map >nul
	@if exist $(HLPDIR)\*.hlp del $(HLPDIR)\*.hlp >nul
	@if exist $(SNDDIR)\*.wav del $(SNDDIR)\*.wav >nul
	@echo Clean complete