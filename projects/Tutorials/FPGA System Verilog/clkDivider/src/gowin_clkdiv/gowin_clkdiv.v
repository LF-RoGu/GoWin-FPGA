//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.01 Education (64-bit)
//Part Number: GW1NSR-LV4CQN48PC6/I5
//Device: GW1NSR-4C
//Created Time: Sat Apr 26 11:43:43 2025

module Gowin_CLKDIV (clkout, hclkin, resetn, calib);

output clkout;
input hclkin;
input resetn;
input calib;

CLKDIV clkdiv_inst (
    .CLKOUT(clkout),
    .HCLKIN(hclkin),
    .RESETN(resetn),
    .CALIB(calib)
);

defparam clkdiv_inst.DIV_MODE = "8";
defparam clkdiv_inst.GSREN = "false";

endmodule //Gowin_CLKDIV
