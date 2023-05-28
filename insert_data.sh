#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Script to insert data from games.csv into worldcup database (games table and teams table)

echo $($PSQL "TRUNCATE TABLE games, teams")

# Goes through rows of .csv file one at a time
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR != year ]] # Checks to see if we are on the title row, if not proceeds with row
then
  # get team_id for winning team
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team name
      INSERT_WINNER_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

  # get team_id for opponent team
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team name
      INSERT_OPPONENT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

  # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # insert games data
      INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)") 
fi

done
