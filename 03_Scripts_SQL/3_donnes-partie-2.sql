USE footoria;
GO

/* =========================================================
   REMPLIR LA TABLE QUALIFIER
   1000 relations équipe / compétition
   ========================================================= */

INSERT INTO qualifier (id_equipe, id_competition)
SELECT
    'EQ' + RIGHT(
        '000' + CAST(
            (((c.n - 1) * 10 + e.n - 1) % 100) + 1
            AS VARCHAR(3)
        ),
        3
    ),
    'COMP' + RIGHT(
        '000' + CAST(c.n AS VARCHAR(3)),
        3
    )
FROM
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
) c
CROSS JOIN
(
    SELECT TOP (10)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
) e;
GO


/* Vérification qualifier */

SELECT COUNT(*) AS Nombre_qualifications
FROM qualifier;
GO


/* =========================================================
   REMPLIR LA TABLE MATCH_
   100 000 matchs avec dates + heures
   ========================================================= */

;WITH N AS
(
    SELECT TOP (100000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO match_
(
    id_match,
    date_match,
    composition_match,
    Lieu,
    id_competition
)
SELECT

    /* ID du match */
    'MAT' + RIGHT(
        '000000' + CAST(n AS VARCHAR(6)),
        6
    ),

    /* DATE + HEURE DU MATCH */
    DATEADD(
        MINUTE,
        CASE n % 10
            WHEN 0 THEN 0      -- 13:00
            WHEN 1 THEN 90     -- 14:30
            WHEN 2 THEN 120    -- 15:00
            WHEN 3 THEN 180    -- 16:00
            WHEN 4 THEN 240    -- 17:00
            WHEN 5 THEN 330    -- 18:30
            WHEN 6 THEN 420    -- 20:00
            WHEN 7 THEN 465    -- 20:45
            WHEN 8 THEN 480    -- 21:00
            ELSE 540           -- 22:00
        END,
        DATEADD(
            DAY,
            (n * 13) % 2500,
            CAST('2020-01-01' AS DATETIME)
        )
    ),

    /* COMPOSITION */
    CASE n % 8
        WHEN 0 THEN '4-3-3'
        WHEN 1 THEN '4-4-2'
        WHEN 2 THEN '4-2-3-1'
        WHEN 3 THEN '3-5-2'
        WHEN 4 THEN '3-4-3'
        WHEN 5 THEN '5-3-2'
        WHEN 6 THEN '4-1-4-1'
        ELSE '4-2-2-2'
    END,

    /* STADE */
    CASE n % 20
        WHEN 0 THEN 'Santiago Bernabeu'
        WHEN 1 THEN 'Camp Nou'
        WHEN 2 THEN 'Old Trafford'
        WHEN 3 THEN 'Etihad Stadium'
        WHEN 4 THEN 'Anfield'
        WHEN 5 THEN 'Emirates Stadium'
        WHEN 6 THEN 'Stamford Bridge'
        WHEN 7 THEN 'Allianz Arena'
        WHEN 8 THEN 'Signal Iduna Park'
        WHEN 9 THEN 'Parc des Princes'
        WHEN 10 THEN 'San Siro'
        WHEN 11 THEN 'Allianz Stadium'
        WHEN 12 THEN 'Stadio Olimpico'
        WHEN 13 THEN 'Johan Cruyff Arena'
        WHEN 14 THEN 'Estadio da Luz'
        WHEN 15 THEN 'Estadio do Dragao'
        WHEN 16 THEN 'Stade de Suisse'
        WHEN 17 THEN 'St. Jakob-Park'
        WHEN 18 THEN 'Letzigrund'
        ELSE 'Maracana'
    END,

    /* COMPETITION */
    'COMP' + RIGHT(
        '000' + CAST(
            ((n - 1) % 100) + 1
            AS VARCHAR(3)
        ),
        3
    )

FROM N;
GO


/* =========================================================
   VERIFICATION
   ========================================================= */

SELECT COUNT(*) AS Nombre_matchs
FROM match_;
GO


/* Afficher les 20 premiers matchs */

SELECT TOP (20)
    id_match,
    date_match,
    composition_match,
    Lieu,
    id_competition
FROM match_
ORDER BY date_match;
GO

/* =========================================================
   VERIFICATION GENERALE
   ========================================================= */

SELECT 'Equipe' AS TableName, COUNT(*) AS Nombre FROM Equipe
UNION ALL
SELECT 'competition', COUNT(*) FROM competition
UNION ALL
SELECT 'Joueurs', COUNT(*) FROM Joueurs
UNION ALL
SELECT 'qualifier', COUNT(*) FROM qualifier
UNION ALL
SELECT 'match_', COUNT(*) FROM match_;
GO