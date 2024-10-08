`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 14:12:52
// Design Name: 
// Module Name: secundomer
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
module slowClock(input logic clk, output logic led);
    logic clk_1sec ; 
    logic [25:0] counter;
    
    always @(posedge clk) 
    begin
            counter <= counter + 1;
            if (counter == 26'h5F5E100) 
            begin
                counter <= 0;
                clk_1sec <= ~clk_1sec;
            end
    end
assign led = clk_1sec ;
endmodule

module secundomer(
    input logic enable ,
    input logic load ,
    input logic clock,
    input logic [3:0] digit0 ,
    input logic [3:0] digit1 ,
    input logic [3:0] digit2 ,
    input logic [3:0] digit3 ,
    output reg [3:0] anodes ,
    output logic [6:0]seg 
    );
logic [3:0] one ;
logic [3:0] ten ;
logic [3:0] hun ;
logic [3:0] tho ;
logic [1:0]index ;
logic [19:0]refresh ;
wire clk ;
slowClock(clock , clk) ;
always_ff @(posedge clk)
begin
if (enable)
    begin 
        if (load)
        begin 
            one <= digit0 ;
            ten <= digit1 ;
            hun <= digit2 ;
            tho <= digit3 ;
        end
        else 
        begin
            if (one == 4'b1001)
            begin
                one <= 0 ;
                ten <= ten + 1 ;
                if (ten == 4'b1001)
                begin
                    ten <= 0 ;
                    hun <= hun + 1 ;
                    if (hun == 4'b1001)
                    begin 
                        hun <= 0 ;
                        tho <= tho + 1 ;
                    end
                end
            end
            one <= one + 1 ;
        end
    end
end

always_ff @(posedge clock)
refresh = refresh + 1 ;

assign index = refresh[19:18] ;
logic [3:0]led ;
always @(*)
begin 
    case(index)
    0 : begin anodes <= 4'b1110 ; led <= one ; end
    1 : begin anodes <= 4'b1101 ; led <= ten ; end
    2 : begin anodes <= 4'b1011 ; led <= hun ; end
    3 : begin anodes <= 4'b0111 ; led <= tho ; end
    endcase 
end
always @(*)
begin 
    case(led)
    0 : seg = 7'b0000001;
    1 : seg = 7'b1001111;
    2 : seg = 7'b0010010;
    3 : seg = 7'b0000110;
    4 : seg = 7'b1001100;
    5 : seg = 7'b0100100;
    6 : seg = 7'b0100000;
    7 : seg = 7'b0001111;
    8 : seg = 7'b0000000;
    9 : seg = 7'b0000100;
    default : seg = 7'b0000001; 
    endcase
end
endmodule
