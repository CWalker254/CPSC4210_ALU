/**
    CPSC 4210 - Fall 2021
    Final Project - ALU
    Christian Walker
*/

// 1-bit 2-to-1 MUX
module MUX2to1_1bit(out, i0, i1, s);
    output out;
    input i0, i1, s;
    wire y0, y1, sBar;
    
    not(sBar, s);
    and(y0, i0, s);
    and(y1, i1, sBar);
    or(out, y0, y1);
endmodule

// 5-bit 2-to-1 MUX
module MUX2to1_5bits(out, i0, i1, s);
    output [4:0] out;
    input [4:0] i0, i1;
    input s;
    
    MUX2to1_1bit m1(out[0], i0[0], i1[0], s);
    MUX2to1_1bit m2(out[1], i0[1], i1[1], s);
    MUX2to1_1bit m3(out[2], i0[2], i1[2], s);
    MUX2to1_1bit m4(out[3], i0[3], i1[3], s);
    MUX2to1_1bit m5(out[4], i0[4], i1[4], s);
endmodule

// Stimulus for 2-to-1 MUX
// module MUX2to1_stimulus;
// 	reg[4:0] i0, i1;
// 	reg s;
// 	wire[4:0] out;

// 	MUX2to1_5bits mux(out, i0, i1, s);
// 	initial
// 	begin
//     	$monitor ($time, " i0 = %d, i1 = %d, s = %b, out = %d,", i0, i1, s, out);
//     	i0 = 5;
//     	i1 = 3;
//     	s = 0;
//     	#5  s = 0;
//     	#5  s = 1;
// 	end
// endmodule

// 32-bit Shifter
module shifter(out, shiftDir, amount, y);
    output [31:0] out;
    input [31:0] y;
    input [4:0] amount;
    input shiftDir;
    
    assign out = (shiftDir ? y << amount : y >> amount);
endmodule

// Stimulus for Shifter
// module shifter_stimulus;
//     reg [31:0] y;
// 	reg [4:0] shiftAmount;
// 	reg shiftDir;
// 	wire [31:0] out;

// 	shifter newShifter(out, shiftDir, shiftAmount, y);
	
// 	initial
// 	begin
//     	$monitor($time, " y = %b,  out = %b, shift direction = %b, shift amount = %b", y, out, shiftDir, shiftAmount);
    
//     	y = 32'b11000000000000000000000000000000; shiftDir = 0; shiftAmount = 5'b00000;
//     	#5 y = 32'b11000000000000000000000000000000; shiftDir = 0; shiftAmount = 5'b00001;
//     	#5 y = 32'b11000000000000000000000000000000; shiftDir = 0; shiftAmount = 5'b00001;
//     	#5 y = 32'b11000000000000000000000000000000; shiftDir = 0; shiftAmount = 5'b00010;
//     	#5 y = 32'b11000000000000000000000000000000; shiftDir = 0; shiftAmount = 5'b00011;
//     	#5 y = 32'b00011000000000000000000000000000; shiftDir = 1; shiftAmount = 5'b00001;
//     	#5 y = 32'b00011000000000000000000000000000; shiftDir = 1; shiftAmount = 5'b00010;
//     	#5 y = 32'b00011000000000000000000000000000; shiftDir = 1; shiftAmount = 5'b00011;
// 	end
// endmodule

// 1-bit Adder
module adder_1bit(sum, cout, x, y, cin);
    output sum, cout;
    input x, y, cin;
    wire y0, y1, y2;
    
    xor(y0, x, y);
    xor(sum, y0, cin);
    and(y1, cin, y0);
    and(y2, x, y);
    or(cout, y1, y2);
endmodule

// 1-bit Adder/Subtractor
module adderSub_1bit(sum, cout, x, y, cin, sub);
    output sum, cout;
    input x, y, cin, sub;
    wire addSub;
    
    xor(addSub, y, sub);
    adder_1bit a1(sum, cout, x, addSub, cin);
endmodule

