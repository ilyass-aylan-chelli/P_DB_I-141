/* =========================================================
   FOOTORIA - SCRIPT 2 OPTIMISE : equipes, competitions, joueurs
   Donnees IDENTIQUES a la version d'origine (memes joueurs, memes id).

   Optimisations :
   - base en mode de recuperation SIMPLE (journal de transactions minimal)
   - tables de noms / prenoms indexees (recherche par cle au lieu d'un balayage
     de table pour chacun des 10 millions de joueurs)
   - generateur de nombres leger (1 000 000 de nombres, reutilise par lots)
   - insertion par lots de 1 000 000 de lignes avec TABLOCK + CHECKPOINT
   - cle etrangere verifiee une seule fois a la fin
   - duree et progression affichees dans l'onglet Messages

   Nombre de joueurs : variable @NB_JOUEURS (section 4).
   ========================================================= */

USE footoria;
GO

ALTER DATABASE footoria SET RECOVERY SIMPLE;
GO

SET NOCOUNT ON;
GO

/* =========================================================
   1. 100 EQUIPES
   ========================================================= */

INSERT INTO Equipe (id_equipe, nom_des_equipes, pays_des_equipes, Ville_des_equipes)
VALUES
('EQ001','Real Madrid','Espagne','Madrid'),
('EQ002','FC Barcelona','Espagne','Barcelona'),
('EQ003','Atletico Madrid','Espagne','Madrid'),
('EQ004','Sevilla FC','Espagne','Sevilla'),
('EQ005','Valencia CF','Espagne','Valencia'),
('EQ006','Athletic Bilbao','Espagne','Bilbao'),
('EQ007','Villarreal CF','Espagne','Villarreal'),
('EQ008','Real Sociedad','Espagne','San Sebastian'),
('EQ009','Real Betis','Espagne','Seville'),
('EQ010','Celta Vigo','Espagne','Vigo'),

('EQ011','Manchester City','Angleterre','Manchester'),
('EQ012','Manchester United','Angleterre','Manchester'),
('EQ013','Liverpool FC','Angleterre','Liverpool'),
('EQ014','Arsenal FC','Angleterre','London'),
('EQ015','Chelsea FC','Angleterre','London'),
('EQ016','Tottenham Hotspur','Angleterre','London'),
('EQ017','Newcastle United','Angleterre','Newcastle'),
('EQ018','Aston Villa','Angleterre','Birmingham'),
('EQ019','West Ham United','Angleterre','London'),
('EQ020','Everton FC','Angleterre','Liverpool'),

('EQ021','Bayern Munich','Allemagne','Munich'),
('EQ022','Borussia Dortmund','Allemagne','Dortmund'),
('EQ023','RB Leipzig','Allemagne','Leipzig'),
('EQ024','Bayer Leverkusen','Allemagne','Leverkusen'),
('EQ025','Eintracht Frankfurt','Allemagne','Frankfurt'),
('EQ026','Schalke 04','Allemagne','Gelsenkirchen'),
('EQ027','VfB Stuttgart','Allemagne','Stuttgart'),
('EQ028','Werder Bremen','Allemagne','Bremen'),
('EQ029','Borussia Monchengladbach','Allemagne','Monchengladbach'),
('EQ030','Hertha Berlin','Allemagne','Berlin'),

('EQ031','PSG','France','Paris'),
('EQ032','Olympique Marseille','France','Marseille'),
('EQ033','Olympique Lyonnais','France','Lyon'),
('EQ034','AS Monaco','France','Monaco'),
('EQ035','Lille OSC','France','Lille'),
('EQ036','OGC Nice','France','Nice'),
('EQ037','RC Lens','France','Lens'),
('EQ038','FC Nantes','France','Nantes'),
('EQ039','Stade Rennais','France','Rennes'),
('EQ040','Montpellier HSC','France','Montpellier'),

('EQ041','Juventus','Italie','Turin'),
('EQ042','Inter Milan','Italie','Milan'),
('EQ043','AC Milan','Italie','Milan'),
('EQ044','AS Roma','Italie','Rome'),
('EQ045','Lazio Rome','Italie','Rome'),
('EQ046','Napoli','Italie','Naples'),
('EQ047','Atalanta','Italie','Bergame'),
('EQ048','Fiorentina','Italie','Florence'),
('EQ049','Torino FC','Italie','Turin'),
('EQ050','Bologna FC','Italie','Bologna'),

