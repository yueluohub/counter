#! /bin/bash
NUM=0
key_word="+define+"
CASE_FILE="merge.file"
INPUT_LIST=".list"
if [[ "$1"x == *${INPUT_LIST}x ]]; then 
while read LINE
do 
  if [[ $LINE == *${key_word}* ]]; then 
  TESTCASE=$LINE
  CASE_NUM='TESTCASE'$NUM
  NUM=$((NUM+1));
  RUN_SIM_CMD="./run_sim.sh $CASE_NUM $TESTCASE "
  #echo $TESTCASE
  if [[ $CASE_NUM == "TESTCASE0" ]]; then
  echo $CASE_NUM > $CASE_FILE
  else
  echo $CASE_NUM >> $CASE_FILE
  fi
  echo $RUN_SIM_CMD
  echo $RUN_SIM_CMD >> cmd.log
  #xterm -e  $RUN_SIM_CMD 
  xterm -e  $RUN_SIM_CMD & 
  fi
done < $1
elif [ "$1"x = "COV"x ] ; then 
imc -exec merge_cov.imc
imc -exec gen_cov_report.imc
else 
echo "please input *.list or COV"
fi
#echo "new start"
#FILENAME=$1
# for i in `cat $FILENAME`
# do 
# echo $i
# done


