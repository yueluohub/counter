
set SPYGLASS_DESIGN "counter_top"


##Data Import Section                                                          
                                                                               
read_file -type sourcelist ../rtl/counter_filelist.f                                       
#read_file -type sgdc ./counter_top.sgdc                                                                               

##Common Options Section                                                       
                                                                               
#set_option projectwdir .                                                       
set_option language_mode mixed                                                 
#set_option designread_enable_synthesis no                                      
set_option designread_disable_flatten no                                       
set_option top $SPYGLASS_DESIGN                                                       
set_option incdir { ../rtl/ }      
set_option stop {intrctrl}
#set_option define {ST}
set_option sdc2sgdc yes
set_option sdc2sgdcfile ${SPYGLASS_DESIGN}_1.sgdc
set_option enableSV yes

set_option hdlin_translate_off_skip_text yes                                   
set_option hdlin_synthesis_off_skip_text yes                                   
#set_option active_methodology $SPYGLASS_HOME/GuideWare/latest/block/initial_rtl 
                                                                               
#current_design ${SPYGLASS_DESIGN}
#sdc_data -file ${SPYGLASS_DESIGN}.sdc
#set_parameter use_inferred_resets yes
#set_parameter use_inferred_clocks yes
                                                                               
##Goal Setup Section                                                           
                                                                               
current_methodology $SPYGLASS_HOME/GuideWare/latest/block/rtl_handoff          
                                                                               
                                                                               
current_methodology $SPYGLASS_HOME/GuideWare/latest/block/initial_rtl          
                                                                               
current_design ${SPYGLASS_DESIGN}
read_sdc_data  ${SPYGLASS_DESIGN}.sdc -top $SPYGLASS_DESIGN
set_parameter use_inferred_resets yes
set_parameter use_inferred_clocks yes
                                                                               
set_parameter use_inferred_clocks yes                                         
current_methodology $SPYGLASS_HOME/GuideWare/latest/soc/initial_rtl            
current_goal Group_Run -top $SPYGLASS_DESIGN  -goal { lint/lint_rtl }                 
set_goal_option addrules { W164c W164a }                                       
set_goal_option addrules { W163 }                                              
set_goal_option addrules { W164b }                                             
set_goal_option addrules { W162 }                                              
set_goal_option addrules { W159 }                                              
                                                                               
#current_goal Group_Run -top  $SPYGLASS_DESIGN -goal { lint/lint_rtl }                 