('EQ051','Ajax','Pays-Bas','Amsterdam'),
('EQ052','PSV Eindhoven','Pays-Bas','Eindhoven'),
('EQ053','Feyenoord','Pays-Bas','Rotterdam'),
('EQ054','AZ Alkmaar','Pays-Bas','Alkmaar'),
('EQ055','FC Twente','Pays-Bas','Enschede'),
('EQ056','FC Utrecht','Pays-Bas','Utrecht'),
('EQ057','Vitesse','Pays-Bas','Arnhem'),
('EQ058','Groningen','Pays-Bas','Groningen'),
('EQ059','Heerenveen','Pays-Bas','Heerenveen'),
('EQ060','Sparta Rotterdam','Pays-Bas','Rotterdam'),

('EQ061','Benfica','Portugal','Lisbonne'),
('EQ062','FC Porto','Portugal','Porto'),
('EQ063','Sporting CP','Portugal','Lisbonne'),
('EQ064','Braga','Portugal','Braga'),
('EQ065','Vitoria Guimaraes','Portugal','Guimaraes'),
('EQ066','Boavista','Portugal','Porto'),
('EQ067','Maritimo','Portugal','Funchal'),
('EQ068','Rio Ave','Portugal','Vila do Conde'),
('EQ069','Famalicao','Portugal','Famalicao'),
('EQ070','Gil Vicente','Portugal','Barcelos'),

('EQ071','Galatasaray','Turquie','Istanbul'),
('EQ072','Fenerbahce','Turquie','Istanbul'),
('EQ073','Besiktas','Turquie','Istanbul'),
('EQ074','Trabzonspor','Turquie','Trabzon'),
('EQ075','Basaksehir','Turquie','Istanbul'),
('EQ076','Antalyaspor','Turquie','Antalya'),
('EQ077','Sivasspor','Turquie','Sivas'),
('EQ078','Kasimpasa','Turquie','Istanbul'),
('EQ079','Konyaspor','Turquie','Konya'),
('EQ080','Alanyaspor','Turquie','Alanya'),

('EQ081','Ajax Riviera','Suisse','Lausanne'),
('EQ082','FC Lausanne','Suisse','Lausanne'),
('EQ083','Servette FC','Suisse','Geneve'),
('EQ084','FC Basel','Suisse','Basel'),
('EQ085','Young Boys','Suisse','Bern'),
('EQ086','FC Zurich','Suisse','Zurich'),
('EQ087','FC Lugano','Suisse','Lugano'),
('EQ088','FC Sion','Suisse','Sion'),
('EQ089','FC Luzern','Suisse','Luzern'),
('EQ090','FC Winterthur','Suisse','Winterthur'),

('EQ091','Flamengo','Bresil','Rio de Janeiro'),
('EQ092','Palmeiras','Bresil','Sao Paulo'),
('EQ093','Santos FC','Bresil','Santos'),
('EQ094','Corinthians','Bresil','Sao Paulo'),
('EQ095','Sao Paulo FC','Bresil','Sao Paulo'),
('EQ096','Gremio','Bresil','Porto Alegre'),
('EQ097','Internacional','Bresil','Porto Alegre'),
('EQ098','Botafogo','Bresil','Rio de Janeiro'),
('EQ099','Vasco da Gama','Bresil','Rio de Janeiro'),
('EQ100','Cruzeiro','Bresil','Belo Horizonte');
GO


/* =========================================================
   2. 100 COMPETITIONS
   ========================================================= */

;WITH N AS
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO competition (id_competition, nom, pays)
SELECT
    'COMP' + RIGHT('000' + CAST(n AS VARCHAR(3)),3),
    CASE 
        WHEN n % 5 = 1 THEN 'Championnat National'
        WHEN n % 5 = 2 THEN 'Coupe Nationale'
        WHEN n % 5 = 3 THEN 'Ligue Professionnelle'
        WHEN n % 5 = 4 THEN 'Super Coupe'
        ELSE 'Coupe Internationale'
    END + ' ' + CAST(n AS VARCHAR(3)),
    CASE 
        WHEN n <= 10 THEN 'Espagne'
        WHEN n <= 20 THEN 'Angleterre'
        WHEN n <= 30 THEN 'Allemagne'
        WHEN n <= 40 THEN 'France'
        WHEN n <= 50 THEN 'Italie'
        WHEN n <= 60 THEN 'Pays-Bas'
        WHEN n <= 70 THEN 'Portugal'
        WHEN n <= 80 THEN 'Turquie'
        WHEN n <= 90 THEN 'Suisse'
        ELSE 'Bresil'
    END