// 8-bit Adder/Subtractor
module adderSub_8bits(sum, cout, x, y, cin, sub);
    output [7:0] sum;
    output cout;
    input [7:0] x, y;
    input cin, sub;
    wire w1, w2, w3, w4, w5, w6, w7;
    
    adderSub_1bit a1(sum[0], w1, x[0], y[0], cin, sub);
    adderSub_1bit a2(sum[1], w2, x[1], y[1], w1, sub);
    adderSub_1bit a3(sum[2], w3, x[2], y[2], w2, sub);
    adderSub_1bit a4(sum[3], w4, x[3], y[3], w3, sub);
    adderSub_1bit a5(sum[4], w5, x[4], y[4], w4, sub);
    adderSub_1bit a6(sum[5], w6, x[5], y[5], w5, sub);
    adderSub_1bit a7(sum[6], w7, x[6], y[6], w6, sub);
    adderSub_1bit a8(sum[7], cout, x[7], y[7], w7, sub);
endmodule

// 32-bit Adder/Subtractor
module adderSub_32bits(sum, cout, x, y, cin, sub);
    output [31:0] sum;
    output cout;
    input [31:0] x, y;
    input cin, sub;
    wire w1, w2, w3;
    
    adderSub_8bits a1(sum[7:0], w1, x[7:0], y[7:0], cin, sub);
    adderSub_8bits a2(sum[15:8], w2, x[15:8], y[15:8], w1, sub);
    adderSub_8bits a3(sum[23:16], w3, x[23:16], y[23:16], w2, sub);
    adderSub_8bits a4(sum[31:24], cout, x[31:24], y[31:24], w3, sub);
endmodule

// Stimulus for Adder/Subtractor
// module adder_stimulus;
// 	reg [31:0] x, y;
// 	reg cin;
// 	reg sub;
// 	wire[31:0] sum;
// 	wire cout;
	
// 	adderSub_32bits addSub(sum, cout, x, y, cin, sub);
// 	initial
// 	begin
// 		$monitor($time, " x = %d, y = %d, cin = %b, cout = %b, sub = %b, sum = %d", x, y, cin, cout, sub, sum);
// 	end
	
// 	initial
// 	begin
// 		x = 5; 
// 		y = 3;
// 		cin = 0;
// 		sub = 0;
// 		#5 x = 5; y = 5; sub = 1; cin = 1;
// 		#5 x = 20; y = 10; cin = 0;
// 		#5 x = 15; y = 10; sub = 0;
// 		#5 x = 30; y = 30; cin = 1;
// 	end
// endmodule

// 1-bit Logic Unit
module logicUnit_1bit(out, x, y, logicFunc);
    output out;
    input [1:0] logicFunc;
    input x, y;
    wire w0, w1, w2, w3;
    
    and(w0, x, y);
    or(w1, x, y);
    xor(w2, x, y);
    nor(w3, x, y);
    
    MUX4to1_1bit m1(out, w0, w1, w2, w3, logicFunc[0], logicFunc[1]);
endmodule

// 8-bit Logic Unit
module logicUnit_8bits(out, x, y, logicFunc);
    output [7:0] out;
    input [7:0] x, y;
    input [1:0] logicFunc;
    
    logicUnit_1bit l1(out[0], x[0], y[0], logicFunc);
    logicUnit_1bit l2(out[1], x[1], y[1], logicFunc);
    logicUnit_1bit l3(out[2], x[2], y[2], logicFunc);
    logicUnit_1bit l4(out[3], x[3], y[3], logicFunc);
    logicUnit_1bit l5(out[4], x[4], y[4], logicFunc);
    logicUnit_1bit l6(out[5], x[5], y[5], logicFunc);
    logicUnit_1bit l7(out[6], x[6], y[6], logicFunc);
    logicUnit_1bit l8(out[7], x[7], y[7], logicFunc);
endmodule

// 32-bit Logic Unit
module logicUnit_32bits(out, x, y, logicFunc);
    output [31:0] out;
    input [31:0] x, y;
    input [1:0] logicFunc;
    
    logicUnit_8bits l1(out[7:0], x[7:0], y[7:0], logicFunc);
    logicUnit_8bits l2(out[15:8], x[15:8], y[15:8], logicFunc);
    logicUnit_8bits l3(out[23:16], x[23:16], y[23:16], logicFunc);
    logicUnit_8bits l4(out[31:24], x[31:24], y[31:24], logicFunc);
endmodule

// Stimulus for Logic Unit
// module logicUnit_stimulus;
// 	reg[31:0] x, y;
// 	reg[1:0] s;
// 	wire[31:0] out;

// 	logicUnit_32bits logicUnit(out[31:0], x, y, s);

