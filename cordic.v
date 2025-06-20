`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Mandi
// Engineer: Jasnoor Tiwana
// 
// Create Date: 05/13/2025 10:01:22 PM
// Design Name: 
// Module Name: cordic
// Project Name: cordic algorithm
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


module cordic #(parameter N = 16)(
        input clk,  //clock for the CORDIC circuit
        input start,    // to start the calculations
        input [15:0] angle, // 2 bits for integer and 14 for the floating
        output reg [15:0] sint,  // 8 bit sin output
        output reg [15:0] cost,  // 8 bit cos output
        output reg done //done goes to 1 when all iterations are done
);

reg signed [15:0] x, y, z; // CORDIC registers
reg signed [15:0] x_temp, y_temp, z_temp;  // CORDIC registers
reg [15:0] angle_table [0:15]; // predefined angles
reg [15:0] iteration; // no. of iterations
reg [1:0] state;

integer i;
localparam CORDIC_GAIN = 16'h26DD;  // 0.60725 * 2^14
localparam  IDLE = 2'b00, // idle state
            ROTATE = 3'b01, // rotate anticlock or clock
            DONE = 3'b10; // done

always @(posedge clk) begin
    case(state)
        IDLE: begin
            if (start) begin
                x <= 16'h26DD;
                y <= 16'h0000;
                z <= angle;
                iteration <= 0;
                done <= 0;
                state <= ROTATE; end end
                
        ROTATE: begin
            if (z[15]) begin
                x_temp = x + (y >>> iteration);
                y_temp = y - (x >>> iteration);
                z_temp = z + angle_table[iteration];
                state <= DONE; end
            else begin
                x_temp = x - (y >>> iteration);
                y_temp = y + (x >>> iteration);
                z_temp = z - angle_table[iteration]; end
            iteration = iteration + 1;
            state <= DONE; end
            
        DONE: begin
            x <= x_temp;
            y <= y_temp;
            z <= z_temp;
            if (iteration == N) begin
                cost <= x_temp;
                sint <= y_temp;
                done <= 1;
                state <= IDLE; end
            else
                state <= ROTATE; end
        
        default: begin
            state <= IDLE; end
 
    endcase end
                           
initial begin
    angle_table[0] = 16'h3244; // arctan(2^-0)
    angle_table[1] = 16'h1DAC; // arctan(2^-1)
    angle_table[2] = 16'h0FAE; // arctan(2^-2)
    angle_table[3] = 16'h07F5; // arctan(2^-3)
    angle_table[4] = 16'h03FF; // arctan(2^-4)
    angle_table[5] = 16'h0200; // arctan(2^-5)
    for (i = 6; i < N; i = i+1)
        angle_table[i] = angle_table[i-1]>>>1; end
 
endmodule