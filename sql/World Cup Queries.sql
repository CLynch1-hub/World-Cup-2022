USE World_Cup_2022;

------------------------------------------------------------
-- SECTION 1: BASIC SELECTS (Verification)
------------------------------------------------------------
SELECT * FROM Football_Associations;
SELECT * FROM Clubs;
SELECT * FROM FIFA_Region;
SELECT * FROM Squads;
SELECT * FROM Results;
SELECT * FROM MatchReport;
SELECT * FROM Leagues;
SELECT * FROM Final_Outcome;

------------------------------------------------------------
-- SECTION 2: JOIN DEMONSTRATIONS (5.2)
------------------------------------------------------------

-- 2.1 INNER JOIN – Semi-Final Players
SELECT  s.Nation_Code,
        s.Position,
        s.PlayerName,
        s.Age,
        s.Caps,
        f.Outcome
FROM Squads AS s
INNER JOIN Final_Outcome AS f
    ON s.Nation_Code = f.Nation_Code
WHERE f.Outcome IN ('Winner', 'Runner Up', 'Third', 'Fourth');

-- 2.2 WHERE-based JOIN (Legacy Syntax)
SELECT  fa.Nation_Code,
        fa.Qualification_Status,
        fr.Area
FROM Football_Associations fa, FIFA_Region fr
WHERE fa.Region = fr.Region;

-- 2.3 WHERE-based JOIN with Aliases
SELECT  sq.PlayerName,
        sq.Age,
        sq.ClubID,
        cl.Club
FROM Squads sq, Clubs cl
WHERE sq.ClubID = cl.ClubID
  AND cl.Club = 'Barcelona';

------------------------------------------------------------
-- SECTION 3: INNER / LEFT / RIGHT JOINS (5.1 & 5.3)
------------------------------------------------------------

-- 3.1 INNER JOIN – Top 5 Goal Scorers
SELECT TOP 5
        s.PlayerName,
        s.Nation_Code,
        COUNT(*) AS Total_Goals
FROM MatchReport m
INNER JOIN Squads s
    ON m.PlayerNo = s.PlayerNo
WHERE m.Match_Action = 'Goal'
GROUP BY s.PlayerName, s.Nation_Code
ORDER BY Total_Goals DESC;

-- 3.2 RIGHT JOIN – All Squad Players + Match Actions
SELECT  s.PlayerName,
        s.Nation_Code,
        m.Match_Action
FROM MatchReport m
RIGHT JOIN Squads s
    ON s.PlayerNo = m.PlayerNo
ORDER BY s.Nation_Code;

-- 3.3 LEFT JOIN – All Associations + Outcome
SELECT  fa.Nation_Code,
        fa.Association,
        fa.Qualification_Status,
        fo.Outcome
FROM Football_Associations fa
LEFT JOIN Final_Outcome fo
    ON fa.Nation_Code = fo.Nation_Code;

------------------------------------------------------------
-- SECTION 4: AGGREGATE FUNCTIONS (6.1)
------------------------------------------------------------

-- 4.1 AVG – Average Age by FA
SELECT  Nation_Code,
        ROUND(AVG(Age), 1) AS Avg_Age
FROM Squads
GROUP BY Nation_Code
ORDER BY Avg_Age DESC;

-- 4.2 SUM – Total Goals in Tournament
SELECT SUM(Total_Goals) AS Total_Goals_Tournament
FROM Results;

-- 4.3 COUNT – Top 20 Assisters
SELECT TOP 20
        s.PlayerName,
        s.Nation_Code,
        COUNT(*) AS Total_Assists
FROM MatchReport m
INNER JOIN Squads s
    ON m.PlayerNo = s.PlayerNo
WHERE m.Match_Action = 'Assist'
GROUP BY s.PlayerName, s.Nation_Code
ORDER BY Total_Assists DESC;

------------------------------------------------------------
-- SECTION 5: GROUP BY & HAVING (6.2 & 6.3)
------------------------------------------------------------

