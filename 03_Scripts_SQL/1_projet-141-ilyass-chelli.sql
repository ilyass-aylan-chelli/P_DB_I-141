USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'footoria')
BEGIN
    ALTER DATABASE footoria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE footoria;
END


CREATE DATABASE footoria;
GO

USE footoria;
GO

CREATE TABLE Equipe(
   id_equipe VARCHAR(50),
   nom_des_equipes VARCHAR(35),
   pays_des_equipes VARCHAR(20),
   Ville_des_equipes VARCHAR(50),
   PRIMARY KEY(id_equipe)
);

CREATE TABLE competition(
   id_competition VARCHAR(25),
   nom VARCHAR(50),
   pays VARCHAR(20),
   PRIMARY KEY(id_competition)
);

CREATE TABLE match_(
   id_match VARCHAR(40),
   date_match DATETIME,
   composition_match VARCHAR(50),
   Lieu VARCHAR(50),
   id_competition VARCHAR(25) NOT NULL,
   PRIMARY KEY(id_match),
   FOREIGN KEY(id_competition) REFERENCES competition(id_competition)
);

CREATE TABLE Joueurs(
   id_joueur VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   age INT,
   poste VARCHAR(20),
   id_equipe VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_joueur),
   FOREIGN KEY(id_equipe) REFERENCES Equipe(id_equipe)
);

CREATE TABLE qualifier(
   id_equipe VARCHAR(50),
   id_competition VARCHAR(25),
   PRIMARY KEY(id_equipe, id_competition),
   FOREIGN KEY(id_equipe) REFERENCES Equipe(id_equipe),
   FOREIGN KEY(id_competition) REFERENCES competition(id_competition)
);

CREATE TABLE marquer(
   id_joueur VARCHAR(50),
   id_match VARCHAR(40),
   PRIMARY KEY(id_joueur, id_match),
   FOREIGN KEY(id_joueur) REFERENCES Joueurs(id_joueur),
   FOREIGN KEY(id_match) REFERENCES match_(id_match)
);
