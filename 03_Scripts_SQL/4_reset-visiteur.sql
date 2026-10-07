/* =========================================================
   REMISE A ZERO - a lancer par l'animateur entre 2 visiteurs
   Supprime la base footoria creee par le visiteur.
   Avant : arreter le site (Ctrl + C dans le terminal de VS Code).
   ========================================================= */
USE master;
GO
IF DB_ID('footoria') IS NOT NULL
BEGIN
    ALTER DATABASE footoria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE footoria;
END
GO
SELECT name FROM sys.databases WHERE name = 'footoria';   -- doit etre vide
GO
