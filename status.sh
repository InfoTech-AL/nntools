#!/bin/bash
# Suggest using with this command: watch --color -n 60 ./status
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
printf "Notary Node Status\n"
printf "==================\n"

function process_check () {
  ps_out=`ps -ef | grep $1 | grep -v 'grep' | grep -v $0`
  result=$(echo $ps_out | grep "$1")
 if [[ "$result" != "" ]];then
    echo "here"
    return 1
  else
    echo "other"
    return 0
fi
}

UP="$(/usr/bin/uptime)"

echo "Server Uptime: $UP"
#TO DO
#ADD UPTIME CHECK
#ADD LOW BALANCE CHECK
#ADD LOW CPU USAGE CHECK

processlist=(
'iguana'
'komodod'
'bitcoind'
'chipsd'
'gamecreditsd'
'REVS'
'SUPERNET'
'DEX'
'PANGEA'
'JUMBLR'
'BET'
'CRYPTO'
'HODL'
'MSHARK'
'BOTS'
'MGW'
'COQUI'
'WLC'
'KV'
'CEAL'
'MESH'
'MNZ'
'AXO'
'BTCH'
'ETOMIC'
'NINJA'
'OOT'
'BNTN'
'CHAIN'
'PRLPAY'
'DSEC'
'GLXT'
'EQL'
'ZILLA'
'RFOX'
'VRSC'
)

count=0
while [ "x${processlist[count]}" != "x" ]
do
  echo -n "${processlist[count]}"
  #fixes formating issues
  size=${#processlist[count]}
  if [ "$size" -lt "8" ]
  then
    echo -n -e "\t\t"
  else
    echo -n -e "\t"
  fi
  if [ $(process_check $processlist[count]) ]
  then
    printf "Process: ${GREEN} Running ${NC}"
    if [ "$count" = "1" ]
    then
            cd ~/komodo/src
            RESULT="$(./komodo-cli -rpcclienttimeout=15 listunspent | grep .0001 | wc -l)"
            RESULT1="$(./komodo-cli -rpcclienttimeout=15  listunspent|grep amount|awk '{print $2}'|sed s/.$//|awk '$1 < 0.0001'|wc -l)"
            RESULT2="$(./komodo-cli -rpcclienttimeout=15 getbalance)"
    fi
    if [ "$count" = "2" ]
    then
            RESULT="$(bitcoin-cli -rpcclienttimeout=15 listunspent | grep .0001 | wc -l)"
            RESULT1="$(bitcoin-cli -rpcclienttimeout=15  listunspent|grep amount|awk '{print $2}'|sed s/.$//|awk '$1 < 0.0001'|wc -l)"
            RESULT2="$(bitcoin-cli -rpcclienttimeout=15 getbalance)"

    fi
    if [ "$count" = "3" ]
    then
            RESULT="$(chips-cli -rpcclienttimeout=15 listunspent | grep .0001 | wc -l)"
            RESULT1="$(chips-cli -rpcclienttimeout=15  listunspent|grep amount|awk '{print $2}'|sed s/.$//|awk '$1 < 0.0001'|wc -l)"
            RESULT2="$(chips-cli -rpcclienttimeout=15 getbalance)"

    fi
    if [ "$count" = "4" ]
    then
            RESULT="$(gamecredits-cli -rpcclienttimeout=15 listunspent | grep .001 | wc -l)"
            RESULT1="$(gamecredits-cli -rpcclienttimeout=15  listunspent|grep amount|awk '{print $2}'|sed s/.$//|awk '$1 < 0.001'|wc -l)"
            RESULT2="$(gamecredits-cli -rpcclienttimeout=15 getbalance)"

    fi
    if [ "$count" -gt "4" ]
    then
            cd ~/komodo/src
            RESULT="$(./komodo-cli -rpcclienttimeout=15 -ac_name=${processlist[count]} listunspent | grep .0001 | wc -l)"
            RESULT1="$(./komodo-cli -ac_name=${processlist[count]} -rpcclienttimeout=15  listunspent|grep amount|awk '{print $2}'|sed s/.$//|awk '$1 < 0.0001'|wc -l)"
            RESULT2="$(./komodo-cli -rpcclienttimeout=15 -ac_name=${processlist[count]} getbalance)"
    fi
# Check if we have actual results next two lines check for valid number.
    if [[ $RESULT == ?([-+])+([0-9])?(.*([0-9])) ]] ||
       [[ $RESULT == ?(?([-+])*([0-9])).+([0-9]) ]]
    then
    if [ "$RESULT" -lt "70" ]
    then
    printf  " - Avail UTXOs: ${RED}$RESULT\t${NC}"
    else
    printf  " - Avail UTXOs: ${GREEN}$RESULT\t${NC}"
    fi
    fi

 if [[ $RESULT1 == ?([-+])+([0-9])?(.*([0-9])) ]] ||
       [[ $RESULT1 == ?(?([-+])*([0-9])).+([0-9]) ]]
    then
    if [ "$RESULT1" -gt "70" ]
    then
    printf  " - Dust UTXOs: ${RED}$RESULT1\t${NC}"
    else
    printf  " - Dust UTXOs: ${GREEN}$RESULT1\t${NC}"
    fi
    fi


    if [[ $RESULT2 == ?([-+])+([0-9])?(.*([0-9])) ]] ||
       [[ $RESULT2 == ?(?([-+])*([0-9])).+([0-9]) ]]
    then
    if (( $(echo "$RESULT2 > 0.2" | bc -l) ));
    then
    printf  " - Avail Funds: ${GREEN}$RESULT2\t${NC}\n"
 #   printf "\t - Current Block: X\t - Longest Chain: X - Last Notarized: X\n"

    else
    printf  " - Avail Funds: ${RED}$RESULT2\t${NC}\n"
#    printf "\t - Current Block: X\t - Longest Chain: X - Last Notarized: X\n"

    fi
    else
      printf "\n"
    fi


    RESULT=""
    RESULT2=""

  else
    printf "Process: ${RED} Not Running ${NC}\n"
    echo "Not Running"
  fi
  count=$(( $count +1 ))
done
