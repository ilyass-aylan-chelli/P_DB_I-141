PROJET P_BD_141 - FOOTORIA (Portes Ouvertes ETML)
=================================================

Footoria_P_BD_141/
|
|-- 01_Manuels/
|     |-- Manuel_installation_Footoria.docx     (administrateur du poste)
|     |-- Manuel_formation_Footoria.docx        (animateur)
|
|-- 02_Documents_visiteurs/
|     |-- Document_visiteur_Footoria.docx       (version Word)
|     |-- Document_visiteur_Footoria.pdf        (version PDF)
|
|-- 03_Scripts_SQL/                              (scripts d'origine, non modifies)
|     |-- 1_projet-141-ilyass-chelli.sql        Script 1 : cree la base et les tables
|     |-- 2_données.sql                         Script 2 : equipes, competitions, 10 000 000 joueurs
|     |-- 3_données-partie-2.sql                Script 3 : qualifier et matchs
|     |-- 4_reset-visiteur.sql              Animateur : supprime la base entre 2 visiteurs
|           
|
|-- 04_Application/
|     |-- Site_Footoria222/                         Site a remettre au visiteur a l'etape B
|           |-- _pycache_
|           |-- app.py                           2 missions, connexion SQL Server
|           |-- templates/index.html
|           |-- static/                          style.css, app.js, poster.jpg
|           |-- LISEZ-MOI.txt
|
|-- 05_Reponses_requetes/
|      |-- Reponses_requetes.txt                 Solutions des 2 missions (animateur)
|     |-- bandrolle
|     |-- journal de travaille
|     |-- commande terminal vscode.txt
|     |-- README

Ordre d'utilisation : lire 01_Manuels, installer le poste, puis suivre 02_Documents_visiteurs.
Les scripts 1, 2 et 3 sont a executer dans cet ordre dans SSMS.
