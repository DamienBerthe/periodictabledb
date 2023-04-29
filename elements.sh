#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo 'Please provide an element as an argument.'
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    VALID_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    SELECTION_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  else
    VALID_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    if [[ ! -z $VALID_ELEMENT ]]
    then
      SELECTION_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $VALID_ELEMENT")
    else
      VALID_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
      if [[ ! -z $VALID_ELEMENT ]]
      then
        SELECTION_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $VALID_ELEMENT")
      else
        echo 'I could not find that element in the database.'
      fi
    fi
  fi
  if [[ ! -z $VALID_ELEMENT ]]
  then
    SELECTION_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$VALID_ELEMENT'")
    SELECTION_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$VALID_ELEMENT'")
    SELECTION_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$VALID_ELEMENT'")
    SELECTION_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = '$SELECTION_TYPE_ID'")
    SELECTION_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$VALID_ELEMENT'")
    SELECTION_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$VALID_ELEMENT'")
    SELECTION_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$VALID_ELEMENT'")
    echo "The element with atomic number $VALID_ELEMENT is $SELECTION_NAME ($(echo $SELECTION_SYMBOL | sed -r 's/[[:blank:]]+/ /g')). It's a $SELECTION_TYPE, with a mass of $SELECTION_MASS amu. $SELECTION_NAME has a melting point of $SELECTION_MELT celsius and a boiling point of $SELECTION_BOIL celsius." | sed -r 's/[[:blank:]]+/ /g'
  fi
fi
#kek