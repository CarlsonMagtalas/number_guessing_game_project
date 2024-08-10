#!/bin/bash
RANDOM_NUMBER=$((1 + $RANDOM % 1000))
PSQL="psql -X -U freecodecamp -d number_guess -t -c"

GAME_START(){
  COUNTER_NUM=0
  CORRECT='FALSE'
  echo "Guess the secret number between 1 and 1000:"
  while [ $CORRECT = 'FALSE' ]
  do
    read GUESS
    if [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      COUNTER_NUM=$((COUNTER_NUM + 1))

    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      COUNTER_NUM=$((COUNTER_NUM + 1))

    elif [[ $GUESS -eq $RANDOM_NUMBER ]]
    then
      echo "A match noice! With $COUNTER_NUM tries."
    fi
  done
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
      echo "Welcome, $USERNAME! It looks like this is your first time here."
    else
      echo "$USER_EXISTS" | while read GAMES BAR BEST BAR
      do
        echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
      done
    fi
    GAME_START
  fi
}

MAIN_MENU