-- 5.1 Leagues with Most Assigned Players
SELECT TOP 20
        c.League,
        l.Nation_Code,
        COUNT(*) AS Players_Assigned
FROM Squads s
INNER JOIN Clubs c ON s.ClubID = c.ClubID
INNER JOIN Leagues l ON l.League = c.League
GROUP BY c.League, l.Nation_Code
ORDER BY Players_Assigned DESC;

-- 5.2 Clubs with ≥10 Players at World Cup
SELECT TOP 20
        c.Club,
        c.League,
        COUNT(*) AS Assigned_Players
FROM Squads s
INNER JOIN Clubs c ON s.ClubID = c.ClubID
GROUP BY c.Club, c.League
HAVING COUNT(*) >= 10
ORDER BY Assigned_Players DESC;

------------------------------------------------------------
-- SECTION 6: SUBQUERY (EXISTS)
------------------------------------------------------------

-- Players for Spain who also play for Barcelona
SELECT  s.Nation_Code,
        s.PlayerName,
        s.Age,
        s.Caps,
        s.ClubID
FROM Squads s
WHERE EXISTS (
        SELECT 1
        FROM Clubs c
        WHERE c.Club = 'Barcelona'
          AND c.ClubID = s.ClubID
      )
  AND s.Nation_Code = 'ESP';

------------------------------------------------------------
-- SECTION 7: PIVOT
------------------------------------------------------------

-- Average Age per Position
SELECT  [GK], [DF], [MF], [FW]
FROM (
        SELECT Position, Age
        FROM Squads
     ) AS src
PIVOT (
        AVG(Age)
        FOR Position IN ([GK], [DF], [MF], [FW])
     ) AS pvt;

------------------------------------------------------------
-- SECTION 8: WINDOW FUNCTIONS
------------------------------------------------------------

-- Max Attendance per Stadium
SELECT  Match_Round,
        Match_Category,
        MatchDate,
        HomeTeam,
        AwayTeam,
        StadiumName,
        Attendance,
        MAX(Attendance) OVER (PARTITION BY StadiumName) AS Max_Attendance_Stadium
FROM Results;

------------------------------------------------------------
-- SECTION 9: VIEW + UNION
------------------------------------------------------------

-- 9.1 View: Winning Team Info
CREATE OR ALTER VIEW vw_WinningTeam AS
SELECT  fa.Nation_Code,
        fa.Association
FROM Football_Associations fa
INNER JOIN Final_Outcome fo
    ON fa.Nation_Code = fo.Nation_Code
WHERE fo.Outcome = 'Winner';

-- 9.2 All Matches Played by the Winning Team
SELECT  r.MatchDate,
        r.HomeTeam,
        r.HomeScore,
        r.AwayScore,
        r.AwayTeam,
        r.StadiumName,
        r.Attendance,
        w.Nation_Code
FROM Results r
INNER JOIN vw_WinningTeam w
    ON r.HomeTeam = w.Association

UNION

SELECT  r.MatchDate,
        r.HomeTeam,
        r.HomeScore,
        r.AwayScore,
        r.AwayTeam,
        r.StadiumName,
        r.Attendance,
        w.Nation_Code
FROM Results r
INNER JOIN vw_WinningTeam w
    ON r.AwayTeam = w.Association;

------------------------------------------------------------
-- SECTION 10: STORED PROCEDURE (7.5)
------------------------------------------------------------

CREATE OR ALTER PROCEDURE spNation @Nation VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Football_Associations WHERE Association = @Nation)
    BEGIN
        SELECT  fa.Nation_Code,
                fa.Association,
                fa.Qualification_Status,
                fo.Outcome
        FROM Football_Associations fa
        LEFT JOIN Final_Outcome fo
            ON fa.Nation_Code = fo.Nation_Code
        WHERE fa.Association = @Nation;
    END
    ELSE
        PRINT 'Unfortunately, the Association was not involved in the World Cup 2022 process.';
END;

-- Test
EXEC spNation @Nation = 'Croatia';
