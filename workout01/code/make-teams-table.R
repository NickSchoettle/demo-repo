# Title: Make Teams Table
# Description: This script is used to prepare data for workout01 and create a csv data file nba2018-teams.csv
# Inputs: NBA data for individual players
# Outputs: NBA data grouped by teams
library(dplyr)
library(readr)
nba2018 <- read_csv("/Users/Nick/desktop/hw-stat133-NickSchoettle/workout01/data/nba2018.csv")

nba2018$experience[nba2018$experience == "R"] <- 0

nba2018$experience <- as.numeric(nba2018$experience)

nba2018$salary <- nba2018$salary/1000000

nba2018$position <- factor(nba2018$position, labels = c("center", "power_fwd", "point_guard", "small_fwd", "shoot_guard"))

nba2018$missed_fg <- nba2018$field_goals_atts - nba2018$field_goals

nba2018$missed_ft <- nba2018$points1_atts - nba2018$points1

nba2018$rebounds <- nba2018$off_rebounds + nba2018$def_rebounds

nba2018$efficiency <- nba2018$points + nba2018$rebounds + nba2018$assists + nba2018$steals + nba2018$blocks - (nba2018$missed_fg - nba2018$missed_ft - nba2018$turnovers)/nba2018$games

setwd("/Users/Nick/desktop/hw-stat133-NickSchoettle/workout01/code")

sink("../output/efficiency-summary.txt")

print(summary(nba2018$efficiency))

sink()

teams <- nba2018[,c(3, 9, 11, 20, 23, 27, 30, 31, 33, 34, 35, 36, 37, 38, 42)]

teams <- summarise(group_by(teams, team), experience = sum(experience), salary = sum(salary), points3 = sum(points3), points2 = sum(points2), points1 = sum(points1), points = sum(points), off_rebounds = sum(off_rebounds), def_rebounds = sum(def_rebounds), assists = sum(assists), steals = sum(steals), blocks = sum(blocks), turnovers = sum(turnovers), fouls = sum(fouls), efficiency = sum(efficiency))

sink("../data/teams-summary.txt")

print(summary(teams))

sink()

write_csv(teams, "../data/nba2018-teams.csv")

