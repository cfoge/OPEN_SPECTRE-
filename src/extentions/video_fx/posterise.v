`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan 
// 
// Create Date: 24.06.2021 17:41:07
// Design Name: 
// Module Name: posterise
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: Posterise effect
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module posterise(
        input [23:0] vid_pData_in,
        input [2:0] mode,
        output [23:0] vid_pData_out
    );
    
    reg [23:0] vid;
    reg [7:0] pos;
    wire [7:0] blue =  vid_pData_in[7:0];
    wire [7:0] green =  vid_pData_in[15:8];
    wire [7:0] red =  vid_pData_in[23:16];
    
     always @ (vid_pData_in, mode) begin
        case (mode)
            3'b001  ://posterise lv1
                begin
                     pos = 8'd127;
                     vid = {red|pos, green|pos, blue|pos};
                end
                
            3'b010  ://posterise lv2
                begin
                     pos = 8'd61;
                     vid = {red|pos, green|pos, blue|pos};
                end
                
            3'b011  ://posterise lv3
                begin
                     pos = 8'd31;
                     vid = {red|pos, green|pos, blue|pos};
                end
                
            3'b100  ://posterise lv4
                begin
                     pos = 8'd15;
                     vid = {red|pos, green|pos, blue|pos};
                end
             
            3'b101  ://posterise lv5
                begin
                     pos = 8'd7;
                     vid = {red|pos, green|pos, blue|pos};
                end

                
            
            default :  //no effect
                begin
                     vid = {red ,green, blue };
                end
            
        endcase
        
        
    end
    
    assign vid_pData_out = vid;
    
    
endmodule
