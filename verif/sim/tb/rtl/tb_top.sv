`ifndef TB_TOP__SV
`define TB_TOP__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Agents
`include "host_pkg.sv"

// Interfaces
`include "host_if.sv"

// Environment and Tests
`include "dut_pkg.sv"
`include "dut_test_list.sv"


`timescale 1ns/1ps

module tb_top;

  // Declare Variables
  logic host_clk;
  logic reset_n;
  logic host_sel;
  logic host_wr;
  logic [3:0] host_addr;
  logic [7:0] host_wdata;
  logic [7:0] host_rdata;

  // Instantiate DUT
  dut u_dut (
    .host_clk_i  (host_clk),
    .reset_n_i   (reset_n),
    .host_sel_i  (u_host_if.sel),
    .host_wr_i   (u_host_if.wr),
    .host_addr_i (u_host_if.addr),
    .host_wdata_i(u_host_if.wdata),
    .host_rdata_o(u_host_if.rdata)
  );


  // Create Simple Clock
  initial begin
    host_clk = 0;
    forever begin
      #100ns;
      host_clk = ~host_clk;
    end
  end

  // Create Simple Reset
  initial begin
    reset_n = 0;
    #10ns;
    reset_n = 1;
  end

  // Instantiate Interfaces
  host_if u_host_if (
    .clk_i(host_clk)
  );

  // Pass Interfaces to Cfg DB
  initial begin
    uvm_config_db#(virtual host_if.drv_mp)::set(null, "*", "host_vif_drv", u_host_if.drv_mp);
    uvm_config_db#(virtual host_if.mon_mp)::set(null, "*", "host_vif_mon", u_host_if.mon_mp);
  end

  // Run Test
  initial begin
    $timeformat(-9, 0, " ns", 5); // show time in ns

    // Start UVM
    run_test();
  end


endmodule: tb_top

`endif // TB_TOP__SV