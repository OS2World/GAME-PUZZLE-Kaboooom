:userdoc.
:title.Guida di Kaboooom
:docprof toc=12.
:h1 res=1000.Generale
:p.Kaboooom! e un gioco di logica&colon. vai dall'angolo in alto a sinistra di un campo alla casa nell'angolo in basso a destra senza calpestare una mina. Si basa su un gioco di Alex Lane pubblicato su Dr. Dobb's Journal nel 1990 ed e stato scritto per OS/2 da Michael G. Slack.
:p.:link reftype=hd res=1100.Come giocare:elink.
:p.:link reftype=hd res=1200.Tasti e mouse:elink.
:p.:link reftype=hd res=1300.Impostazioni:elink.
:p.:link reftype=hd res=1400.Aiuto del computer:elink.
:p.:link reftype=hd res=1500.Informazioni su Kaboooom:elink.
:h1 res=1100.Come giocare
:ul.
:li.Sei l'omino nell'angolo in alto a sinistra. Muoviti di una casella alla volta, in una delle otto direzioni.
:li.Ogni casella su cui hai camminato mostra quante mine ci sono nelle caselle intorno (e nella casella stessa). Usa questi numeri per trovare la strada sicura.
:li.Se pensi che ci sia una mina in una casella vicina, segnala con il tasto destro del mouse. Con Gioco sicuro non puoi camminare su una casella segnata. I segni sono solo un aiuto; possono essere sbagliati.
:li.Vinci raggiungendo la casa. Perdi se calpesti una mina. A fine partita vengono mostrate tutte le mine.
:eul.
:h1 res=1200.Tasti e mouse
:p.Muoviti con il mouse, il pannello a destra, i tasti cursore o il tastierino numerico&colon.
:table cols='18 34 36' rules=both frame=box.
:row.:c.:hp2.Azione:ehp2.:c.:hp2.Tasto:ehp2.:c.:hp2.Cosa fa:ehp2.
:row.:c.Muovi:c.Clic sinistro su una casella vicina:c.Vai su quella casella
:row.:c.Muovi:c.Tasti cursore, Home, Fine, Pag su, Pag giu:c.Otto direzioni
:row.:c.Muovi:c.Tastierino numerico 7 8 9 / 4 6 / 1 2 3:c.Otto direzioni
:row.:c.Segna:c.Clic destro su una casella vicina:c.Segna o togli il segno
:row.:c.Segna:c.Ctrl e un tasto cursore:c.Segna o togli il segno a quella casella
:row.:c.Aiuto del computer:c.Ctrl+E o 5 o il pulsante ?:c.Il computer deduce cio che puo
:row.:c.Nuova Partita:c.Ctrl+N:c.Inizia un nuovo campo
:row.:c.Esci:c.Ctrl+X:c.Chiudi il programma
:row.:c.Controlli della cornice:c.Ctrl+F:c.Nascondi o mostra barra del titolo e menu
:etable.
:h1 res=1300.Impostazioni
:p.Opzioni - Impostazioni modifica il gioco. Le impostazioni vengono salvate all'uscita se Salva impostazioni all'uscita e selezionato.
:parml tsize=24 break=none.
:pt.Gioco sicuro
:pd.Non si puo camminare su una casella segnata.
:pt.Suoni attivi
:pd.Riproduce un suono per gli eventi del gioco&colon. i file beep.wav, finish.wav, explode.wav e negative.wav nella cartella sounds accanto al programma. Puoi sostituirli con i tuoi.
:pt.Messaggi dettagliati
:pd.Il computer emette un segnale anche quando ha finito.
:pt.Conferme
:pd.Chiede prima di una nuova partita e prima che il computer aiuti.
:pt.Numero casuale di bombe
:pd.Ogni nuova partita ha tra 10 e 40 mine. Senza questa opzione scegli il numero di bombe (10-40).
:pt.Lingua
:pd.Lingua del programma e dell'aiuto (Opzioni - Lingua).
:eparml.
:h1 res=1400.Aiuto del computer
:p.Il computer guarda i numeri che hai scoperto e deduce quali caselle sono sicure e quali contengono mine. Le caselle sicure vengono aperte (mostrano il loro numero) e le mine vengono segnate. Poi guarda di nuovo, finche non trova altro.
:p.Se non puo dedurre nulla te lo dice. Il computer non ti sposta; cammini tu. Se vinci dopo l'aiuto, il messaggio lo indica.
:p.L'aiuto usa solo i numeri sulla scacchiera, mai le mine nascoste. I tuoi segni vengono ignorati mentre pensa.
:h1 res=1500.Informazioni su Kaboooom
:p.Kaboooom 1.07 per OS/2, ArcaOS ed eComStation.
:p.Autore originale&colon. Michael G. Slack (1997-1998).
:p.Basato su Kaboooom! di Alex Lane, Dr. Dobb's Journal #163, aprile 1990.
:p.Port su Open Watcom 2.0&colon. comunita OS2World (2026).
:p.Licenza&colon. BSD a 3 clausole.
:euserdoc.
