`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 21:45:48
// Design Name: 
// Module Name: secund_tb
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


module secundomer_tb;

    // Parameters
    parameter CLOCK_PERIOD = 10; // Clock period in time units
    
    // Inputs
    logic enable;
    logic load;
    logic clock;
    logic [3:0] digit0;
    logic [3:0] digit1;
    logic [3:0] digit2;
    logic [3:0] digit3;
    
    // Outputs
    reg [3:0] anodes;
    reg [6:0] seg;
    
    // Instantiate secundomer module
    secundomer dut (
        .enable(enable),
        .load(load),
        .clock(clock),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .anodes(anodes),
        .seg(seg)
    );

    // Clock generation
    always #((CLOCK_PERIOD / 2)) clock = ~clock;

    // Initial values
    initial begin
        clock = 0;
        enable = 0;
        load = 0;
        digit0 = 0;
        digit1 = 0;
        digit2 = 0;
        digit3 = 0;
        
        // Stimulus
        #100 enable = 1;
        #100 load = 1;
        #100 load = 0;
        #100;
        #100 digit0 = 4'b0001; digit1 = 4'b0010; digit2 = 4'b0011; digit3 = 4'b0100; // Set digits to 1, 2, 3, 4
        #100 load = 1;
        #100 load = 0;
        #100;
        #100 enable = 0;
        #100;
        #100 enable = 1;
        #100 load = 1;
        #100 load = 0;
        #100;
        #100 digit0 = 4'b0101; digit1 = 4'b0110; digit2 = 4'b0111; digit3 = 4'b1000; // Set digits to 5, 6, 7, 8
        #100 load = 1;
        #100 load = 0;
        #100;
        #100 enable = 0;
        
        // End simulation
        #1000;
        $finish;
    end
    
    // Monitor outputs
    always @(posedge clock) begin
        $display("anodes: %b, seg: %b", anodes, seg);
    end

endmodule

