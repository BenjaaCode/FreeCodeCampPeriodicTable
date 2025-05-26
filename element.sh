#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_ELEMENT(){
  if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  else
    if [[ $1 =~ ^[0-9]+$ ]]; then
      CONDITION="atomic_number = $1"
    else
      CONDITION="symbol = '$1' OR name = '$1'"
    fi
    GET_ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION")
    if [[ -z $GET_ELEMENT ]]
    then
      echo 'I could not find that element in the database.'
    else
      IFS="|"
      echo "$GET_ELEMENT" | while read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
}

GET_ELEMENT "$1"
