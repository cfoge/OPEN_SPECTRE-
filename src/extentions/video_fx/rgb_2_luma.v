`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan
// 
// Create Date: 24.06.2021 17:24:01
// Design Name: 
// Module Name: rgb_2_luma
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: Converts RGB channels to luma channel
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb_2_luma(
        input [23:0] vid_pData_in,
        output [7:0] vid_pData_out
    );
    
    
    reg [7:0] vid;
    wire [7:0] red =  vid_pData_in[7:0];
    wire [7:0] green =  vid_pData_in[15:8];
    wire [7:0] blue =  vid_pData_in[23:16];
    
//First atempt (cells = 59, io = 32, nets = 100)    
//    always @ (vid_pData_in) begin
    
//    vid = ((red+green+blue)/3);
    
//    end
    
//    assign vid_pData_out = vid;

// Second atempt (cells = 59, io = 32, nets = 100)   
    assign vid_pData_out = ((red+green+blue)/3);
  
    
// Third Atempt (cells = 51, io = 32, nets = 100) 

// assign vid_pData_out = ((( (red+green) >>1) +blue)>>1);
    
    
endmodule
