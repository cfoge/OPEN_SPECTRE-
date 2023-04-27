`timescale 1ns/10ps

module ycrcb2rgb(clk, ena, y, cr, cb, r, g, b);
	//
	// inputs & outputs
	//
	input        clk;
	input        ena;
	input  [9:0] y, cr, cb;

	output [9:0] r, g, b;
	reg [9:0] r, g, b;


	reg [9:0] dy, dcr, dcb;

	//
	// variables
	//
	reg [22:0] ir, ig, ib;

	//
	// module body
	//
 

	// step 1: Calculate R, G, B
	//
	// Use N.M format for multiplication:
	// R = Y + 1.403Cr = Y + Cr + 0.403Cr
	// R = Y + Cr + 0x19C*Cr
	//
	// G = Y - 0.344Cb - 0.714Cr
	// G = Y - 0x160*Cb - 0x2DB*Cr
	//
	// B = Y + 1.770Cb = Y + Cb + 0.770Cb
	// B = Y + Cb + 0x314*Cb


	// delay y, cr and cb
	always@(posedge clk)
		if (ena)
		begin
			dy  <= #1 y;
			dcr <= #1 cr;
			dcb <= #1 cb;
		end

	// calculate R
	reg [19:0] rm;

	always@(posedge clk)
		if (ena)
		begin
			rm <= #1 10'h19C * cr;

			ir <= #1 ( (dy + dcr) << 10) + rm;
		end

	// calculate G
	reg [19:0] gm1, gm2;

	always@(posedge clk)
		if (ena)
		begin
			gm1 <= #1 10'h160 * cb;
			gm2 <= #1 10'h2DB * cr;

			ig  <= #1 (dy << 10) - (gm1 + gm2);
		end

	// calculate B
	reg [19:0] bm;

	always@(posedge clk)
		if (ena)
		begin
			bm <= #1 10'h314 * cb;

			ib <= #1 ( (dy + dcb) << 10) + bm;
		end

	//
	// step2: check boundaries
	//
	always@(posedge clk)
		if (ena)
		begin
			// check R
			r <= #1 (ir[19:10] & {10{!ir[22]}}) | {10{(!ir[22] && (ir[21] || ir[20]))}};

			// check G
			g <= #1 (ig[19:10] & {10{!ig[22]}}) | {10{(!ig[22] && (ig[21] || ig[20]))}};

			// check B
			b <= #1 (ib[19:10] & {10{!ib[22]}}) | {10{(!ib[22] && (ib[21] || ib[20]))}};
		end
endmodule