#! /bin/bash
if [[ "$2"x == *'define'*x ]]; then
  current_path="`pwd`"
  CASE_NUM=$1
  TESTCASE=$2
  COV_WORK0=../cov_work
  COV_WORK=../cov_work/scope

  RUN_SIM_CMD="ncverilog \
		+incdir+${current_path}/../rtl/  \
		+incdir+${current_path}/  \
		-f ${current_path}/counter_filelist.f  \
		-f ${current_path}/counter_tb_filelist.f \
		-f ${current_path}/int_filelist.f \
		-sv -l sim.log \
		-top counter_top_tb_top \
		+access+rwc \
		+define+NC_SIM \
		-covfile ${current_path}/covfile.ccf -covtest $CASE_NUM -covoverwrite"
  #echo $current_path
  #echo $CASE_NUM
  #echo $TESTCASE
  if [ ! -d "$CASE_NUM" ]; then
  mkdir $CASE_NUM
  fi
  cd $CASE_NUM
  echo $current_path > cmd.log
  echo $CASE_NUM >> cmd.log
  echo $TESTCASE >> cmd.log
  echo $RUN_SIM_CMD $TESTCASE >> cmd.log
  if [[ $TESTCASE == *${key_word}* ]]; then
  xterm -e $RUN_SIM_CMD $TESTCASE 
  ${current_path}/make.sh sim.log
  if [ ! -d "$COV_WORK0" ]; then
  mkdir $COV_WORK0
  fi
  if [ ! -d "$COV_WORK" ]; then
  mkdir $COV_WORK
  fi
  cp -rf ./cov_work/scope/$CASE_NUM $COV_WORK/$CASE_NUM
  cp -f ./cov_work/scope/*.ucm $COV_WORK/
  fi
else 
  echo "please input case0 testcase"
fi
