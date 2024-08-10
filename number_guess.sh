#!/bin/bash
RANDOM_NUMBER=$((1 + $RANDOM % 1000))
PSQL="psql -X -U freecodecamp -d number_guess -t -c"

GAME_START(){
  if [[ $1 ]]
  then
    echo $1
  fi
}

MAIN_MENU(){
  echo "Enter your username:"
  read USERNAME
  #check if user exists
  if [[ $USERNAME ]]
  then
    USER_EXISTS=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")
    if [[ -z $USER_EXISTS ]]
    then
      INSERT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, 0)")
      GAME_START "Welcome, $USERNAME! It looks like this is your first time here."
    else
      echo "$USER_EXISTS" | while read GAMES BAR BEST BAR
      do
        GAME_START "Welcom back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
      done
    fi
  fi
}

MAIN_MENU