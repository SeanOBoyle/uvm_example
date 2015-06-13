#!/bin/sh
irun \
-f ../files/uvm.f -f ../files/rtl.f -f ../files/dv.f \
+define+INCA \
+define+INCA_USE_TYPENAME \
+define+UVM_NO_DEPRECATED \
+define+UVM_REPORT_DISABLE_FILE_LINE \
-uvmnoautocompile \
-access r \
-input probe.tcl \
+UVM_TESTNAME=dut_test_base \
+UVM_VSEQ_TESTNAME=dut_simple_vseq

