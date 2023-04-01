PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_DETAILS(){
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $1")
  ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
  ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
  ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
  echo "The element with atomic number $1 is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
}

EXISTS(){
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE $2 = '$1'")
  if [[ -z $ELEMENT_ID ]]
  then
    echo "I could not find that element in the database."
  else
    GET_DETAILS $ELEMENT_ID
  fi
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    EXISTS $1 "atomic_number"
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    EXISTS $1 "symbol"
  else
    EXISTS $1 "name"
  fi
else
  echo "Please provide an element as an argument."
fi
