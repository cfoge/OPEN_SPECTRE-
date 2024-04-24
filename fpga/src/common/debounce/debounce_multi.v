`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2022 14:34:42
// Design Name: 
// Module Name: debounce_multi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: create custom width debounce busses, where the debounce time is based on a counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce_multi #(parameter num_bits = 8, DBtime = 8)(
    input [num_bits-1:0] button,
    input clk,
    input reset,
    output [num_bits-1:0] result
    );
    
    
    debounce_n #(.DBtime(DBtime) ) debounce_8[7:0](.button(button),.clk(clk),.reset(reset),.result(result));
    
endmodule