// 	initial
// 	begin
//     	$monitor ($time, " x = %b, y = %b, s = %b, out = %b", x, y, s, out);
//     	x = 32'd17; 
//     	y = 32'd15;
//     	s = 2'b 00;
//     	#5  s = 2'b 01;
//     	#5  s = 2'b 10;
//     	#5  s = 2'b 11;
// 	end
// endmodule

// 1-bit 4 to 1 MUX
module MUX4to1_1bit(out, i0, i1, i2, i3, s0, s1);
    output out;
    input i0, i1, i2, i3, s0, s1;
    wire s0n, s1n, y0, y1, y2, y3;
    
    not(s0n, s0);
    not(s1n, s1);
    and(y0, i0, s0n, s1n);
    and(y1, i1, s0, s1n);
    and(y2, i2, s0n, s1);
    and(y3, i3, s0, s1);
    or(out, y0, y1, y2, y3);
endmodule

// 8-bit 4 to 1 MUX
module MUX4to1_8bits(out, i0, i1, i2, i3, s);
    output [7:0] out;
    input [7:0] i0, i1, i2, i3;
    input [1:0] s;
    
    MUX4to1_1bit m1(out[0], i0[0], i1[0], i2[0], i3[0], s[0], s[1]);
    MUX4to1_1bit m2(out[1], i0[1], i1[1], i2[1], i3[1], s[0], s[1]);
    MUX4to1_1bit m3(out[2], i0[2], i1[2], i2[2], i3[2], s[0], s[1]);
    MUX4to1_1bit m4(out[3], i0[3], i1[3], i2[3], i3[3], s[0], s[1]);
    MUX4to1_1bit m5(out[4], i0[4], i1[4], i2[4], i3[4], s[0], s[1]);
    MUX4to1_1bit m6(out[5], i0[5], i1[5], i2[5], i3[5], s[0], s[1]);
    MUX4to1_1bit m7(out[6], i0[6], i1[6], i2[6], i3[6], s[0], s[1]);
    MUX4to1_1bit m8(out[7], i0[7], i1[7], i2[7], i3[7], s[0], s[1]);
endmodule

// 32-bit 4 to 1 MUX
module MUX4to1_32bits(out, i0, i1, i2, i3, s);
    output [31:0] out;
    input [31:0] i0, i1, i2, i3;
    input [1:0] s;
    
    MUX4to1_8bits m1(out[7:0], i0[7:0], i1[7:0], i2[7:0], i3[7:0], s);
    MUX4to1_8bits m2(out[15:8], i0[15:8], i1[15:8], i2[15:8], i3[15:8], s);
    MUX4to1_8bits m3(out[23:16], i0[23:16], i1[23:16], i2[23:16], i3[23:16], s);
    MUX4to1_8bits m4(out[31:24], i0[31:24], i1[31:24], i2[31:24], i3[31:24], s);
endmodule

// Stimulus for 4-to-1 MUX
// module MUX4to1_stimulus;
// 	reg[31:0] i0, i1, i2, i3;
// 	reg[1:0] s;
// 	wire[31:0] out;

// 	MUX4to1_32bits mux (out, i0, i1, i2, i3, s);

// 	initial
// 	begin
//     	$monitor ($time, " i0 = %d, i1 = %d, i2 = %d, i3 = %d, s = %b, out = %d", i0, i1, i2, i3, s, out);
//     	i0 = 1;
//     	i1 = 2;
//     	i2 = 3;
//     	i3 = 4;
//     	s = 2'b 00;
//     	#5  s = 2'b 00;
//     	#5  s = 2'b 01;
//     	#5  s = 2'b 10;
//     	#5  s = 2'b 11;
// 	end
// endmodule

