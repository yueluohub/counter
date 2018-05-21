
grep "num =0" sim.log > num0.log
grep "num =1" sim.log > num1.log
grep "num =2" sim.log > num2.log
grep "num =3" sim.log > num3.log
grep "bus a" num0.log > num0_a.log
grep "bus b" num0.log > num0_b.log
grep "bus a" num1.log > num1_a.log
grep "bus b" num1.log > num1_b.log
grep "bus a" num2.log > num2_a.log
grep "bus b" num2.log > num2_b.log
grep "bus a" num3.log > num3_a.log
grep "bus b" num3.log > num3_b.log

grep "APB " sim.log > APB.log

grep "counter0:" sim.log > counter0.log
grep "counter1:" sim.log > counter1.log
grep "counter2:" sim.log > counter2.log
grep "counter3:" sim.log > counter3.log
grep "counter_all:" sim.log > counter_g.log

grep "single start trigger" counter0.log > counter0_trigger0.log
grep "single stop  trigger" counter0.log > counter0_trigger1.log
grep "single clear trigger" counter0.log > counter0_trigger2.log
grep "single reset trigger" counter0.log > counter0_trigger3.log
grep "extern_din_a" counter0.log > counter0_din_a.log
grep "extern_din_b" counter0.log > counter0_din_b.log

grep "single start trigger" counter1.log > counter1_trigger0.log
grep "single stop  trigger" counter1.log > counter1_trigger1.log
grep "single clear trigger" counter1.log > counter1_trigger2.log
grep "single reset trigger" counter1.log > counter1_trigger3.log
grep "extern_din_a" counter1.log > counter1_din_a.log
grep "extern_din_b" counter1.log > counter1_din_b.log

grep "single start trigger" counter2.log > counter2_trigger0.log
grep "single stop  trigger" counter2.log > counter2_trigger1.log
grep "single clear trigger" counter2.log > counter2_trigger2.log
grep "single reset trigger" counter2.log > counter2_trigger3.log
grep "extern_din_a" counter2.log > counter2_din_a.log
grep "extern_din_b" counter2.log > counter2_din_b.log

grep "single start trigger" counter3.log > counter3_trigger0.log
grep "single stop  trigger" counter3.log > counter3_trigger1.log
grep "single clear trigger" counter3.log > counter3_trigger2.log
grep "single reset trigger" counter3.log > counter3_trigger3.log
grep "extern_din_a" counter3.log > counter3_din_a.log
grep "extern_din_b" counter3.log > counter3_din_b.log

grep "global start trigger" counter_g.log > counter_g_trigger0.log
grep "global stop  trigger" counter_g.log > counter_g_trigger1.log
grep "global clear trigger" counter_g.log > counter_g_trigger2.log
grep "global reset trigger" counter_g.log > counter_g_trigger3.log
