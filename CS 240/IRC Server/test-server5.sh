#/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: `basename $0` server-prog port"
  exit 1
fi

SERVER=$1
PORT=$2

echo "Start Test 5"

#echo Killing Server if any
PID=`ps | grep IRCServer | awk '{ print $1;}'`
kill -9 $PID 2> /dev/null
sleep 2

#Start server in the background
rm -f password.txt
rm -f userPass.txt
$SERVER $PORT > talk-server.out &
sleep 1

echo Add Users
./TestIRCServer localhost $PORT "ADD-USER superman clarkkent"
./TestIRCServer localhost $PORT "ADD-USER spiderman peterpark"
./TestIRCServer localhost $PORT "ADD-USER aquaman xyz"
./TestIRCServer localhost $PORT "ADD-USER mary poppins"

echo Create Room
./TestIRCServer localhost $PORT "CREATE-ROOM superman clarkkent java-programming"

echo Enter room
./TestIRCServer localhost $PORT "ENTER-ROOM superman clarkkent java-programming"
./TestIRCServer localhost $PORT "ENTER-ROOM aquaman xyz java-programming"

echo Print users in room
./TestIRCServer localhost $PORT "GET-USERS-IN-ROOM superman clarkkent java-programming"

echo Enter another user
./TestIRCServer localhost $PORT "ENTER-ROOM mary poppins java-programming"

echo Print users in room
./TestIRCServer localhost $PORT "GET-USERS-IN-ROOM mary poppins java-programming"

echo Send message
./TestIRCServer localhost $PORT "SEND-MESSAGE mary poppins java-programming Hi everybody!"
./TestIRCServer localhost $PORT "SEND-MESSAGE mary poppins java-programming Welcome to the talk program!"

echo Get messages
./TestIRCServer localhost $PORT "GET-MESSAGES superman clarkkent 0 java-programming"

# Kill server
echo Killing Server
PID=`ps | grep IRCServer | awk '{ print $1;}'`
kill -9 $PID
