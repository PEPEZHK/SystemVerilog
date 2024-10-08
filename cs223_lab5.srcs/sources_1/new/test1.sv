`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 20:22:24
// Design Name: 
// Module Name: test1
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


// Code your design here
module digits(
  	input clock,
  	input userInputOne,
  	input userInputTen,
  	input enable,
  	input load,
  output reg [3:0] ones,
  output reg [3:0] tenths

    );
    wire clk ;
    newClock t(clock , clk) ;
  always @(posedge clk) begin
    if (enable) 
      begin
        if (load) 
          begin  
            ones <= userInputOne;
        	end 
      else 
        begin
           
          if (ones == 4'b1001) begin        
                ones <= 0;
          		tenths <= tenths +1;
          end
         
          else 
                ones <= ones + 1;
            
        end
    end
end

    
  always @(posedge clk) begin
    if (enable) 
      begin
        if (load) 
          begin  
            tenths <= userInputTen;
        	end 
      else 
        begin
           
          if (tenths == 4'b1001 && ones == 4'b1001 )begin           
                ones <= 0;
          		tenths <=0;
          end
          
        end
    end
  end
  
endmodule




module newClock(input clk, output reg seconds);


  logic clk_seconds ;
  logic [27:0] count;


  always @(posedge clk)
  begin
    count <= count + 1;
    if (count == 25_000_000)
    begin
      count <= 0;
      clk_seconds <= ~clk_seconds;
    end
  end


  assign seconds = clk_seconds;


endmodule

module top(

  	input clk,
    input enable,
    input load,
    input userInputOne,
    input userInputTen,
    output reg [3:0] digOnes
);

    
  
  digits d(clk, userInputOne, userInputTen,  enable, load, digOnes);

  
endmodule
