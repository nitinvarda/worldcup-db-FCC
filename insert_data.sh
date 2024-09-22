#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
   if [[ $WINNER != 'winner' ]]
  then

    GETTING_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $GETTING_WINNER_ID ]]
    then
      ADDING_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $ADDING_WINNER_TEAM == "INSERT 0 1" ]]
      then
        GETTING_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo "Added successfully," $WINNER " with "  $GETTING_WINNER_ID
      fi
     fi
 
  fi
  if [[ $OPPONENT != 'opponent' ]]
  then

    GETTING_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $GETTING_OPPONENT_ID ]]
    then
      ADDING_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $ADDING_OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        GETTING_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo "Added successfully," $OPPONENT " with " $GETTING_OPPONENT_ID
      fi
     fi
 
  fi
  ADDING_DATA_TO_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$GETTING_WINNER_ID,$GETTING_OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  echo $ADDING_DATA_TO_GAMES

done