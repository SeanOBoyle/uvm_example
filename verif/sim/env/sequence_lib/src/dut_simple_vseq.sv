`ifndef DUT_SIMPLE_VSEQ__SV
`define DUT_SIMPLE_VSEQ__SV

class dut_simple_vseq extends dut_base_vseq;
  `uvm_object_utils(dut_simple_vseq)

  // Constructor
  function new(string name = "dut_simple_vseq");
    super.new(name);
  endfunction

  // Body
  extern virtual task body();

endclass: dut_simple_vseq


task dut_simple_vseq::body();
  super.body();

  // Write then Read -- simple test
  begin
    int unsigned rdata;
    int unsigned wdata;

    for (int ii=0; ii<16; ii+=1) begin
      host_write(ii, ii);
    end

    for(int ii=0; ii<16; ii+=1) begin
      host_read(ii, rdata);
      if (rdata != ii) begin
      `uvm_error(get_name(), $psprintf("Data Mismatch; Expected %0x, Got %0x", ii, rdata))
      end
      else begin
        `uvm_info(get_name(), $psprintf("Data Match; Expected %0x, Got %0x", ii, rdata), UVM_HIGH)
      end
    end

    wdata = 'hAF;
    host_write('d3, wdata);
    host_read('d3, rdata);
    if (rdata != wdata) begin
      `uvm_error(get_name(), $psprintf("Data Mismatch; Expected %0x, Got %0x", wdata, rdata))
    end
    else begin
      `uvm_info(get_name(), $psprintf("Data Match; Expected %0x, Got %0x", wdata, rdata), UVM_HIGH)
    end
  end

  #10us;

endtask:body


`endif // DUT_SIMPLE_VSEQ