// 32-bit ALU
module ALU_32bits (output [31:0] s, 
                    input [31:0] a, b, 
                    input c_0, 
                    input Const_Var, shift_direction, 
                    input [1:0] Function_class, 
                    input [1:0] Logic_function,
                    input [4:0] Const_amount);
    wire[31:0] shiftWire, addSubWire, logicWire;
    wire[4:0] amountWire;
    wire cout;
    
    MUX2to1_5bits mux_5(amountWire, a[4:0], Const_amount, Const_Var);
    shifter shifter_32(shiftWire, shift_direction, amountWire, b);
    logicUnit_32bits logic_32(logicWire, a, b, Logic_function);
    adderSub_32bits addSub_32(addSubWire, cout, a, b, c_0, c_0);
    MUX4to1_32bits mux_32(s, shiftWire, {31'd0, addSubWire[31]}, addSubWire, logicWire, Function_class);
endmodule

// Stimulus for ALU
// module stimulus();
// 	reg [31:0] a;
// 	reg [31:0] b;
// 	reg [1:0] Function_class;
// 	reg [1:0] Logic_function;
// 	reg [4:0] Const_amount;
// 	reg c_0;
// 	reg Const_Var;
// 	reg shift_direction;
// 	wire [31:0] s;

// 	ALU_32bits my_ALU (s,  a, b,  c_0, Const_Var, shift_direction, Function_class, Logic_function, Const_amount);

// 	initial
// 	begin
// 		$monitor($time, " a = %d, b = %d, c_0 = %b, Const_Var = %b, Const_amount = %d, shift_direction = %b, Logic_function = %b, Function_class = %b, s = %d", a, b, c_0, Const_Var, Const_amount, shift_direction, Logic_function, Function_class, s);
		
// 		// Shift Functions
// 		#5 Function_class = 2'b00; a = 5; b = 15; shift_direction = 1; Const_Var = 1;  // Shift left by 5 bits
// 		#5 a = 0; b = 32; shift_direction = 0; Const_Var = 0; Const_amount = 2;  // Shift right by 2 bits
		
// 		// Set Less Functions
// 		#5 Function_class = 2'b01; a = 5; b = 10; c_0 = 1;  // a less than b
// 		#5 a = 10; b = 5;  // a greater than b
		
// 		// Arithmetic Functions
// 		#5 Function_class = 2'b10; a = 5; b = 5; c_0 = 0;  // Addition: 5 + 5 = 10
// 		#5 a = 10; b = 5; c_0 = 1;  // Subtraction: 10 - 5 = 5;
		
// 		// Logic Functions
// 		#5 Function_class = 2'b11; Logic_function = 2'b00; a = 1'b0; b = 1'b1;  // AND
// 		#5 Logic_function = 2'b01; a = 1'b0; b = 1'b1;  // OR
// 		#5 Logic_function = 2'b10; a = 1'b1; b = 1'b0;  // XOR
// 		#5 Logic_function = 2'b11; a = 1'b1; b = 1'b1;  // NOR
// 	end
// endmodule

// The ALU module name and orders of inputs, outputs should be same as the ALU module in the following
// H. Li

module stimulus;

//inputs
reg[31:0] A,B;
reg C_0,Const_Var,shift_direction;
reg [1:0] Function_class;
reg [1:0] Logic_function;
reg [4:0] Const_amount; 


//outputs
wire[31:0] s;



ALU_32bits my_ALU (s,  A, B,  C_0, Const_Var, shift_direction, Function_class, Logic_function, Const_amount);

 

initial  
begin 

$monitor($time,"A=%d, B=%d, C_IN=%b,-- Function_class=%d, shift_direction=%b, Const_Var=%b, Const_amount=%d, shift_direction=%b, Logic_function=%d,--OUTPUT=%d \n",A,B,C_0,Function_class,shift_direction,Const_Var,Const_amount,shift_direction,Logic_function,s);
end

initial
begin
A=4'd0; B=4'd0; C_0=1'b0;
#5 A=8'd19; B=8'd55; Function_class[1]=1; Function_class[0]=0;  
#5 A=8'd59; B=8'd38;C_0=1'b1; Function_class[1]=0; Function_class[0]=1;  
#5 A=8'd39; B=8'd136; C_0=1'b1;  Function_class[1]=1; Function_class[0]=0; 
#5 A=16'd9; B=16'd112; Function_class[1]=0; Function_class[0]=0; shift_direction=1; Const_Var=1; 

#5 A=16'd129; B=16'd456;Function_class[1]=0; Function_class[0]=0;shift_direction=0;Const_Var=0;Const_amount=5'd7;  
#5 A=16'd656; B=8'd218; C_0=1'b0;Function_class[1]=1; Function_class[0]=1;Logic_function=2'd0;  
#5 A=8'd195; B=8'd228; C_0=1'b1;Function_class[1]=1; Function_class[0]=1;Logic_function=2'd1; 
#5 A=8'd99; B=16'd286; C_0=1'b1;Function_class[1]=1; Function_class[0]=1;Logic_function=2'd2; 
#5 A=8'd77; B=16'd486; C_0=1'b0;Function_class[1]=1; Function_class[0]=1;Logic_function=2'd3; 
end

endmodule