FROM N;
GO


/* =========================================================
   3. TABLES TEMPORAIRES DE NOMS ET PRENOMS (avec cle primaire)
   ========================================================= */

CREATE TABLE #Prenoms
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    prenom VARCHAR(50)
);

INSERT INTO #Prenoms (prenom)
VALUES
('Lucas'),('Hugo'),('Gabriel'),('Leo'),('Louis'),
('Arthur'),('Jules'),('Nathan'),('Adam'),('Ethan'),
('Thomas'),('Noah'),('Enzo'),('Mathis'),('Antoine'),
('Maxime'),('Alexandre'),('Raphael'),('Theo'),('Paul'),
('Julien'),('Nicolas'),('Victor'),('Samuel'),('Rayan'),
('Yanis'),('Ilyes'),('Amine'),('Mehdi'),('Karim'),
('Sami'),('Adel'),('Bilal'),('Nassim'),('Sofiane'),
('Ayoub'),('Ismael'),('Omar'),('Mohamed'),('Ibrahim'),
('Daniel'),('David'),('Kevin'),('Alex'),('Martin'),
('Benjamin'),('Elias'),('Liam'),('Oscar'),('Felix'),
('Marco'),('Antonio'),('Diego'),('Miguel'),('Carlos'),
('Mateo'),('Javier'),('Enrique'),('Pablo'),('Sergio'),
('Julian'),('Adrian'),('Alvaro'),('Rodrigo'),('Fernando'),
('Ricardo'),('Andres'),('Rafael'),('Bruno'),('Tiago'),
('Joao'),('Diogo'),('Andre'),('Pedro'),('Luis'),
('Marco'),('Lorenzo'),('Matteo'),('Andrea'),('Luca'),
('Giovanni'),('Francesco'),('Davide'),('Stefano'),('Fabio'),
('Nabil'),('Walid'),('Hicham'),('Anis'),('Zakaria'),
('Moussa'),('Khalil'),('Samir'),('Kamel'),('Reda'),
('Youssef'),('Aymen'),('Fares'),('Tarek'),('Brahim');


CREATE TABLE #Noms
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nom VARCHAR(50)
);

INSERT INTO #Noms (nom)
VALUES
('Martin'),('Bernard'),('Dubois'),('Thomas'),('Robert'),
('Richard'),('Petit'),('Durand'),('Leroy'),('Moreau'),
('Simon'),('Laurent'),('Lefebvre'),('Michel'),('Garcia'),
('David'),('Bertrand'),('Roux'),('Vincent'),('Fournier'),
('Morel'),('Girard'),('Andre'),('Mercier'),('Dupont'),
('Lambert'),('Bonnet'),('Francois'),('Martinez'),('Legrand'),
('Garnier'),('Faure'),('Rousseau'),('Blanc'),('Guerin'),
('Muller'),('Henry'),('Roussel'),('Nicolas'),('Perrin'),
('Morin'),('Mathieu'),('Clement'),('Gauthier'),('Dumont'),
('Lopez'),('Fontaine'),('Chevalier'),('Robin'),('Masson'),
('Sanchez'),('Boyer'),('Denis'),('Lemaire'),('Duval'),
('Joly'),('Gautier'),('Roger'),('Roy'),('Noel'),
('Meyer'),('Lucas'),('Meunier'),('Jean'),('Perez'),
('Marchand'),('Dufour'),('Blanchard'),('Marie'),('Barbier'),
('Brun'),('Arnaud'),('Picard'),('Leclerc'),('Paris'),
('Renard'),('Schmitt'),('Lacroix'),('Colin'),('Vidal'),
('Alves'),('Silva'),('Santos'),('Costa'),('Pereira'),
('Fernandes'),('Oliveira'),('Rodrigues'),('Carvalho'),('Gomes'),
('Martins'),('Ribeiro'),('Sousa'),('Mendes'),('Correia'),
('Ferreira'),('Moreira'),('Nunes'),('Teixeira'),('Dias'),
('Benali'),('Bensaid'),('Belkacem'),('Bouzid'),('Saidi'),
('Mansouri'),('Khelifi'),('Haddad'),('Amara'),('Rahmani');
GO


