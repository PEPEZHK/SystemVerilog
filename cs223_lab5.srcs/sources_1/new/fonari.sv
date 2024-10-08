`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 14:12:52
// Design Name: 
// Module Name: fonari
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


module final_state_machine (
    input sa, sb, clock,
    output reg [5:0] out
);
wire clk_one_sec;
slowClock make(clock, clk_one_sec);
wire [2:0] d;
wire [2:0] q;
s_next_logic l1(q[0], q[1], q[2], sa, sb, d[0], d[1], d[2]);
d_flip_flop f1(clk_one_sec, 1'b0, d, q);
output_logic l2(q[0], q[1], q[2], out);

endmodule

module slowClock(input logic clk , output logic led);
reg clk_one_sec;
reg [30:0] counter;
always @(posedge clk)
begin
    counter <= counter + 1 ;
    if (counter == 150_000_000)
    begin
        counter <= 0 ;
        clk_one_sec <= ~clk_one_sec;
    end
end
assign led = clk_one_sec; 
endmodule


module decoder3_to_8(
    input [2:0] in,
    output [7:0] out
);
    reg [7:0] out;

    always @(*) 
    begin
            case (in)
                3'b000: out[0] = 1'b1;
                3'b001: out[1] = 1'b1;
                3'b010: out[2] = 1'b1;
                3'b011: out[3] = 1'b1;
                3'b100: out[4] = 1'b1;
                3'b101: out[5] = 1'b1;
                3'b110: out[6] = 1'b1;
                3'b111: out[7] = 1'b1;
                default: out = 8'b0000_0000;
            endcase
    end
endmodule
module s_next_logic(input logic s0,s1,s2,sa,sb,
output logic s0next, s1next, s2next);
always @(*)
begin
if (sa && sb)
begin end
else if (sa)
begin
s0next <= s1&~s0|(~s1&~s0)&(~s2&1'b0|s2&~sb);
s1next <= s1^s0;
s2next <= ~s0&s1&s2|s0&s1&~s2|~s1&s2;
end
else if (sb)
begin
s0next <= s1&~s0|(~s1&~s0)&(~s2&~sa|s2&1'b0);
s1next <= s1^s0;
s2next <= ~s0&s1&s2|s0&s1&~s2|~s1&s2;
end
else 
begin
s0next <= s1&~s0|(~s1&~s0)&(~s2&~sa|s2&~sb);
s1next <= s1^s0;
s2next <= ~s0&s1&s2|s0&s1&~s2|~s1&s2;
end
end
endmodule

module d_flip_flop(input logic clk,
input logic reset,
input logic [2:0] d,
output logic [2:0] q);
// synchronous reset
always_ff @(posedge clk)
if (reset) q <= 4'b0;
else q <= d;
endmodule

module output_logic(input s0,s1,s2,
output [5:0]out);
    assign out[0] = 1;
    assign out[3] = 1;
    assign out[2] = (s2|~s1|~s0)&(~s2|s1|s0)&(~s2|s1|~s0);
    assign out[1] = (~s2|s1|~s0)&(s2|~s1|~s0);
    assign out[5] = (s2|s1|s0)&(s2|s1|~s0)&(~s2|~s1|~s0);
    assign out[4] = (s2|s1|~s0)&(~s2|~s1|~s0);
endmodule

