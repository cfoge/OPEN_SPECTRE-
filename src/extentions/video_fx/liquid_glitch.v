`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2021 11:54:45
// Design Name: 
// Module Name: liquid_glitch
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


module liquid_glitch(

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
            3'b001  :// lv1
                begin
                     pos = 8'd127;
                     vid = {(red&pos) <<< 1, (green&pos) <<< 1, (blue&pos) <<< 1};
                end
                
            3'b010  :// lv2
                begin
                     pos = 8'd63;
                     vid = {red&pos <<< 2, green&pos <<< 2, blue&pos <<< 2};
                end
                
            3'b011  :// lv3
                begin
                     pos = 8'd31;
                     vid = {red&pos <<< 3, green&pos <<< 3, blue&pos <<< 3};
                end

                
                

                
            
            default :  //no effect
                begin
                     vid = {red ,green, blue };
                end
            
        endcase
        
        
    end
    
    assign vid_pData_out = vid;
    
    
endmodule