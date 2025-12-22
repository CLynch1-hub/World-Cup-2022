# World-Cup-2022
A Data analysis of the 2022 World Cup using SQL Server, Python and Excel

World Cup 2022 — Player & Club Analysis
A full data analysis project exploring the FIFA World Cup 2022 squads using Python, Excel, and SQL Server. This project demonstrates a complete data pipeline: sourcing, cleaning, transforming, analysing, and visualising real world football data.
The analysis focuses on:
•	Player experience (caps)
•	Player age distribution
•	Goals per game
•	Club and league representation
•	Comparison of all players vs the last four teams
•	Insights into which clubs and leagues were most affected by the tournament

📁 Project Structure
world-cup-2022-analysis/
│
├── data/
│   ├── raw/
│   │   ├── Squads.csv
│   │   └── Outcome.csv
│
├── python/
│   ├── world_cup_analysis.ipynb
│
├── report/
│   └── CA2 Data Report & Dataset.pdf

└── README.md

Dataset Overview
Squads.csv
Contains all 830 players selected for the 2022 World Cup, including:
•	National team
•	Player number
•	Position
•	Date of birth
•	Age
•	Caps
•	Goals
•	Current club
•	Club league
•	Football association
Outcome.csv
Contains the final tournament outcome for each national team:
•	Winner
•	Runner Up
•	Third
•	Fourth
•	Quarter Finals
•	Last 16
•	Group Stages
🔧 Technologies Used
•	Python
o	Pandas
o	NumPy
o	Matplotlib
o	Seaborn
o	SciPy
•	Excel
o	Data Model
o	Pivot tables
o	Cleaning & transformation
•	SQL Server
o	Table design
o	Keys & relationships
o	Data validation
🧹 Data Cleaning Summary
Excel Cleaning
•	Removed images and formatting from Wikipedia tables
•	Created structured tables for:
o	Squads
o	Stadiums
o	Groups
o	Football associations
o	Club leagues
o	Clubs
o	Match reports
•	Added a unique Player_No primary key
•	Exported cleaned tables to CSV
Python Cleaning
•	Renamed columns using a dictionary
•	Converted date fields to datetime
•	Split national team names and codes
•	Dropped unnecessary fields
•	Applied custom cleaning functions
•	Created new engineered fields:
o	Experience
o	Age Range
o	Goals_Per_Game

Analysis Sections
1. Player Experience
Players were categorised based on caps:
•	Newcomer: < 20
•	Novice: 20–39
•	Regular: 40–79
•	Master: 80–100
•	Legend: 101+
Visualisations include:
•	Bar chart of experience categories
•	Scatterplot of age vs caps
•	Distribution curve of caps
•	Boxplot of caps by experience
2. Age Distribution
Players were grouped into age brackets:
•	Under 18
•	18–21
•	22–25
•	26–29
•	30–33
•	34–37
•	38–42
•	Over 42
Visualisations include:
•	Age range bar chart
•	Age distribution curve
•	Oldest player identification
3. Goals Per Game
A performance metric was created:
Goals_Per_Game = Goals / Caps
Only players with 20+ caps were included to avoid skewed ratios.
Output includes:
•	Top 10 players by goals per game
•	Their national teams
•	Their clubs
4. Last Four Teams Comparison
Merged Outcome.csv with the main dataset to analyse:
•	Winner
•	Runner Up
•	Third
•	Fourth
Comparison metrics:
•	Mean caps
•	Median caps
•	Mean age
•	Median age
This highlights differences between the full player pool (830 players) and the elite final four (104 players).
5. Club & League Impact
Grouped by:
•	Current club
•	Football league
•	Football association
Outputs include:
•	Top 20 clubs with the most World Cup players
•	Top 20 leagues
•	Mean, median, and standard deviation of club representation
🏁 Conclusion
This project provides a full analytical breakdown of the World Cup 2022 squads, combining:
•	Data engineering
•	Statistical analysis
•	Visualisation
•	Football domain knowledge
It demonstrates a complete end to end workflow suitable for data analytics portfolios, academic submissions, or football analytics enthusiasts.

