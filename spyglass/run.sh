#!/bin/bash
#URRENT_PATH = $(shell pwd)
GOALS_LINT="lint/lint_rtl,lint/lint_turbo_rtl,lint/lint_functional_rtl,adv_lint/adv_lint_struct,adv_lint/adv_lint_verify"
GOALS_CDC="cdc/cdc_setup_check,cdc/clock_reset_integrity,cdc/cdc_verify_struct,cdc/cdc_verify,cdc/cdc_abstract"
PROJECT_FILE="counter_top.prj"

#SPYGLASS_PATH="/inplay/app/synopsys/SpyGlass2016.06/SpyGlass-L2016.06/SPYGLASS_HOME/bin"
#SPYGLASS_LINT = " -batch -project ${PROJECT_FILE} -goals ${GOALS_LINT} -group "
#SPYGLASS_CDC  = " -batch -project ${PROJECT_FILE} -goals ${GOLAS_CDC}  -group "

#sg_shell  -project ${PROJECT_FILE} -projectwdir ./summary  -goals ${GOALS_LINT} -group
#spyglass -batch -project ${PROJECT_FILE}  -goals ${GOALS_LINT} -group
if [ "$1"x = "CDC"x ] ; then 
echo "CDC CHECK"
spyglass -batch -project ${PROJECT_FILE}  -goals ${GOALS_CDC} -group
cp -f counter_top/consolidated_reports/counter_top_Group_Run/moresimple.rpt .
elif [ "$1"x = "LINT"x ] ; then 
echo "LINT CHECK"
spyglass -shell -project ${PROJECT_FILE}  -goals ${GOALS_LINT} -group
cp -f counter_top/consolidated_reports/counter_top_Group_Run/moresimple.rpt .
elif [ "$1"x = "CLEAN"x ] ; then 
echo "dir clean"
rm -rf *.log counter_top/ spyglass*/ *.rpt *.out
else 
echo "please input"
fi

#spyglass -shell -tcl  counter_top.tcl

#sg_shell ${SPYGLASS_CDC}
