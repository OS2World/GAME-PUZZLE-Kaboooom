:userdoc.
:title.Aide de Kaboooom
:docprof toc=12.
:h1 res=1000.General
:p.Kaboooom! est un jeu de reflexion&colon. allez du coin superieur gauche d'un champ a la maison du coin inferieur droit sans marcher sur une mine. Il est base sur un jeu d'Alex Lane publie dans Dr. Dobb's Journal en 1990 et a ete ecrit pour OS/2 par Michael G. Slack.
:p.:link reftype=hd res=1100.Comment jouer:elink.
:p.:link reftype=hd res=1200.Touches et souris:elink.
:p.:link reftype=hd res=1300.Parametres:elink.
:p.:link reftype=hd res=1400.Aide de l'ordinateur:elink.
:p.:link reftype=hd res=1500.A propos de Kaboooom:elink.
:h1 res=1100.Comment jouer
:ul.
:li.Vous etes le petit bonhomme du coin superieur gauche. Avancez d'une case a la fois, dans l'une des huit directions.
:li.Chaque case sur laquelle vous avez marche indique combien de mines se trouvent dans les cases autour (et dans la case elle-meme). Servez-vous de ces nombres pour trouver le chemin sur.
:li.Si vous pensez qu'il y a une mine dans une case voisine, marquez-la avec le bouton droit de la souris. Avec Jeu sur, vous ne pouvez pas marcher sur une case marquee. Les marques ne sont qu'une aide; elles peuvent etre fausses.
:li.Vous gagnez en atteignant la maison. Vous perdez en marchant sur une mine. Apres la partie, toutes les mines sont montrees.
:eul.
:h1 res=1200.Touches et souris
:p.Deplacez-vous avec la souris, le pave a droite, les touches curseur ou le pave numerique&colon.
:table cols='18 34 36' rules=both frame=box.
:row.:c.:hp2.Action:ehp2.:c.:hp2.Touche:ehp2.:c.:hp2.Effet:ehp2.
:row.:c.Aller:c.Clic gauche sur une case voisine:c.Aller sur cette case
:row.:c.Aller:c.Touches curseur, Debut, Fin, Page precedente, Page suivante:c.Huit directions
:row.:c.Aller:c.Pave numerique 7 8 9 / 4 6 / 1 2 3:c.Huit directions
:row.:c.Marquer:c.Clic droit sur une case voisine:c.Marquer ou demarquer
:row.:c.Marquer:c.Ctrl et une touche curseur:c.Marquer ou demarquer cette case
:row.:c.Aide de l'ordinateur:c.Ctrl+E ou 5 ou le bouton ?:c.L'ordinateur deduit ce qu'il peut
:row.:c.Nouvelle Partie:c.Ctrl+N:c.Commencer un nouveau champ
:row.:c.Quitter:c.Ctrl+X:c.Fermer le programme
:row.:c.Controles du cadre:c.Ctrl+F:c.Masquer ou afficher la barre de titre et le menu
:etable.
:h1 res=1300.Parametres
:p.Options - Parametres modifie le jeu. Les parametres sont enregistres en quittant si Enregistrer les parametres en quittant est coche.
:parml tsize=24 break=none.
:pt.Jeu sur
:pd.On ne peut pas marcher sur une case marquee.
:pt.Son active
:pd.Joue un son lors des evenements du jeu&colon. les fichiers beep.wav, finish.wav, explode.wav et negative.wav du dossier sounds a cote du programme. Vous pouvez les remplacer par les votres.
:pt.Messages detailles
:pd.L'ordinateur bipe aussi quand il a termine.
:pt.Confirmations
:pd.Demande avant une nouvelle partie et avant que l'ordinateur aide.
:pt.Nombre aleatoire de bombes
:pd.Chaque nouvelle partie a entre 10 et 40 mines. Sans cette option, vous choisissez le nombre de bombes (10-40).
:pt.Langue
:pd.Langue du programme et de l'aide (Options - Langue).
:eparml.
:h1 res=1400.Aide de l'ordinateur
:p.L'ordinateur regarde les nombres que vous avez decouverts et deduit quelles cases sont sures et lesquelles sont des mines. Les cases sures sont ouvertes (elles montrent leur nombre) et les mines sont marquees. Puis il regarde de nouveau, jusqu'a ne plus rien trouver.
:p.S'il ne peut rien deduire, il vous le dit. L'ordinateur ne vous deplace pas; vous marchez vous-meme. Si vous gagnez apres l'aide, le message l'indique.
:p.L'aide n'utilise que les nombres du plateau, jamais les mines cachees. Vos propres marques sont ignorees pendant qu'il reflechit.
:h1 res=1500.A propos de Kaboooom
:p.Kaboooom 1.07 pour OS/2, ArcaOS et eComStation.
:p.Auteur original&colon. Michael G. Slack (1997-1998).
:p.Base sur Kaboooom! d'Alex Lane, Dr. Dobb's Journal #163, avril 1990.
:p.Portage vers Open Watcom 2.0&colon. communaute OS2World (2026).
:p.Licence&colon. BSD a 3 clauses.
:euserdoc.
