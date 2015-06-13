`ifndef HOST_IF__SV
`define HOST_IF__SV

`timescale 1ns/1ps

interface host_if(input bit clk_i);

  logic sel;
  logic wr;
  logic [3:0] addr;
  logic [7:0] wdata;
  logic [7:0] rdata;

  clocking drv_cb @(posedge clk_i);
    default input #1step output #1ns;

    output sel;
    output wr;
    output addr;
    output wdata;
    input  rdata;

  endclocking: drv_cb

  clocking mon_cb @(posedge clk_i);
    default input #1step;

    input  sel;
    input  wr;
    input  addr;
    input  wdata;
    input  rdata;

  endclocking: mon_cb

  modport drv_mp (
    clocking drv_cb,
    // async ports - for initializing pre-clock
    output  sel,
    output  wr,
    output  addr,
    output  wdata
  );

  modport mon_mp (
    clocking mon_cb
  );

endinterface: host_if

`endif // HOST_IF__SV