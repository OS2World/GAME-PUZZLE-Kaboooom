:userdoc.
:title.Kaboooom Hilfe
:docprof toc=12.
:h1 res=1000.Allgemein
:p.Kaboooom! ist ein Denkspiel&colon. Gehen Sie von der linken oberen Ecke eines Feldes zum Haus in der rechten unteren Ecke, ohne auf eine Mine zu treten. Es beruht auf einem Spiel von Alex Lane aus dem Dr. Dobb's Journal (1990) und wurde von Michael G. Slack fuer OS/2 geschrieben.
:p.:link reftype=hd res=1100.Spielanleitung:elink.
:p.:link reftype=hd res=1200.Tasten und Maus:elink.
:p.:link reftype=hd res=1300.Einstellungen:elink.
:p.:link reftype=hd res=1400.Computerhilfe:elink.
:p.:link reftype=hd res=1500.Info zu Kaboooom:elink.
:h1 res=1100.Spielanleitung
:ul.
:li.Sie sind das Maennchen in der linken oberen Ecke. Gehen Sie jeweils ein Feld weiter, in eine der acht Richtungen.
:li.Jedes Feld, auf dem Sie waren, zeigt, wie viele Minen in den Feldern ringsum (und im Feld selbst) liegen. Finden Sie damit den sicheren Weg.
:li.Glauben Sie, dass in einem Feld neben Ihnen eine Mine liegt, markieren Sie es mit der rechten Maustaste. Bei Sicherem Spiel koennen Sie nicht auf ein markiertes Feld gehen. Markierungen sind nur eine Hilfe; sie koennen falsch sein.
:li.Sie gewinnen, wenn Sie das Haus erreichen. Sie verlieren, wenn Sie auf eine Mine treten. Danach werden alle Minen gezeigt.
:eul.
:h1 res=1200.Tasten und Maus
:p.Bewegen Sie sich mit der Maus, dem Feld rechts, den Cursortasten oder dem Ziffernblock&colon.
:table cols='18 34 36' rules=both frame=box.
:row.:c.:hp2.Aktion:ehp2.:c.:hp2.Taste:ehp2.:c.:hp2.Was sie tut:ehp2.
:row.:c.Gehen:c.Linksklick auf ein Nachbarfeld:c.Auf dieses Feld gehen
:row.:c.Gehen:c.Cursortasten, Pos1, Ende, Bild auf, Bild ab:c.Acht Richtungen
:row.:c.Gehen:c.Ziffernblock 7 8 9 / 4 6 / 1 2 3:c.Acht Richtungen
:row.:c.Markieren:c.Rechtsklick auf ein Nachbarfeld:c.Markieren oder Markierung entfernen
:row.:c.Markieren:c.Strg und eine Cursortaste:c.Dieses Feld markieren oder entmarkieren
:row.:c.Computerhilfe:c.Strg+E oder 5 oder die Taste ?:c.Der Computer rechnet, was er kann
:row.:c.Neues Spiel:c.Strg+N:c.Ein neues Feld beginnen
:row.:c.Verlassen:c.Strg+X:c.Programm schliessen
:row.:c.Fensterelemente:c.Strg+F:c.Titelleiste und Menue ein- oder ausblenden
:etable.
:h1 res=1300.Einstellungen
:p.Optionen - Einstellungen aendert das Spiel. Die Einstellungen werden beim Beenden gespeichert, wenn Einstellungen beim Beenden speichern markiert ist.
:parml tsize=24 break=none.
:pt.Sicheres Spiel
:pd.Auf ein markiertes Feld kann man nicht gehen.
:pt.Ton an
:pd.Spielt bei Ereignissen im Spiel einen Ton&colon. die Dateien beep.wav, finish.wav, explode.wav und negative.wav im Ordner sounds neben dem Programm. Sie koennen sie durch eigene Toene ersetzen.
:pt.Ausfuehrliche Computermeldungen
:pd.Der Computer piept auch, wenn er fertig ist.
:pt.Bestaetigungen
:pd.Fragt vor einem neuen Spiel und bevor der Computer hilft.
:pt.Zufaellige Anzahl Bomben
:pd.Jedes neue Spiel hat zwischen 10 und 40 Minen. Ohne diese Option waehlen Sie die Anzahl der Bomben (10-40).
:pt.Sprache
:pd.Sprache des Programms und der Hilfe (Optionen - Sprache).
:eparml.
:h1 res=1400.Computerhilfe
:p.Der Computer betrachtet die Zahlen, die Sie aufgedeckt haben, und rechnet aus, welche Felder sicher sind und welche Minen enthalten. Sichere Felder werden geoeffnet (sie zeigen ihre Zahl), Minen werden markiert. Dann schaut er erneut, bis er nichts mehr findet.
:p.Kann er nichts ableiten, sagt er es Ihnen. Der Computer bewegt Sie nicht; Sie gehen selbst. Gewinnen Sie nach der Hilfe, steht das in der Meldung.
:p.Die Hilfe benutzt nur die Zahlen auf dem Brett, nie die versteckten Minen. Ihre eigenen Markierungen werden ignoriert.
:h1 res=1500.Info zu Kaboooom
:p.Kaboooom 1.07 fuer OS/2, ArcaOS und eComStation.
:p.Urspruenglicher Autor&colon. Michael G. Slack (1997-1998).
:p.Beruht auf Kaboooom! von Alex Lane, Dr. Dobb's Journal #163, April 1990.
:p.Portierung auf Open Watcom 2.0&colon. OS2World-Community (2026).
:p.Lizenz&colon. BSD 3-Clause.
:euserdoc.
