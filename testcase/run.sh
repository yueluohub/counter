#! /bin/bash
NUM=0
key_word="+define+"
while read LINE
do 
  if [[ $LINE == *${key_word}* ]]; then 
  TESTCASE=$LINE
  CASE_NUM='TESTCASE'$NUM
  NUM=$((NUM+1));
  RUN_SIM_CMD="./run_sim.sh $CASE_NUM $TESTCASE "
  #echo $TESTCASE
  #echo $CASE_NUM
  echo $RUN_SIM_CMD
  #xterm -e  $RUN_SIM_CMD 
  xterm -e  $RUN_SIM_CMD &
  fi
done < $1

#echo "new start"
#FILENAME=$1
# for i in `cat $FILENAME`
# do 
# echo $i
# done


