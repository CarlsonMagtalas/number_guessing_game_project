#!/bin/bash
RANDOM_NUMBER=$((1 + $RANDOM % 1000))
PSQL="psql -X -U freecodecamp -d number_guess -t -c"

GAME_START(){
  NUMBER_OF_GUESSES=0
  CORRECT='FALSE'
  echo "Guess the secret number between 1 and 1000:"
  while [ $CORRECT = 'FALSE' ]
  do
    read GUESS
    if [[ ! $GUESS =~ ^-?[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"

    elif [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    elif [[ $GUESS -eq $RANDOM_NUMBER ]]
    then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
      INSERT_GAME_DATA=$($PSQL "UPDATE users set games_played = games_played + 1, best_game = CASE WHEN best_game > $NUMBER_OF_GUESSES THEN $NUMBER_OF_GUESSES ELSE best_game END
      WHERE username = '$USERNAME'")
      exit
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
      INSERT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, 1000)")
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