`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan
// 
// Create Date: 24.06.2021 17:17:05
// Design Name: rgb_swap
// Module Name: rgb_swap
// Project Name: 
// Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: Swaps RGB channels
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb_swap(
        input [23:0] vid_pData_in,
        input [1:0] mode, //selects fx mode
        output [23:0] vid_pData_out
    );
    
    reg [23:0] vid;
    wire [7:0] red =  vid_pData_in[7:0];
    wire [7:0] green =  vid_pData_in[15:8];
    wire [7:0] blue =  vid_pData_in[23:16];
    
    
    always @ (vid_pData_in, mode) begin
        case (mode)
            2'b01  ://GBR
                begin
                     vid = {green,blue,red};
                end
            2'b10  ://BRG
                begin
                     vid = {blue,red,green};
                end
                
            2'b10  ://BRG
                begin
                     vid = {blue,red,green};
                end
                
            2'b10  ://BGR
                begin
                     vid = {blue,green,red};
                end

            
            default :  // no effect
                begin
                     vid = {red,green,blue};
                end
            
        endcase
        
        
    end
    
    assign vid_pData_out = vid;
    
endmodule