/* =========================================================
   4. JOUEURS - insertion par lots de 1 000 000
   ========================================================= */

DECLARE @NB_JOUEURS INT = 10000000;     -- <<< nombre de joueurs a creer
DECLARE @debut      INT = 0;            -- nombre de joueurs deja crees
DECLARE @t0         DATETIME2 = SYSDATETIME();
DECLARE @msg        VARCHAR(100);

-- Generateur : les nombres 0 a 999 999 (une seule fois)
CREATE TABLE #Tally (k INT NOT NULL PRIMARY KEY);

;WITH D AS (SELECT d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS v(d))
INSERT INTO #Tally (k)
SELECT a.d * 100000 + b.d * 10000 + c.d * 1000 + e.d * 100 + f.d * 10 + g.d
FROM D a CROSS JOIN D b CROSS JOIN D c CROSS JOIN D e CROSS JOIN D f CROSS JOIN D g
ORDER BY 1;

-- La cle etrangere (id_equipe) est verifiee une seule fois a la fin
ALTER TABLE Joueurs NOCHECK CONSTRAINT ALL;

WHILE @debut < @NB_JOUEURS
BEGIN
    INSERT INTO Joueurs WITH (TABLOCK)
        (id_joueur, nom, prenom, age, poste, id_equipe)
    SELECT
        'J' + RIGHT('00000000' + CAST(x.n AS VARCHAR(8)), 8),
        nm.nom,
        pr.prenom,
        16 + CAST((x.n * 17) % 25 AS INT),
        CASE CAST(x.n % 4 AS INT)
            WHEN 0 THEN 'Gardien'
            WHEN 1 THEN 'Defenseur'
            WHEN 2 THEN 'Milieu'
            WHEN 3 THEN 'Attaquant'
        END,
        'EQ' + RIGHT('000' + CAST(((x.n - 1) % 100) + 1 AS VARCHAR(3)), 3)
    FROM
    (
        SELECT CAST(@debut AS BIGINT) + t.k + 1 AS n
        FROM #Tally AS t
        WHERE CAST(@debut AS BIGINT) + t.k + 1 <= @NB_JOUEURS
    ) AS x
    INNER JOIN #Prenoms AS pr ON pr.id = ((x.n - 1) % 100) + 1
    INNER JOIN #Noms    AS nm ON nm.id = (((x.n - 1) / 100) % 100) + 1
    ORDER BY x.n;

    SET @debut = @debut + 1000000;
    CHECKPOINT;

    SET @msg = CAST(CASE WHEN @debut > @NB_JOUEURS THEN @NB_JOUEURS ELSE @debut END AS VARCHAR(12))
             + ' / ' + CAST(@NB_JOUEURS AS VARCHAR(12)) + ' joueurs inseres...';
    RAISERROR(@msg, 0, 1) WITH NOWAIT;
END

-- Verification des cles etrangeres (une seule fois) : les contraintes redeviennent fiables
ALTER TABLE Joueurs WITH CHECK CHECK CONSTRAINT ALL;

DROP TABLE #Tally;

SET @msg = 'Duree de l''insertion des joueurs : '
         + CAST(DATEDIFF(SECOND, @t0, SYSDATETIME()) AS VARCHAR(12)) + ' secondes';
RAISERROR(@msg, 0, 1) WITH NOWAIT;
GO


/* =========================================================
   5. VERIFICATION (lecture rapide dans les tables systeme)
   ========================================================= */

SELECT 'Joueurs' AS TableName, SUM(p.rows) AS Nombre
FROM sys.partitions p
WHERE p.object_id = OBJECT_ID('dbo.Joueurs') AND p.index_id IN (0, 1)
UNION ALL
SELECT 'Equipe', COUNT(*) FROM Equipe
UNION ALL
SELECT 'competition', COUNT(*) FROM competition;
GO