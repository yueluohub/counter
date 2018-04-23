// type declaration
#ifndef __REG_CONST_T
#define __REG_CONST_T

#ifndef REG_CONST_NAME_STRING_MAX_LEN   
#define REG_CONST_NAME_STRING_MAX_LEN 32
#endif // REG_CONST_NAME_STRING_MAX_LEN
#ifndef REG_CONST_DESC_STRING_MAX_LEN
#define REG_CONST_DESC_STRING_MAX_LEN 512
#endif // REG_CONST_DESC_STRING_MAX_LEN
typedef struct {
	char name[REG_CONST_NAME_STRING_MAX_LEN];
	DWORD address;
	DWORD def;
	char desc[REG_CONST_DESC_STRING_MAX_LEN];
} reg_const_t;
typedef struct {
	char name[REG_CONST_NAME_STRING_MAX_LEN];
	char range[32];
	char def[32];
	char access[32];
	char desc[REG_CONST_DESC_STRING_MAX_LEN];
} field_const_t;
typedef struct {
	field_const_t *pfield;
	DWORD size;
} field_const_array_t;
#endif // __REG_CONST_T

#define NUM_REGS__COUNTER_ALL_APB_REG  151
/* { reg_const_counter_all_apb_reg, 151, "counter_all_apb_reg"},  */ 
static reg_const_t reg_const_counter_all_apb_reg[NUM_REGS__COUNTER_ALL_APB_REG] = {
  {/* name */ "intr_status", /* address */ 0x44108000, /* default */ 0x00000000, /* description */ "Interrupt status register bits. \n"}, 
  {/* name */ "intr_mask_status", /* address */ 0x44108004, /* default */ 0x00000001, /* description */ "Interrupt mask status register\n"}, 
  {/* name */ "intr_clr", /* address */ 0x44108008, /* default */ 0x00000000, /* description */ "Clear interrupt status\n"}, 
  {/* name */ "intr_set", /* address */ 0x4410800c, /* default */ 0x00000000, /* description */ "Set interrupt status\n"}, 
  {/* name */ "intr_mask_set", /* address */ 0x44108010, /* default */ 0x00000000, /* description */ "Set interrupt mask\n"}, 
  {/* name */ "intr_mask_clr", /* address */ 0x44108014, /* default */ 0x00000000, /* description */ "Set interrupt mask\n"}, 
  {/* name */ "intr_sreset", /* address */ 0x44108018, /* default */ 0x00000000, /* description */ "interrupt softward reset\n"}, 
  {/* name */ "global_start_trigger", /* address */ 0x44108040, /* default */ 0x00000000, /* description */ "global trigger register bits. \n"}, 
  {/* name */ "global_stop_trigger", /* address */ 0x44108044, /* default */ 0x00000000, /* description */ "global trigger register bits. \n"}, 
  {/* name */ "global_clear_trigger", /* address */ 0x44108048, /* default */ 0x00000000, /* description */ "global trigger register bits. \n"}, 
  {/* name */ "global_reset_trigger", /* address */ 0x4410804c, /* default */ 0x00000000, /* description */ "global trigger register bits. \n"}, 
  {/* name */ "single_start_trigger_c0", /* address */ 0x44108080, /* default */ 0x00000000, /* description */ "counter 0 single trigger register bits. \n"}, 
  {/* name */ "single_stop_trigger_c0", /* address */ 0x44108084, /* default */ 0x00000000, /* description */ "counter 0 single trigger register bits. \n"}, 
  {/* name */ "single_clear_trigger_c0", /* address */ 0x44108088, /* default */ 0x00000000, /* description */ "counter 0 single trigger register bits. \n"}, 
  {/* name */ "single_reset_trigger_c0", /* address */ 0x4410808c, /* default */ 0x00000000, /* description */ "counter 0 single trigger register bits. \n"}, 
  {/* name */ "enable_c0", /* address */ 0x44108090, /* default */ 0x00000000, /* description */ "counter 0 enable_c0 signal. \n"}, 
  {/* name */ "soft_trigger_ctrl_c0", /* address */ 0x44108094, /* default */ 0x00000000, /* description */ "control the function of single/global_trigger. \n"}, 
  {/* name */ "mux_sel_c0", /* address */ 0x44108098, /* default */ 0x00000000, /* description */ "select counter 0 inner input data from other counters. \n"}, 
  {/* name */ "src_sel_edge_c0", /* address */ 0x441080a0, /* default */ 0x00000000, /* description */ "select the valid input and edge for start/stop/din0/din1. \n"}, 
  {/* name */ "ctrl_snap_c0", /* address */ 0x441080a4, /* default */ 0x00000000, /* description */ "snap the status or data from counter 0. \n"}, 
  {/* name */ "shadow_reg_c0", /* address */ 0x441080a8, /* default */ 0x00000000, /* description */ "snap the current value from counter. \n"}, 
  {/* name */ "mode_sel_c0", /* address */ 0x441080ac, /* default */ 0x00000000, /* description */ "working mode select for counter 0. \n"}, 
  {/* name */ "target_reg_ctrl_c0", /* address */ 0x441080b0, /* default */ 0x00000000, /* description */ "waveform mode control from counter 0. \n"}, 
  {/* name */ "target_reg_a0_c0", /* address */ 0x441080b4, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 0. \n"}, 
  {/* name */ "target_reg_a1_c0", /* address */ 0x441080b8, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 0. \n"}, 
  {/* name */ "target_reg_a2_c0", /* address */ 0x441080bc, /* default */ 0x00000000, /* description */ "waveform mode , target register a2, for counter 0. \n"}, 
  {/* name */ "target_reg_b0_c0", /* address */ 0x441080c0, /* default */ 0x00000000, /* description */ "waveform mode , target register b0, for counter 0. \n"}, 
  {/* name */ "target_reg_b1_c0", /* address */ 0x441080c4, /* default */ 0x00000000, /* description */ "waveform mode , target register b1, for counter 0. \n"}, 
  {/* name */ "target_reg_b2_c0", /* address */ 0x441080c8, /* default */ 0x00000000, /* description */ "waveform mode , target register b2, for counter 0. \n"}, 
  {/* name */ "capture_reg_status_c0", /* address */ 0x441080cc, /* default */ 0x00000000, /* description */ "capture mode , snap the status from counter 0. \n"}, 
  {/* name */ "capture_reg_overflow_ctrl_c0", /* address */ 0x441080d0, /* default */ 0x00000000, /* description */ "capture mode , when overflow ,discard or rewrite. \n"}, 
  {/* name */ "capture_reg_a0_c0", /* address */ 0x441080d8, /* default */ 0x00000000, /* description */ "capture mode, capture register a0 for counter 0. \n"}, 
  {/* name */ "capture_reg_a1_c0", /* address */ 0x441080dc, /* default */ 0x00000000, /* description */ "capture mode, capture register a1 for counter 0. \n"}, 
  {/* name */ "capture_reg_a2_c0", /* address */ 0x441080e0, /* default */ 0x00000000, /* description */ "capture mode, capture register a2 for counter 0. \n"}, 
  {/* name */ "capture_reg_b0_c0", /* address */ 0x441080e4, /* default */ 0x00000000, /* description */ "capture mode, capture register b0 for counter 0. \n"}, 
  {/* name */ "capture_reg_b1_c0", /* address */ 0x441080e8, /* default */ 0x00000000, /* description */ "capture mode, capture register b1 for counter 0. \n"}, 
  {/* name */ "capture_reg_b2_c0", /* address */ 0x441080ec, /* default */ 0x00000000, /* description */ "capture mode, capture register b2 for counter 0. \n"}, 
  {/* name */ "switch_mode_onebit_cnts_c0", /* address */ 0x441080f0, /* default */ 0x00000000, /* description */ "waveform and capture switch mode, one bit data means counter value. for counter 0.\n"}, 
  {/* name */ "waveform_mode_automatic_c0", /* address */ 0x441080f4, /* default */ 0x00000000, /* description */ "automatic waveform and capture switch mode,for counter 0. \n"}, 
  {/* name */ "shiftmode_ctrl_c0", /* address */ 0x441080f8, /* default */ 0x00000000, /* description */ "select bus_a or bus_b in shiftin/shiftout mode. \n"}, 
  {/* name */ "shiftout_data_ctrl_bitcnts_c0", /* address */ 0x441080fc, /* default */ 0x00000000, /* description */ "how man bits to shift out data from counter 0. \n"}, 
  {/* name */ "shiftout_data_c0", /* address */ 0x44108100, /* default */ 0x00000000, /* description */ "shift out data from counter 0. \n"}, 
  {/* name */ "shiftout_data_valid_c0", /* address */ 0x44108104, /* default */ 0x00000000, /* description */ "a new shift_out data flag for counter 0. \n"}, 
  {/* name */ "shiftin_data_ctrl_bitcnts_c0", /* address */ 0x44108108, /* default */ 0x00000000, /* description */ "how man bits of shift_in data for counter 0. . \n"}, 
  {/* name */ "shiftin_data_c0", /* address */ 0x4410810c, /* default */ 0x00000000, /* description */ "shift_in data for counter 0. \n"}, 
  {/* name */ "shiftin_databits_updated_c0", /* address */ 0x44108110, /* default */ 0x00000000, /* description */ "shift_in data(bitmap is updated) for counter 0. \n"}, 
  {/* name */ "single_start_trigger_c1", /* address */ 0x44108180, /* default */ 0x00000000, /* description */ "counter 1 single trigger register bits. \n"}, 
  {/* name */ "single_stop_trigger_c1", /* address */ 0x44108184, /* default */ 0x00000000, /* description */ "counter 1 single trigger register bits. \n"}, 
  {/* name */ "single_clear_trigger_c1", /* address */ 0x44108188, /* default */ 0x00000000, /* description */ "counter 1 single trigger register bits. \n"}, 
  {/* name */ "single_reset_trigger_c1", /* address */ 0x4410818c, /* default */ 0x00000000, /* description */ "counter 1 single trigger register bits. \n"}, 
  {/* name */ "enable_c1", /* address */ 0x44108190, /* default */ 0x00000000, /* description */ "counter 1 enable_c1 signal. \n"}, 
  {/* name */ "soft_trigger_ctrl_c1", /* address */ 0x44108194, /* default */ 0x00000000, /* description */ "control the function of single/global_trigger. \n"}, 
  {/* name */ "mux_sel_c1", /* address */ 0x44108198, /* default */ 0x00000000, /* description */ "select count 1 inner input data from other counters. \n"}, 
  {/* name */ "src_sel_edge_c1", /* address */ 0x441081a0, /* default */ 0x00000000, /* description */ "select the  valid input and edge for start/stop/din0/din1. \n"}, 
  {/* name */ "ctrl_snap_c1", /* address */ 0x441081a4, /* default */ 0x00000000, /* description */ "snap the status or data from counter 1. \n"}, 
  {/* name */ "shadow_reg_c1", /* address */ 0x441081a8, /* default */ 0x00000000, /* description */ "snap the current value from counter. \n"}, 
  {/* name */ "mode_sel_c1", /* address */ 0x441081ac, /* default */ 0x00000000, /* description */ "working mode select for counter 1. \n"}, 
  {/* name */ "target_reg_ctrl_c1", /* address */ 0x441081b0, /* default */ 0x00000000, /* description */ "waveform mode control from counter 1. \n"}, 
  {/* name */ "target_reg_a0_c1", /* address */ 0x441081b4, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 1. \n"}, 
  {/* name */ "target_reg_a1_c1", /* address */ 0x441081b8, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 1. \n"}, 
  {/* name */ "target_reg_a2_c1", /* address */ 0x441081bc, /* default */ 0x00000000, /* description */ "waveform mode , target register a2, for counter 1. \n"}, 
  {/* name */ "target_reg_b0_c1", /* address */ 0x441081c0, /* default */ 0x00000000, /* description */ "waveform mode , target register b0, for counter 1. \n"}, 
  {/* name */ "target_reg_b1_c1", /* address */ 0x441081c4, /* default */ 0x00000000, /* description */ "waveform mode , target register b1, for counter 1. \n"}, 
  {/* name */ "target_reg_b2_c1", /* address */ 0x441081c8, /* default */ 0x00000000, /* description */ "waveform mode , target register b2, for counter 1. \n"}, 
  {/* name */ "capture_reg_status_c1", /* address */ 0x441081cc, /* default */ 0x00000000, /* description */ "capture mode , snap the status from counter 1. \n"}, 
  {/* name */ "capture_reg_overflow_ctrl_c1", /* address */ 0x441081d0, /* default */ 0x00000000, /* description */ "capture mode , when overflow ,discard or rewrite. \n"}, 
  {/* name */ "capture_reg_a0_c1", /* address */ 0x441081d8, /* default */ 0x00000000, /* description */ "capture mode, capture register a0 for counter 1. \n"}, 
  {/* name */ "capture_reg_a1_c1", /* address */ 0x441081dc, /* default */ 0x00000000, /* description */ "capture mode, capture register a1 for counter 1. \n"}, 
  {/* name */ "capture_reg_a2_c1", /* address */ 0x441081e0, /* default */ 0x00000000, /* description */ "capture mode, capture register a2 for counter 1. \n"}, 
  {/* name */ "capture_reg_b0_c1", /* address */ 0x441081e4, /* default */ 0x00000000, /* description */ "capture mode, capture register b0 for counter 1. \n"}, 
  {/* name */ "capture_reg_b1_c1", /* address */ 0x441081e8, /* default */ 0x00000000, /* description */ "capture mode, capture register b1 for counter 1. \n"}, 
  {/* name */ "capture_reg_b2_c1", /* address */ 0x441081ec, /* default */ 0x00000000, /* description */ "capture mode, capture register b2 for counter 1. \n"}, 
  {/* name */ "switch_mode_onebit_cnts_c1", /* address */ 0x441081f0, /* default */ 0x00000000, /* description */ "waveform and capture switch mode, one bit data means counter value. for counter 1.\n"}, 
  {/* name */ "waveform_mode_automatic_c1", /* address */ 0x441081f4, /* default */ 0x00000000, /* description */ "automatic waveform and capture switch mode,for counter 1. \n"}, 
  {/* name */ "shiftmode_ctrl_c1", /* address */ 0x441081f8, /* default */ 0x00000000, /* description */ "select bus_a or bus_b in shiftin/shiftout mode. \n"}, 
  {/* name */ "shiftout_data_ctrl_bitcnts_c1", /* address */ 0x441081fc, /* default */ 0x00000000, /* description */ "how man bits to shift out data from counter 1. \n"}, 
  {/* name */ "shiftout_data_c1", /* address */ 0x44108200, /* default */ 0x00000000, /* description */ "shift out data from counter 1. \n"}, 
  {/* name */ "shiftout_data_valid_c1", /* address */ 0x44108204, /* default */ 0x00000000, /* description */ "a new shift_out data flag for counter 1. \n"}, 
  {/* name */ "shiftin_data_ctrl_bitcnts_c1", /* address */ 0x44108208, /* default */ 0x00000000, /* description */ "how man bits of shift_in data for counter 1. . \n"}, 
  {/* name */ "shiftin_data_c1", /* address */ 0x4410820c, /* default */ 0x00000000, /* description */ "shift_in data for counter 1. \n"}, 
  {/* name */ "shiftin_databits_updated_c1", /* address */ 0x44108210, /* default */ 0x00000000, /* description */ "shift_in data(bitmap is updated) for counter 1. \n"}, 
  {/* name */ "single_start_trigger_c2", /* address */ 0x44108280, /* default */ 0x00000000, /* description */ "counter 2 single trigger register bits. \n"}, 
  {/* name */ "single_stop_trigger_c2", /* address */ 0x44108284, /* default */ 0x00000000, /* description */ "counter 2 single trigger register bits. \n"}, 
  {/* name */ "single_clear_trigger_c2", /* address */ 0x44108288, /* default */ 0x00000000, /* description */ "counter 2 single trigger register bits. \n"}, 
  {/* name */ "single_reset_trigger_c2", /* address */ 0x4410828c, /* default */ 0x00000000, /* description */ "counter 2 single trigger register bits. \n"}, 
  {/* name */ "enable_c2", /* address */ 0x44108290, /* default */ 0x00000000, /* description */ "counter 2 enable_c2 signal. \n"}, 
  {/* name */ "soft_trigger_ctrl_c2", /* address */ 0x44108294, /* default */ 0x00000000, /* description */ "control the function of single/global_trigger. \n"}, 
  {/* name */ "mux_sel_c2", /* address */ 0x44108298, /* default */ 0x00000000, /* description */ "select count 2 inner input data from other counters. \n"}, 
  {/* name */ "src_sel_edge_c2", /* address */ 0x441082a0, /* default */ 0x00000000, /* description */ "select the  valid input and edge for start/stop/din0/din1. \n"}, 
  {/* name */ "ctrl_snap_c2", /* address */ 0x441082a4, /* default */ 0x00000000, /* description */ "snap the status or data from counter 2. \n"}, 
  {/* name */ "shadow_reg_c2", /* address */ 0x441082a8, /* default */ 0x00000000, /* description */ "snap the current value from counter. \n"}, 
  {/* name */ "mode_sel_c2", /* address */ 0x441082ac, /* default */ 0x00000000, /* description */ "working mode select for counter 2. \n"}, 
  {/* name */ "target_reg_ctrl_c2", /* address */ 0x441082b0, /* default */ 0x00000000, /* description */ "waveform mode control from counter 2. \n"}, 
  {/* name */ "target_reg_a0_c2", /* address */ 0x441082b4, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 2. \n"}, 
  {/* name */ "target_reg_a1_c2", /* address */ 0x441082b8, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 2. \n"}, 
  {/* name */ "target_reg_a2_c2", /* address */ 0x441082bc, /* default */ 0x00000000, /* description */ "waveform mode , target register a2, for counter 2. \n"}, 
  {/* name */ "target_reg_b0_c2", /* address */ 0x441082c0, /* default */ 0x00000000, /* description */ "waveform mode , target register b0, for counter 2. \n"}, 
  {/* name */ "target_reg_b1_c2", /* address */ 0x441082c4, /* default */ 0x00000000, /* description */ "waveform mode , target register b1, for counter 2. \n"}, 
  {/* name */ "target_reg_b2_c2", /* address */ 0x441082c8, /* default */ 0x00000000, /* description */ "waveform mode , target register b2, for counter 2. \n"}, 
  {/* name */ "capture_reg_status_c2", /* address */ 0x441082cc, /* default */ 0x00000000, /* description */ "capture mode , snap the status from counter 2. \n"}, 
  {/* name */ "capture_reg_overflow_ctrl_c2", /* address */ 0x441082d0, /* default */ 0x00000000, /* description */ "capture mode , when overflow ,discard or rewrite. \n"}, 
  {/* name */ "capture_reg_a0_c2", /* address */ 0x441082d8, /* default */ 0x00000000, /* description */ "capture mode, capture register a0 for counter 2. \n"}, 
  {/* name */ "capture_reg_a1_c2", /* address */ 0x441082dc, /* default */ 0x00000000, /* description */ "capture mode, capture register a1 for counter 2. \n"}, 
  {/* name */ "capture_reg_a2_c2", /* address */ 0x441082e0, /* default */ 0x00000000, /* description */ "capture mode, capture register a2 for counter 2. \n"}, 
  {/* name */ "capture_reg_b0_c2", /* address */ 0x441082e4, /* default */ 0x00000000, /* description */ "capture mode, capture register b0 for counter 2. \n"}, 
  {/* name */ "capture_reg_b1_c2", /* address */ 0x441082e8, /* default */ 0x00000000, /* description */ "capture mode, capture register b1 for counter 2. \n"}, 
  {/* name */ "capture_reg_b2_c2", /* address */ 0x441082ec, /* default */ 0x00000000, /* description */ "capture mode, capture register b2 for counter 2. \n"}, 
  {/* name */ "switch_mode_onebit_cnts_c2", /* address */ 0x441082f0, /* default */ 0x00000000, /* description */ "waveform and capture switch mode, one bit data means counter value. for counter 2.\n"}, 
  {/* name */ "waveform_mode_automatic_c2", /* address */ 0x441082f4, /* default */ 0x00000000, /* description */ "automatic waveform and capture switch mode,for counter 2. \n"}, 
  {/* name */ "shiftmode_ctrl_c2", /* address */ 0x441082f8, /* default */ 0x00000000, /* description */ "select bus_a or bus_b in shiftin/shiftout mode. \n"}, 
  {/* name */ "shiftout_data_ctrl_bitcnts_c2", /* address */ 0x441082fc, /* default */ 0x00000000, /* description */ "how man bits to shift out data from counter 2. \n"}, 
  {/* name */ "shiftout_data_c2", /* address */ 0x44108300, /* default */ 0x00000000, /* description */ "shift out data from counter 2. \n"}, 
  {/* name */ "shiftout_data_valid_c2", /* address */ 0x44108304, /* default */ 0x00000000, /* description */ "a new shift_out data flag for counter 2. \n"}, 
  {/* name */ "shiftin_data_ctrl_bitcnts_c2", /* address */ 0x44108308, /* default */ 0x00000000, /* description */ "how man bits of shift_in data for counter 2. . \n"}, 
  {/* name */ "shiftin_data_c2", /* address */ 0x4410830c, /* default */ 0x00000000, /* description */ "shift_in data for counter 2. \n"}, 
  {/* name */ "shiftin_databits_updated_c2", /* address */ 0x44108310, /* default */ 0x00000000, /* description */ "shift_in data(bitmap is updated) for counter 2. \n"}, 
  {/* name */ "single_start_trigger_c3", /* address */ 0x44108380, /* default */ 0x00000000, /* description */ "counter 3 single trigger register bits. \n"}, 
  {/* name */ "single_stop_trigger_c3", /* address */ 0x44108384, /* default */ 0x00000000, /* description */ "counter 3 single trigger register bits. \n"}, 
  {/* name */ "single_clear_trigger_c3", /* address */ 0x44108388, /* default */ 0x00000000, /* description */ "counter 3 single trigger register bits. \n"}, 
  {/* name */ "single_reset_trigger_c3", /* address */ 0x4410838c, /* default */ 0x00000000, /* description */ "counter 3 single trigger register bits. \n"}, 
  {/* name */ "enable_c3", /* address */ 0x44108390, /* default */ 0x00000000, /* description */ "counter 3 enable_c3 signal. \n"}, 
  {/* name */ "soft_trigger_ctrl_c3", /* address */ 0x44108394, /* default */ 0x00000000, /* description */ "control the function of single/global_trigger. \n"}, 
  {/* name */ "mux_sel_c3", /* address */ 0x44108398, /* default */ 0x00000000, /* description */ "select counter 3 inner input data from other counters. \n"}, 
  {/* name */ "src_sel_edge_c3", /* address */ 0x441083a0, /* default */ 0x00000000, /* description */ "select the  valid input and edge for start/stop/din0/din1. \n"}, 
  {/* name */ "ctrl_snap_c3", /* address */ 0x441083a4, /* default */ 0x00000000, /* description */ "snap the status or data from counter 3. \n"}, 
  {/* name */ "shadow_reg_c3", /* address */ 0x441083a8, /* default */ 0x00000000, /* description */ "snap the current value from counter. \n"}, 
  {/* name */ "mode_sel_c3", /* address */ 0x441083ac, /* default */ 0x00000000, /* description */ "working mode select for counter 3. \n"}, 
  {/* name */ "target_reg_ctrl_c3", /* address */ 0x441083b0, /* default */ 0x00000000, /* description */ "waveform mode control from counter 3. \n"}, 
  {/* name */ "target_reg_a0_c3", /* address */ 0x441083b4, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 3. \n"}, 
  {/* name */ "target_reg_a1_c3", /* address */ 0x441083b8, /* default */ 0x00000000, /* description */ "waveform mode , target register a0, for counter 3. \n"}, 
  {/* name */ "target_reg_a2_c3", /* address */ 0x441083bc, /* default */ 0x00000000, /* description */ "waveform mode , target register a2, for counter 3. \n"}, 
  {/* name */ "target_reg_b0_c3", /* address */ 0x441083c0, /* default */ 0x00000000, /* description */ "waveform mode , target register b0, for counter 3. \n"}, 
  {/* name */ "target_reg_b1_c3", /* address */ 0x441083c4, /* default */ 0x00000000, /* description */ "waveform mode , target register b1, for counter 3. \n"}, 
  {/* name */ "target_reg_b2_c3", /* address */ 0x441083c8, /* default */ 0x00000000, /* description */ "waveform mode , target register b2, for counter 3. \n"}, 
  {/* name */ "capture_reg_status_c3", /* address */ 0x441083cc, /* default */ 0x00000000, /* description */ "capture mode , snap the status from counter 3. \n"}, 
  {/* name */ "capture_reg_overflow_ctrl_c3", /* address */ 0x441083d0, /* default */ 0x00000000, /* description */ "capture mode , when overflow ,discard or rewrite. \n"}, 
  {/* name */ "capture_reg_a0_c3", /* address */ 0x441083d8, /* default */ 0x00000000, /* description */ "capture mode, capture register a0 for counter 3. \n"}, 
  {/* name */ "capture_reg_a1_c3", /* address */ 0x441083dc, /* default */ 0x00000000, /* description */ "capture mode, capture register a1 for counter 3. \n"}, 
  {/* name */ "capture_reg_a2_c3", /* address */ 0x441083e0, /* default */ 0x00000000, /* description */ "capture mode, capture register a2 for counter 3. \n"}, 
  {/* name */ "capture_reg_b0_c3", /* address */ 0x441083e4, /* default */ 0x00000000, /* description */ "capture mode, capture register b0 for counter 3. \n"}, 
  {/* name */ "capture_reg_b1_c3", /* address */ 0x441083e8, /* default */ 0x00000000, /* description */ "capture mode, capture register b1 for counter 3. \n"}, 
  {/* name */ "capture_reg_b2_c3", /* address */ 0x441083ec, /* default */ 0x00000000, /* description */ "capture mode, capture register b2 for counter 3. \n"}, 
  {/* name */ "switch_mode_onebit_cnts_c3", /* address */ 0x441083f0, /* default */ 0x00000000, /* description */ "waveform and capture switch mode, one bit data means counter value. for counter 3.\n"}, 
  {/* name */ "waveform_mode_automatic_c3", /* address */ 0x441083f4, /* default */ 0x00000000, /* description */ "automatic waveform and capture switch mode,for counter 3. \n"}, 
  {/* name */ "shiftmode_ctrl_c3", /* address */ 0x441083f8, /* default */ 0x00000000, /* description */ "select bus_a or bus_b in shiftin/shiftout mode. \n"}, 
  {/* name */ "shiftout_data_ctrl_bitcnts_c3", /* address */ 0x441083fc, /* default */ 0x00000000, /* description */ "how man bits to shift out data from counter 3. \n"}, 
  {/* name */ "shiftout_data_c3", /* address */ 0x44108400, /* default */ 0x00000000, /* description */ "shift out data from counter 3. \n"}, 
  {/* name */ "shiftout_data_valid_c3", /* address */ 0x44108404, /* default */ 0x00000000, /* description */ "a new shift_out data flag for counter 3. \n"}, 
  {/* name */ "shiftin_data_ctrl_bitcnts_c3", /* address */ 0x44108408, /* default */ 0x00000000, /* description */ "how man bits of shift_in data for counter 3. . \n"}, 
  {/* name */ "shiftin_data_c3", /* address */ 0x4410840c, /* default */ 0x00000000, /* description */ "shift_in data for counter 3. \n"}, 
  {/* name */ "shiftin_databits_updated_c3", /* address */ 0x44108410, /* default */ 0x00000000, /* description */ "shift_in data(bitmap is updated) for counter 3. \n"}
};

field_const_t field_const_counter_all_apb_reg__intr_status[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_mask_status[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x1", /* access */ "read-only", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_clr[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_set[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_mask_set[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_mask_clr[]  = {
  {/* name */ "counter", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "count0 -> [7:0] \ncount1 -> [15:8] \ncount2 -> [23:16] \ncount3 -> [31:24] \n\n"}
};
field_const_t field_const_counter_all_apb_reg__intr_sreset[]  = {
  {/* name */ "o_intrctrl_sreset", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "Set interrupt softward reset,high active,high active.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__global_start_trigger[]  = {
  {/* name */ "o_global_start_trigger", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "global start trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__global_stop_trigger[]  = {
  {/* name */ "o_global_stop_trigger", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "global stop trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__global_clear_trigger[]  = {
  {/* name */ "o_global_clear_trigger", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "global clear trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__global_reset_trigger[]  = {
  {/* name */ "o_global_reset_trigger", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "global reset trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_start_trigger_c0[]  = {
  {/* name */ "o_single_start_trigger_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 single start trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_stop_trigger_c0[]  = {
  {/* name */ "o_single_stop_trigger_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 single stop trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_clear_trigger_c0[]  = {
  {/* name */ "o_single_clear_trigger_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 single clear trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_reset_trigger_c0[]  = {
  {/* name */ "o_single_reset_trigger_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 single reset trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__enable_c0[]  = {
  {/* name */ "o_enable_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 enable signal. \n"}, 
  {/* name */ "o_clk_ctrl_c0", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 0 clock select and inverse enable. \n"}
};
field_const_t field_const_counter_all_apb_reg__soft_trigger_ctrl_c0[]  = {
  {/* name */ "o_soft_trigger_ctrl_c0", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "for counter 0 only.\nevery bit means the same. 1--> softward trigger signal, 0--> normal control signal.\n[0]:set for signal o_global_start_trigger.\n[1]:set for signal o_global_stop_trigger.\n[2]:set for signal o_global_clear_trigger.\n[3]:set for signal o_global_reset_trigger.\n[4]:set for signal o_single_start_trigger.\n[5]:set for signal o_single_stop_trigger.\n[6]:set for signal o_single_clear_trigger.\n[7]:set for signal o_single_reset_trigger.\n\n"}
};
field_const_t field_const_counter_all_apb_reg__mux_sel_c0[]  = {
  {/* name */ "o_mux_sel_c0", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "bit0: 0--> bus_a, 1--> bus_b.\nbit1: 0--> bus_a, 1--> bus_b.\nbit2: 0--> bus_a, 1--> bus_b.\nbit3: 0--> bus_a, 1--> bus_b.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__src_sel_edge_c0[]  = {
  {/* name */ "o_src_sel_start_c0", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the  valid input for start signal.\n\n"}, 
  {/* name */ "o_src_edge_start_c0", /* range */ "[5:4]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_stop_c0", /* range */ "[11:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for stop signal.\n"}, 
  {/* name */ "o_src_edge_stop_c0", /* range */ "[13:12]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_din0_c0", /* range */ "[19:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din0 signal.\n"}, 
  {/* name */ "o_src_edge_din0_c0", /* range */ "[21:20]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din0 signal.\n"}, 
  {/* name */ "o_src_sel_din1_c0", /* range */ "[27:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din1 signal.\n"}, 
  {/* name */ "o_src_edge_din1_c0", /* range */ "[29:28]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din1 signal.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:30]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__ctrl_snap_c0[]  = {
  {/* name */ "o_ctrl_snap_c0", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "snap the status or data from counter 0. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shadow_reg_c0[]  = {
  {/* name */ "i_shadow_reg_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "snap the current value from counter.\n"}
};
field_const_t field_const_counter_all_apb_reg__mode_sel_c0[]  = {
  {/* name */ "o_mode_sel_c0", /* range */ "[2:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.\n[1]: 0-count mode, 1-shift mode.\n[2]: 0-automatic switch mode disable. 1-enable.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:3]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_ctrl_c0[]  = {
  {/* name */ "o_target_reg_ctrl_c0", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.\n[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.\n[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.\n[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.\n[4]: dout_a reset value.\n[5]: dout_b reset value.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a0_c0[]  = {
  {/* name */ "o_target_reg_a0_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a1_c0[]  = {
  {/* name */ "o_target_reg_a1_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a2_c0[]  = {
  {/* name */ "o_target_reg_a2_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b0_c0[]  = {
  {/* name */ "o_target_reg_b0_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b1_c0[]  = {
  {/* name */ "o_target_reg_b1_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b2_c0[]  = {
  {/* name */ "o_target_reg_b2_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_status_c0[]  = {
  {/* name */ "o_capture_reg_status_c0", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "every bit means the same, 1--> new data, 0--> old data.\n[0] : for o_capture_reg_a0.\n[1] : for o_capture_reg_a0.\n[2] : for o_capture_reg_a0.\n[0] : for o_capture_reg_b0.\n[1] : for o_capture_reg_b1.\n[2] : for o_capture_reg_b2.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c0[]  = {
  {/* name */ "o_capture_reg_overflow_ctrl_c0", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "every bit means the same as o_capture_reg_status_c0.\n1--> rewrite, o--> discard.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a0_c0[]  = {
  {/* name */ "i_capture_reg_a0_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a1_c0[]  = {
  {/* name */ "i_capture_reg_a1_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a2_c0[]  = {
  {/* name */ "i_capture_reg_a2_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b0_c0[]  = {
  {/* name */ "i_capture_reg_b0_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b1_c0[]  = {
  {/* name */ "i_capture_reg_b1_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b2_c0[]  = {
  {/* name */ "i_capture_reg_b2_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c0[]  = {
  {/* name */ "o_switch_mode_onebit_cnts_c0", /* range */ "[15:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform and capture switch mode, one bit data means counter value\n"}
};
field_const_t field_const_counter_all_apb_reg__waveform_mode_automatic_c0[]  = {
  {/* name */ "o_waveform_mode_cnts_c0", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , data sended counts.\n"}, 
  {/* name */ "o_capture_mode_cnts_c0", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "capture mode , data received counts.\n"}, 
  {/* name */ "o_waveform_mode_automatic_sw_c0", /* range */ "[16:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to waveform mode. 1- enable,0-disable.\n"}, 
  {/* name */ "o_capture_mode_automatic_sw_c0", /* range */ "[24:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to capture mode. 1- enable,0-disable.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:25]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftmode_ctrl_c0[]  = {
  {/* name */ "o_shiftmode_ctrl_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c0[]  = {
  {/* name */ "o_shiftout_data_ctrl_bitcnts_c0", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits to shift out data from counter 0. valud 0 means 1 bit.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_c0[]  = {
  {/* name */ "o_shiftout_data_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "shift out data from counter 0\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_valid_c0[]  = {
  {/* name */ "o_shiftout_data_valid_c0", /* range */ "[0:0]", /* default */ "0x0", /* access */ "write-only", /* description */ "a new shift_out data flag, high pulse is valid.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c0[]  = {
  {/* name */ "o_shiftin_data_ctrl_bitcnts_c0", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits of shift_in data for counter 0. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_c0[]  = {
  {/* name */ "i_shiftin_data_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data.\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftin_databits_updated_c0[]  = {
  {/* name */ "i_shiftin_databits_updated_c0", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data(bitmap is updated) for counter 0. value 1 is acitve.\n"}
};
field_const_t field_const_counter_all_apb_reg__single_start_trigger_c1[]  = {
  {/* name */ "o_single_start_trigger_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 1 single start trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_stop_trigger_c1[]  = {
  {/* name */ "o_single_stop_trigger_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 1 single stop trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_clear_trigger_c1[]  = {
  {/* name */ "o_single_clear_trigger_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 1 single clear trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_reset_trigger_c1[]  = {
  {/* name */ "o_single_reset_trigger_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 1 single reset trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__enable_c1[]  = {
  {/* name */ "o_enable_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 1 enable signal. \n"}, 
  {/* name */ "o_clk_ctrl_c1", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "count 1 clock select and inverse enable. \n"}
};
field_const_t field_const_counter_all_apb_reg__soft_trigger_ctrl_c1[]  = {
  {/* name */ "o_soft_trigger_ctrl_c1", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "for counter 1 only.\nevery bit means the same. 1--> softward trigger signal, 0--> normal control signal.\n[0]:set for signal o_global_start_trigger.\n[1]:set for signal o_global_stop_trigger.\n[2]:set for signal o_global_clear_trigger.\n[3]:set for signal o_global_reset_trigger.\n[4]:set for signal o_single_start_trigger.\n[5]:set for signal o_single_stop_trigger.\n[6]:set for signal o_single_clear_trigger.\n[7]:set for signal o_single_reset_trigger.\n\n"}
};
field_const_t field_const_counter_all_apb_reg__mux_sel_c1[]  = {
  {/* name */ "o_mux_sel_c1", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "bit0: 0--> bus_a, 1--> bus_b.\nbit1: 0--> bus_a, 1--> bus_b.\nbit2: 0--> bus_a, 1--> bus_b.\nbit3: 0--> bus_a, 1--> bus_b.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__src_sel_edge_c1[]  = {
  {/* name */ "o_src_sel_start_c1", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the  valid input for start signal.\n\n"}, 
  {/* name */ "o_src_edge_start_c1", /* range */ "[5:4]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_stop_c1", /* range */ "[11:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for stop signal.\n"}, 
  {/* name */ "o_src_edge_stop_c1", /* range */ "[13:12]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_din0_c1", /* range */ "[19:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din0 signal.\n"}, 
  {/* name */ "o_src_edge_din0_c1", /* range */ "[21:20]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din0 signal.\n"}, 
  {/* name */ "o_src_sel_din1_c1", /* range */ "[27:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din1 signal.\n"}, 
  {/* name */ "o_src_edge_din1_c1", /* range */ "[29:28]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din1 signal.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:30]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__ctrl_snap_c1[]  = {
  {/* name */ "o_ctrl_snap_c1", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "snap the status or data from counter 1. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shadow_reg_c1[]  = {
  {/* name */ "i_shadow_reg_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "snap the current value from counter.\n"}
};
field_const_t field_const_counter_all_apb_reg__mode_sel_c1[]  = {
  {/* name */ "o_mode_sel_c1", /* range */ "[2:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.\n[1]: 0-count mode, 1-shift mode.\n[2]: 0-automatic switch mode disable. 1-enable.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:3]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_ctrl_c1[]  = {
  {/* name */ "o_target_reg_ctrl_c1", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.\n[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.\n[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.\n[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.\n[4]: dout_a reset value.\n[5]: dout_b reset value.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a0_c1[]  = {
  {/* name */ "o_target_reg_a0_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a1_c1[]  = {
  {/* name */ "o_target_reg_a1_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a2_c1[]  = {
  {/* name */ "o_target_reg_a2_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b0_c1[]  = {
  {/* name */ "o_target_reg_b0_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b1_c1[]  = {
  {/* name */ "o_target_reg_b1_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b2_c1[]  = {
  {/* name */ "o_target_reg_b2_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_status_c1[]  = {
  {/* name */ "o_capture_reg_status_c1", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "every bit means the same, 1--> new data, 0--> old data.\n[0] : for o_capture_reg_a0.\n[1] : for o_capture_reg_a0.\n[2] : for o_capture_reg_a0.\n[0] : for o_capture_reg_b0.\n[1] : for o_capture_reg_b1.\n[2] : for o_capture_reg_b2.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c1[]  = {
  {/* name */ "o_capture_reg_overflow_ctrl_c1", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "every bit means the same as o_capture_reg_status_c1.\n1--> rewrite, o--> discard.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a0_c1[]  = {
  {/* name */ "i_capture_reg_a0_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a1_c1[]  = {
  {/* name */ "i_capture_reg_a1_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a2_c1[]  = {
  {/* name */ "i_capture_reg_a2_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b0_c1[]  = {
  {/* name */ "i_capture_reg_b0_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b1_c1[]  = {
  {/* name */ "i_capture_reg_b1_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b2_c1[]  = {
  {/* name */ "i_capture_reg_b2_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c1[]  = {
  {/* name */ "o_switch_mode_onebit_cnts_c1", /* range */ "[15:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform and capture switch mode, one bit data means counter value\n"}
};
field_const_t field_const_counter_all_apb_reg__waveform_mode_automatic_c1[]  = {
  {/* name */ "o_waveform_mode_cnts_c1", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , data sended counts.\n"}, 
  {/* name */ "o_capture_mode_cnts_c1", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "capture mode , data received counts.\n"}, 
  {/* name */ "o_waveform_mode_automatic_sw_c1", /* range */ "[16:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to waveform mode. 1- enable,0-disable.\n"}, 
  {/* name */ "o_capture_mode_automatic_sw_c1", /* range */ "[24:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to capture mode. 1- enable,0-disable.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:25]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftmode_ctrl_c1[]  = {
  {/* name */ "o_shiftmode_ctrl_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c1[]  = {
  {/* name */ "o_shiftout_data_ctrl_bitcnts_c1", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits to shift out data from counter 1. valud 0 means 1 bit.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_c1[]  = {
  {/* name */ "o_shiftout_data_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "shift out data from counter 1\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_valid_c1[]  = {
  {/* name */ "o_shiftout_data_valid_c1", /* range */ "[0:0]", /* default */ "0x0", /* access */ "write-only", /* description */ "a new shift_out data flag, high pulse is valid.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c1[]  = {
  {/* name */ "o_shiftin_data_ctrl_bitcnts_c1", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits of shift_in data for counter 1. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_c1[]  = {
  {/* name */ "i_shiftin_data_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data.\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftin_databits_updated_c1[]  = {
  {/* name */ "i_shiftin_databits_updated_c1", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data(bitmap is updated) for counter 1. value 1 is acitve.\n"}
};
field_const_t field_const_counter_all_apb_reg__single_start_trigger_c2[]  = {
  {/* name */ "o_single_start_trigger_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 single start trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_stop_trigger_c2[]  = {
  {/* name */ "o_single_stop_trigger_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 single stop trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_clear_trigger_c2[]  = {
  {/* name */ "o_single_clear_trigger_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 single clear trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_reset_trigger_c2[]  = {
  {/* name */ "o_single_reset_trigger_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 single reset trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__enable_c2[]  = {
  {/* name */ "o_enable_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 enable signal. \n"}, 
  {/* name */ "o_clk_ctrl_c2", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 2 clock select and inverse enable. \n"}
};
field_const_t field_const_counter_all_apb_reg__soft_trigger_ctrl_c2[]  = {
  {/* name */ "o_soft_trigger_ctrl_c2", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "for counter 2 only.\nevery bit means the same. 1--> softward trigger signal, 0--> normal control signal.\n[0]:set for signal o_global_start_trigger.\n[1]:set for signal o_global_stop_trigger.\n[2]:set for signal o_global_clear_trigger.\n[3]:set for signal o_global_reset_trigger.\n[4]:set for signal o_single_start_trigger.\n[5]:set for signal o_single_stop_trigger.\n[6]:set for signal o_single_clear_trigger.\n[7]:set for signal o_single_reset_trigger.\n\n"}
};
field_const_t field_const_counter_all_apb_reg__mux_sel_c2[]  = {
  {/* name */ "o_mux_sel_c2", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "bit0: 0--> bus_a, 1--> bus_b.\nbit1: 0--> bus_a, 1--> bus_b.\nbit2: 0--> bus_a, 1--> bus_b.\nbit3: 0--> bus_a, 1--> bus_b.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__src_sel_edge_c2[]  = {
  {/* name */ "o_src_sel_start_c2", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the  valid input for start signal.\n\n"}, 
  {/* name */ "o_src_edge_start_c2", /* range */ "[5:4]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_stop_c2", /* range */ "[11:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for stop signal.\n"}, 
  {/* name */ "o_src_edge_stop_c2", /* range */ "[13:12]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_din0_c2", /* range */ "[19:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din0 signal.\n"}, 
  {/* name */ "o_src_edge_din0_c2", /* range */ "[21:20]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din0 signal.\n"}, 
  {/* name */ "o_src_sel_din1_c2", /* range */ "[27:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din1 signal.\n"}, 
  {/* name */ "o_src_edge_din1_c2", /* range */ "[29:28]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din1 signal.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:30]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__ctrl_snap_c2[]  = {
  {/* name */ "o_ctrl_snap_c2", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "snap the status or data from counter 2. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shadow_reg_c2[]  = {
  {/* name */ "i_shadow_reg_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "snap the current value from counter.\n"}
};
field_const_t field_const_counter_all_apb_reg__mode_sel_c2[]  = {
  {/* name */ "o_mode_sel_c2", /* range */ "[2:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.\n[1]: 0-count mode, 1-shift mode.\n[2]: 0-automatic switch mode disable. 1-enable.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:3]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_ctrl_c2[]  = {
  {/* name */ "o_target_reg_ctrl_c2", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.\n[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.\n[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.\n[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.\n[4]: dout_a reset value.\n[5]: dout_b reset value.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a0_c2[]  = {
  {/* name */ "o_target_reg_a0_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a1_c2[]  = {
  {/* name */ "o_target_reg_a1_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a2_c2[]  = {
  {/* name */ "o_target_reg_a2_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b0_c2[]  = {
  {/* name */ "o_target_reg_b0_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b1_c2[]  = {
  {/* name */ "o_target_reg_b1_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b2_c2[]  = {
  {/* name */ "o_target_reg_b2_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_status_c2[]  = {
  {/* name */ "o_capture_reg_status_c2", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "every bit means the same, 1--> new data, 0--> old data.\n[0] : for o_capture_reg_a0.\n[1] : for o_capture_reg_a0.\n[2] : for o_capture_reg_a0.\n[0] : for o_capture_reg_b0.\n[1] : for o_capture_reg_b1.\n[2] : for o_capture_reg_b2.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c2[]  = {
  {/* name */ "o_capture_reg_overflow_ctrl_c2", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "every bit means the same as o_capture_reg_status_c2.\n1--> rewrite, o--> discard.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a0_c2[]  = {
  {/* name */ "i_capture_reg_a0_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a1_c2[]  = {
  {/* name */ "i_capture_reg_a1_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a2_c2[]  = {
  {/* name */ "i_capture_reg_a2_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b0_c2[]  = {
  {/* name */ "i_capture_reg_b0_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b1_c2[]  = {
  {/* name */ "i_capture_reg_b1_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b2_c2[]  = {
  {/* name */ "i_capture_reg_b2_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c2[]  = {
  {/* name */ "o_switch_mode_onebit_cnts_c2", /* range */ "[15:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform and capture switch mode, one bit data means counter value\n"}
};
field_const_t field_const_counter_all_apb_reg__waveform_mode_automatic_c2[]  = {
  {/* name */ "o_waveform_mode_cnts_c2", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , data sended counts.\n"}, 
  {/* name */ "o_capture_mode_cnts_c2", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "capture mode , data received counts.\n"}, 
  {/* name */ "o_waveform_mode_automatic_sw_c2", /* range */ "[16:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to waveform mode. 1- enable,0-disable.\n"}, 
  {/* name */ "o_capture_mode_automatic_sw_c2", /* range */ "[24:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to capture mode. 1- enable,0-disable.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:25]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftmode_ctrl_c2[]  = {
  {/* name */ "o_shiftmode_ctrl_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c2[]  = {
  {/* name */ "o_shiftout_data_ctrl_bitcnts_c2", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits to shift out data from counter 2. valud 0 means 1 bit.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_c2[]  = {
  {/* name */ "o_shiftout_data_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "shift out data from counter 2\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_valid_c2[]  = {
  {/* name */ "o_shiftout_data_valid_c2", /* range */ "[0:0]", /* default */ "0x0", /* access */ "write-only", /* description */ "a new shift_out data flag, high pulse is valid.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c2[]  = {
  {/* name */ "o_shiftin_data_ctrl_bitcnts_c2", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits of shift_in data for counter 2. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_c2[]  = {
  {/* name */ "i_shiftin_data_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data.\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftin_databits_updated_c2[]  = {
  {/* name */ "i_shiftin_databits_updated_c2", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data(bitmap is updated) for counter 2. value 1 is acitve.\n"}
};
field_const_t field_const_counter_all_apb_reg__single_start_trigger_c3[]  = {
  {/* name */ "o_single_start_trigger_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 3 single start trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_stop_trigger_c3[]  = {
  {/* name */ "o_single_stop_trigger_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 3 single stop trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_clear_trigger_c3[]  = {
  {/* name */ "o_single_clear_trigger_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 3 single clear trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__single_reset_trigger_c3[]  = {
  {/* name */ "o_single_reset_trigger_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 3 single reset trigger. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__enable_c3[]  = {
  {/* name */ "o_enable_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "counter 3 enable signal. \n"}, 
  {/* name */ "o_clk_ctrl_c3", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "count 3 clock select and inverse enable. \n"}
};
field_const_t field_const_counter_all_apb_reg__soft_trigger_ctrl_c3[]  = {
  {/* name */ "o_soft_trigger_ctrl_c3", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "for counter 3 only.\nevery bit means the same. 1--> softward trigger signal, 0--> normal control signal.\n[0]:set for signal o_global_start_trigger.\n[1]:set for signal o_global_stop_trigger.\n[2]:set for signal o_global_clear_trigger.\n[3]:set for signal o_global_reset_trigger.\n[4]:set for signal o_single_start_trigger.\n[5]:set for signal o_single_stop_trigger.\n[6]:set for signal o_single_clear_trigger.\n[7]:set for signal o_single_reset_trigger.\n\n"}
};
field_const_t field_const_counter_all_apb_reg__mux_sel_c3[]  = {
  {/* name */ "o_mux_sel_c3", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "bit0: 0--> bus_a, 1--> bus_b.\nbit1: 0--> bus_a, 1--> bus_b.\nbit2: 0--> bus_a, 1--> bus_b.\nbit3: 0--> bus_a, 1--> bus_b.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__src_sel_edge_c3[]  = {
  {/* name */ "o_src_sel_start_c3", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the  valid input for start signal.\n\n"}, 
  {/* name */ "o_src_edge_start_c3", /* range */ "[5:4]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_stop_c3", /* range */ "[11:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for stop signal.\n"}, 
  {/* name */ "o_src_edge_stop_c3", /* range */ "[13:12]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for start signal.\n"}, 
  {/* name */ "o_src_sel_din0_c3", /* range */ "[19:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din0 signal.\n"}, 
  {/* name */ "o_src_edge_din0_c3", /* range */ "[21:20]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din0 signal.\n"}, 
  {/* name */ "o_src_sel_din1_c3", /* range */ "[27:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid input for din1 signal.\n"}, 
  {/* name */ "o_src_edge_din1_c3", /* range */ "[29:28]", /* default */ "0x0", /* access */ "read-write", /* description */ "select the valid edge for din1 signal.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:30]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__ctrl_snap_c3[]  = {
  {/* name */ "o_ctrl_snap_c3", /* range */ "[3:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "snap the status or data from counter 3. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:4]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shadow_reg_c3[]  = {
  {/* name */ "i_shadow_reg_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "snap the current value from counter.\n"}
};
field_const_t field_const_counter_all_apb_reg__mode_sel_c3[]  = {
  {/* name */ "o_mode_sel_c3", /* range */ "[2:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: 0-capture_mode/shitin_mode, 1-waveform_mode/shiftout_mode.\n[1]: 0-count mode, 1-shift mode.\n[2]: 0-automatic switch mode disable. 1-enable.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:3]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_ctrl_c3[]  = {
  {/* name */ "o_target_reg_ctrl_c3", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "[0]: when counters meet i_target_reg_a2, 1- keep the value,   0- reset the value.\n[1]: when counters meet i_target_reg_a2, 1- stop the counter, 0- restart the counter.\n[2]: when counters meet i_target_reg_b2, 1- keep the value,   0- reset the value.\n[3]: when counters meet i_target_reg_b2, 1- stop the counter, 0- restart the counter.\n[4]: dout_a reset value.\n[5]: dout_b reset value.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a0_c3[]  = {
  {/* name */ "o_target_reg_a0_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a1_c3[]  = {
  {/* name */ "o_target_reg_a1_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_a2_c3[]  = {
  {/* name */ "o_target_reg_a2_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b0_c3[]  = {
  {/* name */ "o_target_reg_b0_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b1_c3[]  = {
  {/* name */ "o_target_reg_b1_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__target_reg_b2_c3[]  = {
  {/* name */ "o_target_reg_b2_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , target register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_status_c3[]  = {
  {/* name */ "o_capture_reg_status_c3", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "every bit means the same, 1--> new data, 0--> old data.\n[0] : for o_capture_reg_a0.\n[1] : for o_capture_reg_a0.\n[2] : for o_capture_reg_a0.\n[0] : for o_capture_reg_b0.\n[1] : for o_capture_reg_b1.\n[2] : for o_capture_reg_b2.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c3[]  = {
  {/* name */ "o_capture_reg_overflow_ctrl_c3", /* range */ "[5:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "every bit means the same as o_capture_reg_status_c3.\n1--> rewrite, o--> discard.\n\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:6]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a0_c3[]  = {
  {/* name */ "i_capture_reg_a0_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a1_c3[]  = {
  {/* name */ "i_capture_reg_a1_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_a2_c3[]  = {
  {/* name */ "i_capture_reg_a2_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register a2.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b0_c3[]  = {
  {/* name */ "i_capture_reg_b0_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b0.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b1_c3[]  = {
  {/* name */ "i_capture_reg_b1_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b1.\n"}
};
field_const_t field_const_counter_all_apb_reg__capture_reg_b2_c3[]  = {
  {/* name */ "i_capture_reg_b2_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "capture mode, capture register b2.\n"}
};
field_const_t field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c3[]  = {
  {/* name */ "o_switch_mode_onebit_cnts_c3", /* range */ "[15:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform and capture switch mode, one bit data means counter value\n"}
};
field_const_t field_const_counter_all_apb_reg__waveform_mode_automatic_c3[]  = {
  {/* name */ "o_waveform_mode_cnts_c3", /* range */ "[7:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "waveform mode , data sended counts.\n"}, 
  {/* name */ "o_capture_mode_cnts_c3", /* range */ "[15:8]", /* default */ "0x0", /* access */ "read-write", /* description */ "capture mode , data received counts.\n"}, 
  {/* name */ "o_waveform_mode_automatic_sw_c3", /* range */ "[16:16]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to waveform mode. 1- enable,0-disable.\n"}, 
  {/* name */ "o_capture_mode_automatic_sw_c3", /* range */ "[24:24]", /* default */ "0x0", /* access */ "read-write", /* description */ "automatic switch to capture mode. 1- enable,0-disable.\n"}, 
  {/* name */ "dummy_field", /* range */ "[31:25]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftmode_ctrl_c3[]  = {
  {/* name */ "o_shiftmode_ctrl_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "0-bus_a(din_a/dout_a),1-bus_b(din_b/dout_b).\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c3[]  = {
  {/* name */ "o_shiftout_data_ctrl_bitcnts_c3", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits to shift out data from counter 3. valud 0 means 1 bit.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_c3[]  = {
  {/* name */ "o_shiftout_data_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "shift out data from counter 3\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftout_data_valid_c3[]  = {
  {/* name */ "o_shiftout_data_valid_c3", /* range */ "[0:0]", /* default */ "0x0", /* access */ "write-only", /* description */ "a new shift_out data flag, high pulse is valid.\n"}, 
  {/* name */ "dummy_field", /* range */ "[7:1]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c3[]  = {
  {/* name */ "o_shiftin_data_ctrl_bitcnts_c3", /* range */ "[4:0]", /* default */ "0x0", /* access */ "read-write", /* description */ "how man bits of shift_in data for counter 3. \n"}, 
  {/* name */ "dummy_field", /* range */ "[7:5]", /* default */ "0x0", /* access */ "no-access", /* description */ ""}
};
field_const_t field_const_counter_all_apb_reg__shiftin_data_c3[]  = {
  {/* name */ "i_shiftin_data_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data.\n"}
};
field_const_t field_const_counter_all_apb_reg__shiftin_databits_updated_c3[]  = {
  {/* name */ "i_shiftin_databits_updated_c3", /* range */ "[31:0]", /* default */ "0x0", /* access */ "read-only", /* description */ "shift_in data(bitmap is updated) for counter 3. value 1 is acitve.\n"}
};

field_const_array_t reg_pnt_list__counter_all_apb_reg[NUM_REGS__COUNTER_ALL_APB_REG] = {
  { /* pfield */ field_const_counter_all_apb_reg__intr_status, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_mask_status, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_clr, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_set, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_mask_set, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_mask_clr, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__intr_sreset, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__global_start_trigger, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__global_stop_trigger, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__global_clear_trigger, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__global_reset_trigger, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_start_trigger_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_stop_trigger_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_clear_trigger_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_reset_trigger_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__enable_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__soft_trigger_ctrl_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mux_sel_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__src_sel_edge_c0, /* size */ 9}, 
  { /* pfield */ field_const_counter_all_apb_reg__ctrl_snap_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shadow_reg_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mode_sel_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_ctrl_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a0_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a1_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a2_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b0_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b1_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b2_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_status_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a0_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a1_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a2_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b0_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b1_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b2_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__waveform_mode_automatic_c0, /* size */ 5}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftmode_ctrl_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_valid_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c0, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_databits_updated_c0, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_start_trigger_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_stop_trigger_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_clear_trigger_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_reset_trigger_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__enable_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__soft_trigger_ctrl_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mux_sel_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__src_sel_edge_c1, /* size */ 9}, 
  { /* pfield */ field_const_counter_all_apb_reg__ctrl_snap_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shadow_reg_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mode_sel_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_ctrl_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a0_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a1_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a2_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b0_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b1_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b2_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_status_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a0_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a1_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a2_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b0_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b1_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b2_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__waveform_mode_automatic_c1, /* size */ 5}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftmode_ctrl_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_valid_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c1, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_databits_updated_c1, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_start_trigger_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_stop_trigger_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_clear_trigger_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_reset_trigger_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__enable_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__soft_trigger_ctrl_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mux_sel_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__src_sel_edge_c2, /* size */ 9}, 
  { /* pfield */ field_const_counter_all_apb_reg__ctrl_snap_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shadow_reg_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mode_sel_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_ctrl_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a0_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a1_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a2_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b0_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b1_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b2_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_status_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a0_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a1_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a2_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b0_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b1_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b2_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__waveform_mode_automatic_c2, /* size */ 5}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftmode_ctrl_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_valid_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c2, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_databits_updated_c2, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_start_trigger_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_stop_trigger_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_clear_trigger_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__single_reset_trigger_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__enable_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__soft_trigger_ctrl_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mux_sel_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__src_sel_edge_c3, /* size */ 9}, 
  { /* pfield */ field_const_counter_all_apb_reg__ctrl_snap_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shadow_reg_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__mode_sel_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_ctrl_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a0_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a1_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_a2_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b0_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b1_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__target_reg_b2_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_status_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_overflow_ctrl_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a0_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a1_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_a2_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b0_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b1_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__capture_reg_b2_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__switch_mode_onebit_cnts_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__waveform_mode_automatic_c3, /* size */ 5}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftmode_ctrl_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_ctrl_bitcnts_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftout_data_valid_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_ctrl_bitcnts_c3, /* size */ 2}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_data_c3, /* size */ 1}, 
  { /* pfield */ field_const_counter_all_apb_reg__shiftin_databits_updated_c3, /* size */ 1}
};
