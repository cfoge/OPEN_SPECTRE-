`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2021 14:12:21
// Design Name: 
// Module Name: tv_fx
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


module tv_fx(
      input [23:0]vid_pData_in, //RGB PIXEL DATA IN
      input pixclk,
      input hs,
      input vs,
      input [1:0] mode, 
      output [23:0] vid_pData_out ////RGB PIXEL DATA OUT
    );
    
    reg out_clk;
    
    initial begin
        out_clk = 1'b0;
    end
    
    always @ (posedge(hs))   // When will Always Block Be Triggered
begin
        if(vs) begin
        out_clk <= 0;
        end else begin
        out_clk <= ~out_clk;
        end
end
    
    wire [23:0] vid_delay_out;
    reg [23:0] outputVid;
    
    always @ (posedge(pixclk)) begin 
        if(out_clk) begin //
            case (mode)
                2'b00:  outputVid  <= (vid_pData_in); 
                2'b01:  outputVid  <= (vid_pData_in >> 1); 
                2'b10:  outputVid  <= (vid_delay_out); 
                2'b11:  outputVid  <= (vid_delay_out >> 1);  
                      
            endcase
           end else
            
                 outputVid  <= vid_pData_in;
                 
           
    end
    
    assign vid_pData_out = outputVid;
    
    wire [7:0] r_out, g_out, b_out;
    
 bus_delay_shiftreg Rdelay( .inputbus(vid_pData_in[7:0]), .clk(pixclk), .outputbus(r_out) );   
 bus_delay_shiftreg Gdelay( .inputbus(vid_pData_in[15:8]), .clk(pixclk), .outputbus(g_out) );  
 bus_delay_shiftreg Bdelay( .inputbus(vid_pData_in[23:16]), .clk(pixclk), .outputbus(b_out) );  
 
 assign vid_delay_out = {b_out,g_out,r_out};
    
endmodule




