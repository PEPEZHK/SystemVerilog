`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 15:02:23
// Design Name: 
// Module Name: secundomer21
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
    logic [25:0] c;
    
    always @(posedge clk) 
    begin
            c <= c + 1;
            if (c == 26'h5F5E100) 
            begin
                c <= 0;
                clk_1sec <= ~clk_1sec;
            end
    end
assign led = clk_1sec ;
endmodule

module secundomer21(
    input logic load ,
    input logic enable ,
    input logic clock ,
    input logic [3:0] digit0 ,
    input logic [3:0] digit1 ,
    output reg [3:0] anodes ,
    output logic [6:0]seg 
    );
logic [1:0]index ;
logic [13:0]counter ; 
logic [3:0] one ;
logic [3:0] ten ;
logic [3:0] hun ;
logic [3:0] tho ;
logic [19:0]refresh ;
wire clk ;
slowClock(clock , clk) ;

      
always_ff @(posedge clk)
begin 
if (enable)
begin 

end
end
  
always_ff @(posedge clock)
refresh = refresh + 1 ;

assign index = refresh[19:18] ;
logic [3:0]led ;
always @(*)
begin 
    case(index)
    0 : begin anodes <= 4'b1110 ; led <= counter%10 ; end
    1 : begin anodes <= 4'b1101 ; led <= counter%100/10 ; end
    2 : begin anodes <= 4'b1011 ; led <= counter%1000/100 ; end
    3 : begin anodes <= 4'b0111 ; led <= counter/1000 ; end
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
