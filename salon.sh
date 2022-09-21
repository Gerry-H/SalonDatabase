#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
#PSQL ="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n ~~~ Mary's Salon ~~~ \n"

GET_SERVICE_INFO(){
#echo Get Info
echo -e "\nEnter Service Number"
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED == NULL ]]
then
  EXIT
else
  PROCESS_INPUTS
fi
}

PROCESS_INPUTS(){
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  #echo $SERVICE_NAME
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Enter a valid service number:"
  else
    # Get or Create Customer
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    # exists?
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new customer name
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      # add new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone)VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
   
    echo -e "\nWhat time would you like?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_RESULTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time)VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
    if [[ $INSERT_APPOINTMENT_RESULTS = 'INSERT 0 1' ]]
    then
      SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ //')
      CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/^ //')
      echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
    else
      echo -e "nThe insert failed!"
    fi
  # QUIT
    EXIT
  fi
}

EXIT(){
  echo -e "\nThank you for your patrionage"
}




MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Display Services

  SERVICES_LIST=$($PSQL "select service_id,name from services order by service_id")
  echo -e "\nList of services\n"
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME

  do
    echo "$SERVICE_ID) $NAME"
  done

  # get service id
  GET_SERVICE_INFO
 
}
  
  
MAIN_MENU



  




