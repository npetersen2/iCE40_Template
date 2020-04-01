`timescale 1 ns / 1 ps

// ===========================================
// iCE40 Phase-Locked Loop (PLL)
// ===========================================
//
// By Nathan Petersen
// April 1, 2020
//
// See "iCE40 sysCLOCK PLL Design and Usage Guide"
// Lattice Technical Note: TN1251
//
// ===============
// PLL Limitations
// ===============
// 
// Per the datasheet, for HX devices, frequency limits (MHz):
//  - Reference Clock Input    = [ 10   133]    <== value defined by PCB
//
//  - PLL Clock Output         = [ 16   275]    <=\ 
//  - PLL VCO                  = [533  1066]    <== values defined by PLL register settings
//  - PLL Phase Detector Input = [ 10   133]    <=/ 
//
// =========================
// PLL Configuration / Usage
// =========================
//
// For simple applications where we want to derive a system clock based
// upon a reference input clock, we use the PLL in "SIMPLE" mode, where
// the PLL output frequency is defined by:
//
// Fin  = input reference clock frequency
// DIVF = binary parameter for PLL, range [0  63]
// DIVQ = binary parameter for PLL, range [0   7]
// DIVR = binary parameter for PLL, range [0  15]
//
// Fout = (Fin * (DIVF + 1)) / ((2^DIVQ) * (DIVR + 1))
//
// ============
// Restrictions
// ============
//
// Given the PLL Limitations listed above (from datasheet),
//  - VCO Frequency  (MHz) = [533  1066] = (Fin * (DIVF + 1)) / (DIVR + 1)
//  - Ph Detect Freq (Mhz) = [ 10   133] = (Fin / (2^DIVR)) ???? TODO, not sure!
//
// =======
// Example
// =======
//
// Fin  = 12 MHz
// DIVF = 79
// DIVQ = 3
// DIVR = 0
//
// Fout = (12 * (79 + 1)) / ((2^3) * (0 + 1))
//      = 120 MHz
//
// ===========================================

`define PLL_DIVF (7'd79)
`define PLL_DIVQ (3'd3)
`define PLL_DIVR (4'd0)
`define PLL_FILTER_RANGE (3'd1)

module pll(clock_in, global_clock, locked);

input  clock_in;
output global_clock;
output locked;

wire clock_int;

// Configure PLL
SB_PLL40_CORE #(                            
    .FEEDBACK_PATH("SIMPLE"),
    .DIVR(`PLL_DIVR),
    .DIVF(`PLL_DIVF),
    .DIVQ(`PLL_DIVQ),
    .FILTER_RANGE(`PLL_FILTER_RANGE)
    ) pll_inst (                                
        .LOCK(locked),                        
        .RESETB(1'b1),                        
        .BYPASS(1'b0),                        
        .REFERENCECLK(clock_in),                
        .PLLOUTGLOBAL(clock_int)                
    );

// Hook up PLL output to a global buffer designed for
// distributing signals to entire device (i.e. clocks)
//
// From TN1251:
//
// A Global Buffer is required for a user's internally
// generated FPGA signal that is heavily loaded and
// requires global buffering. For example, a user’s
// logic-generated clock.
//
SB_GB gb_inst (
    .USER_SIGNAL_TO_GLOBAL_BUFFER(clock_int),
    .GLOBAL_BUFFER_OUTPUT(global_clock)
);

endmodule    