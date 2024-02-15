`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan
// 
// Create Date: 19.05.2021 13:19:52
// Design Name: 
// Module Name: rgb_invert
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb_invert(
        input pxclk,
        input [23:0] vid_pData_in,
        input [3:0] mode,
        output [23:0] vid_pData_out
    );
    
    reg [23:0] vid;
    wire [7:0] red =  vid_pData_in[7:0];
    wire [7:0] green =  vid_pData_in[15:8];
    wire [7:0] blue =  vid_pData_in[23:16];
    wire [7:0] red_delay;

    
    bus_delay_shiftreg red_delay_module(
    .inputbus(red),
    .clk(pxclk),
    .outputbus(red_delay)
    );
    
    
    always @ (vid_pData_in, mode) begin
        case (mode)
            4'b0000  ://normal
                begin
                     vid = {blue,green,red_delay};
                end
            4'b0001  ://invert
                begin
                     vid = {~blue,~green,~red};
                end
            4'b0010  ://colur swap
                begin
                     vid = {green,red, blue};
                end
            4'b0011  ://colour swap invert
                begin
                     vid = {~blue,green,~red};
                end
            4'b0100  ://bit mash1
                begin
                     vid = {green^red,red, blue^green};
                end
            4'b0101  ://bit mash2
                begin
                     vid = {~red,red&green, blue^green};
                end
            4'b0111  ://posterise 50% // bad method
                begin
                     vid = {red & 8'b11110000,green& 8'b11110000, blue& 8'b11110000};
                end
                
            4'b1000  ://posterise 70%
                begin
                     vid = {red & 8'b11000000,green& 8'b11000000, blue& 8'b11000000};
                end
                
            4'b1001  ://simple key R //dsnt work i think
                begin
                    if(red > 8'b00001111)
                        begin
                            vid = {red,green, blue};
                        end
                   else 
                        begin
                            vid = {8'b00000000,8'b00000000,8'b00000000};
                        end
                    
                end
           4'b1010  ://simple key g
                begin
                    if(green > 8'b00001111)
                        begin
                            vid = {red,green, blue};
                        end
                   else 
                        begin
                            vid = {8'b00000000,8'b00000000,8'b00000000};
                        end
                    
                end
           4'b1010  ://simple key b
                begin
                    if(blue > 8'b00001111)
                        begin
                            vid = {red,green, blue};
                        end
                   else 
                        begin
                            vid = {8'b00000000,8'b00000000,8'b00000000};
                        end
                    
                end

                
            
            default :  
                begin
                     vid = {blue,green,red};
                end
            
        endcase
        
        
    end
    
    assign vid_pData_out = vid;
    
endmodule
