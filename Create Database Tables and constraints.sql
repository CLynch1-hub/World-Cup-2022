------------------------------------------------------------
-- World_Cup_2022 – Full Database Schema & Data Load Script
------------------------------------------------------------

-- 1. Create database
------------------------------------------------------------
IF DB_ID('World_Cup_2022') IS NOT NULL
BEGIN
    ALTER DATABASE World_Cup_2022 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE World_Cup_2022;
END;
GO

CREATE DATABASE World_Cup_2022;
GO

USE World_Cup_2022;
GO


-- 2. Drop tables in dependency-safe order
------------------------------------------------------------
IF OBJECT_ID('dbo.MatchReport', 'U') IS NOT NULL DROP TABLE MatchReport;
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE Results;
IF OBJECT_ID('dbo.Squads', 'U') IS NOT NULL DROP TABLE Squads;
IF OBJECT_ID('dbo.Clubs', 'U') IS NOT NULL DROP TABLE Clubs;
IF OBJECT_ID('dbo.Leagues', 'U') IS NOT NULL DROP TABLE Leagues;
IF OBJECT_ID('dbo.Final_Outcome', 'U') IS NOT NULL DROP TABLE Final_Outcome;
IF OBJECT_ID('dbo.Football_Associations', 'U') IS NOT NULL DROP TABLE Football_Associations;
IF OBJECT_ID('dbo.FIFA_Region', 'U') IS NOT NULL DROP TABLE FIFA_Region;
IF OBJECT_ID('dbo.Stadiums', 'U') IS NOT NULL DROP TABLE Stadiums;
GO


-- 3. Create core reference tables
------------------------------------------------------------

-- FIFA_Region
CREATE TABLE FIFA_Region (
    Region VARCHAR(50) NOT NULL PRIMARY KEY,
    Area   VARCHAR(50) NOT NULL
);
GO

-- Football_Associations
CREATE TABLE Football_Associations (
    Nation_Code          CHAR(5)     NOT NULL PRIMARY KEY,
    Association          VARCHAR(50) NOT NULL,
    Region               VARCHAR(50) NOT NULL,
    Qualification_Status VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Football_Associations_Region
        FOREIGN KEY (Region) REFERENCES FIFA_Region(Region)
);
GO

-- Leagues (by club nationality)
CREATE TABLE Leagues (
    League      VARCHAR(50) NOT NULL PRIMARY KEY,
    Nation_Code CHAR(5)     NOT NULL,
    CONSTRAINT FK_Leagues_Nation
        FOREIGN KEY (Nation_Code) REFERENCES Football_Associations(Nation_Code)
);
GO

-- Stadiums
CREATE TABLE Stadiums (
    Stadium_No   INT         NOT NULL PRIMARY KEY,
    StadiumName  VARCHAR(100) NOT NULL,
    Capacity     INT         NOT NULL,
    City         VARCHAR(50) NOT NULL
);
GO

-- Clubs
CREATE TABLE Clubs (
    ClubID VARCHAR(8)    NOT NULL PRIMARY KEY,
    Club   NVARCHAR(50)  NOT NULL,
    League VARCHAR(50)   NOT NULL
);
GO

-- Squads
CREATE TABLE Squads (
    Nation_Code CHAR(5)    NOT NULL,
    PlayerNo    INT        NOT NULL PRIMARY KEY,
    SquadNo     INT        NOT NULL,
    Position    CHAR(10)   NOT NULL,
    PlayerName  VARCHAR(50) NOT NULL,
    Age         INT        NOT NULL,
    Caps        INT        NOT NULL,
    Goals       INT        NOT NULL,
    ClubID      VARCHAR(8) NOT NULL
);
GO

-- Results
CREATE TABLE Results (
    Match_Category VARCHAR(50) NOT NULL,
    Match_Round    VARCHAR(50) NOT NULL,
    Match_No       INT         NOT NULL PRIMARY KEY,
    MatchDate      DATE        NOT NULL,
    MatchTime      CHAR(10)    NOT NULL,
    HomeTeam       VARCHAR(50) NOT NULL,
    HomeScore      INT         NOT NULL,
    AwayScore      INT         NOT NULL,
    AwayTeam       VARCHAR(50) NOT NULL,
    StadiumName    VARCHAR(50) NOT NULL,
    Attendance     INT         NOT NULL,
    Total_Goals    SMALLINT    NOT NULL
);
GO

-- MatchReport
CREATE TABLE MatchReport (
    Report_No    INT        NOT NULL PRIMARY KEY,
    Match_No     INT        NOT NULL,
    Match_Action VARCHAR(50) NOT NULL,
    MinsOfAction INT        NOT NULL,
    PlayerNo     INT        NOT NULL
);
GO

-- Final_Outcome
CREATE TABLE Final_Outcome (
    Outcome_No  INT         NOT NULL PRIMARY KEY,
    Nation_Code CHAR(5)     NOT NULL,
    Outcome     VARCHAR(20) NOT NULL
);
GO


-- 4. Add foreign keys
------------------------------------------------------------

ALTER TABLE Clubs
ADD CONSTRAINT FK_Clubs_League FOREIGN KEY (League)
    REFERENCES Leagues(League);
GO

ALTER TABLE Squads
ADD CONSTRAINT FK_Squads_Club FOREIGN KEY (ClubID)
    REFERENCES Clubs(ClubID);
GO

ALTER TABLE Squads
ADD CONSTRAINT FK_Squads_FA FOREIGN KEY (Nation_Code)
    REFERENCES Football_Associations(Nation_Code);
GO

ALTER TABLE Final_Outcome
ADD CONSTRAINT FK_Final_Outcome_FA FOREIGN KEY (Nation_Code)
    REFERENCES Football_Associations(Nation_Code);
GO

ALTER TABLE MatchReport
ADD CONSTRAINT FK_MatchReport_Player FOREIGN KEY (PlayerNo)
    REFERENCES Squads(PlayerNo);
GO

ALTER TABLE MatchReport
ADD CONSTRAINT FK_MatchReport_Match FOREIGN KEY (Match_No)
    REFERENCES Results(Match_No);
GO