// Adapted from (c) fpga4fun.com & KNJN LLC 2013, and updated to SVGA (800x600) from 640X480 and from sparten 6 to series 7

////////////////////////////////////////////////////////////////////////
module HDMI_test(
	input sys_clk, sw1,  // 40MHz SVGA
	input Video_active,
	input [23:0]video_in,
	output [2:0] TMDSp, TMDSn,
	output TMDSp_clock, TMDSn_clock,
	output led0, 
	output hSync_out, vSync_out
	
	///Simulation outputs
//	output pixclk_s,hSync_s, vSync_s,
//	output [7:0] r_s, g_s, b_s

);

////////////////////////////////////////////////////////////////////////
reg [10:0] CounterX = 11'b00000000000; //define inital content for simulation to work
reg [10:0] CounterY = 11'b00000000000; //define inital content for simulation to work
reg hSync = 1'b0, vSync = 1'b0, DrawArea = 1'b0;
wire pixclk;
always @(posedge pixclk) DrawArea <= (CounterX<800) && (CounterY<600) && Video_active;

always @(posedge pixclk) CounterX <= (CounterX==1055) ? 0 : CounterX+1;
always @(posedge pixclk) if(CounterX==1055) CounterY <= (CounterY==627) ? 0 : CounterY+1;

always @(posedge pixclk) hSync <= (CounterX>=840) && (CounterX<968);
always @(posedge pixclk) vSync <= (CounterY>=601) && (CounterY<605);

////////////////
wire [7:0] W = {8{CounterX[7:0]==CounterY[7:0]}};
wire [7:0] A = {8{CounterX[7:5]==3'h2 && CounterY[7:5]==3'h2}};
reg [7:0] red, green, blue;
//always @(posedge pixclk) red <= ({CounterX[5:0] & {6{CounterY[4:3]==~CounterX[4:3]}}, 2'b00} | W) & ~A;
//always @(posedge pixclk) green <= (CounterX[7:0] & {8{CounterY[6]}} | W) & ~A;
//always @(posedge pixclk) blue <= CounterY[7:0] | W | A;
always @(posedge pixclk) red <= video_in[23:16];
always @(posedge pixclk) green <= video_in[15:8];
always @(posedge pixclk) blue <= video_in[7:0];

//////////////////////////////////////////////////////////////////////// 
wire [9:0] TMDS_red, TMDS_green, TMDS_blue;
TMDS_encoder encode_R(.clk(pixclk), .VD(red  ), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .VD(green), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .VD(blue ), .CD({vSync,hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));

//////////////////////////////////////////////////////////////////////// Seris 7 doesnt support DCM_sp, its replaced by clock wiz
wire clk_TMDS, DCM_TMDS_CLKFX;  // 25MHz x 10 = 250MHz
//DCM_SP #(.CLKFX_MULTIPLY(10)) DCM_TMDS_inst(.CLKIN(pixclk), .CLKFX(DCM_TMDS_CLKFX), .RST(1'b0));
//BUFG BUFG_TMDSp(.I(DCM_TMDS_CLKFX), .O(clk_TMDS));

////////////////////////////////////////////////////////////////////////
reg [3:0] TMDS_mod10=0;  // modulus 10 counter
reg [9:0] TMDS_shift_red=0, TMDS_shift_green=0, TMDS_shift_blue=0;
reg TMDS_shift_load=0;
always @(posedge clk_TMDS) TMDS_shift_load <= (TMDS_mod10==4'd9);

always @(posedge clk_TMDS)
begin
	TMDS_shift_red   <= TMDS_shift_load ? TMDS_red   : TMDS_shift_red  [9:1];
	TMDS_shift_green <= TMDS_shift_load ? TMDS_green : TMDS_shift_green[9:1];
	TMDS_shift_blue  <= TMDS_shift_load ? TMDS_blue  : TMDS_shift_blue [9:1];	
	TMDS_mod10 <= (TMDS_mod10==4'd9) ? 4'd0 : TMDS_mod10+4'd1;
end

OBUFDS OBUFDS_red  (.I(TMDS_shift_red  [0]), .O(TMDSp[2]), .OB(TMDSn[2]));
OBUFDS OBUFDS_green(.I(TMDS_shift_green[0]), .O(TMDSp[1]), .OB(TMDSn[1]));
OBUFDS OBUFDS_blue (.I(TMDS_shift_blue [0]), .O(TMDSp[0]), .OB(TMDSn[0]));
OBUFDS OBUFDS_clock(.I(pixclk), .O(TMDSp_clock), .OB(TMDSn_clock));


 clk_wiz_0 clk125_25(
.clk_out1(pixclk), .clk_out2(clk_TMDS), .resetn(sw1),.locked(), .clk_in1(sys_clk)

);

assign led0 = pixclk;
assign hSync_out = hSync;
assign vSync_out = vSync;
//assign pixclk_s = pixclk;

//assign r_s = red;
//assign g_s = green;
//assign b_s = blue;



endmodule


////////////////////////////////////////////////////////////////////////
module TMDS_encoder(
	input clk,
	input [7:0] VD,  // video data (red, green or blue)
	input [1:0] CD,  // control data
	input VDE,  // video data enable, to choose between CD (when VDE=0) and VD (when VDE=1)
	output reg [9:0] TMDS = 0
);

wire [3:0] Nb1s = VD[0] + VD[1] + VD[2] + VD[3] + VD[4] + VD[5] + VD[6] + VD[7];
wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && VD[0]==1'b0);
wire [8:0] q_m = {~XNOR, q_m[6:0] ^ VD[7:1] ^ {7{XNOR}}, VD[0]};

reg [3:0] balance_acc = 0;
wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
wire balance_sign_eq = (balance[3] == balance_acc[3]);
wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
wire [3:0] balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
wire [3:0] balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule


////////////////////////////////////////////////////////////////////////




