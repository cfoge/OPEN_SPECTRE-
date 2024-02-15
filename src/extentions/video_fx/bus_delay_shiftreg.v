`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2021 11:03:02
// Design Name: 
// Module Name: bus_delay_shiftreg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bus_delay_shiftreg(

        input [7:0] inputbus,
        input clk,
        output [7:0] outputbus
    );
     parameter MSB = 5;        // [Optional] Declare a parameter to represent number of bits in shift register
     wire [MSB:0] o1,o2,o3,o4,o5,o6,o7,o8;
    
    
    nbit_shiftreg #(MSB) sr0(
        .d(inputbus[0]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o1)
    );
    nbit_shiftreg #(MSB) sr1(
        .d(inputbus[1]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o2)
    );
    nbit_shiftreg #(MSB) sr2(
        .d(inputbus[2]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o3)
    );
    nbit_shiftreg #(MSB) sr3(
        .d(inputbus[3]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o4)
    );
    nbit_shiftreg #(MSB) sr4(
        .d(inputbus[4]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o5)
    );
    nbit_shiftreg #(MSB) sr5(
        .d(inputbus[5]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o6)
    );
    nbit_shiftreg #(MSB) sr6(
        .d(inputbus[6]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o7)
    );
    nbit_shiftreg #(MSB) sr7(
        .d(inputbus[7]),
        .clk(clk),
        .en(1'b1),
        .dir(1'b0),
        .rstn(1'b1),
        .out(o8)
    );
    
    
    assign outputbus = {o8[2],o7[2],o6[2],o5[2],o4[2],o3[2],o2[2],o1[2]};
    
    
endmodule
