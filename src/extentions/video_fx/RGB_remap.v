`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2021 18:56:10
// Design Name: 
// Module Name: RGB_remap
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


module RGB_remap(
    input [23:0]vid_pData_in, //RGB PIXEL DATA IN
      input pixclk,
      input [3:0] mode, 
      output [23:0] vid_pData_out ////RGB PIXEL DATA OUT
    );
    
    wire [7:0] remap_red_out, remap_green_out, remap_blue_out;
    remapper_rom r_map(.clka(pixclk),.ena(1'b1),.addra({mode[1:0], vid_pData_in[7:0]}),.douta(remap_red_out));
    remapper_rom g_map(.clka(pixclk),.ena(1'b1),.addra({mode[1:0], vid_pData_in[15:8]}),.douta(remap_green_out));
    remapper_rom b_map(.clka(pixclk),.ena(1'b1),.addra({mode[1:0], vid_pData_in[23:16]}),.douta(remap_blue_out));
    
    reg [23:0] remap_rgb_out;
    reg [23:0] video_out_bypass;
    reg [23:0] video_out;
    
    always @(posedge pixclk) begin
        if(mode[3]) begin //Bypass ROM
            video_out_bypass = video_out;
        end
        else begin
            video_out_bypass = vid_pData_in;
        end
        
        if(mode[2]) begin //Invert output
            video_out = !remap_rgb_out;
        end
        else begin
            video_out = {remap_blue_out,remap_green_out,remap_red_out};
        end
    end
    
    assign vid_pData_out = video_out_bypass;
    
endmodule
