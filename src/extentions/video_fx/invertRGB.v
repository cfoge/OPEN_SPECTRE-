`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan
// 
// Create Date: 16.06.2021 17:18:34
// Design Name: invertRGB
// Module Name: invertRGB
// Project Name: DVI Pass 
// Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: Inverts RGB pixel stream
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module invertRGB(
        input [23:0] inputbus, //RGB PIXEL DATA IN
        input en, 
        output [23:0] outputbus ////RGB PIXEL DATA OUT
    );
    
    reg [23:0] outputbus_reg;
    
    always @ (inputbus) begin
     begin
                    if(en) //If en is high, invert RGB
                        begin
                         outputbus_reg =  ~inputbus; 
                        end
                   else 
                        begin
                         outputbus_reg =  inputbus;  
                        end
                    
     end
    end
    
    assign outputbus = outputbus_reg;
    
endmodule
