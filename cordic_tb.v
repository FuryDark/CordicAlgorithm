`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Mandi
// Engineer: Jasnoor Tiwana
// 
// Create Date: 05/14/2025 12:48:57 PM
// Design Name: 
// Module Name: cordic_tb
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


module cordic_tb #(parameter N=16, //number of iterations
                   parameter A1=-100.86, // start angle (keep it smaller than A2) in degrees
                   parameter A2=1000.75 // stop angle in degrees
    );
    reg clk;  //clock for the CORDIC circuit
    reg start;    // to start the calculations
    reg [15:0] angle; // 2 bits for integer and 14 for the floating
    wire [15:0] sint;  // 16 bit sin output (2.14 format)
    wire [15:0] cost;  // 16 bit cos output (2.14 format)
    wire done; //goes 1 whenver N iteraions are done

cordic #(.N(N)) uut(
    .clk(clk),
    .start(start),
    .angle(angle),
    .sint(sint),
    .cost(cost),
    .done(done)
    );
real deg;
integer i,j,wrapped_angle;
integer file;

initial clk = 0;
initial start = 1;
always#0.5 clk = ~clk;

function [15:0] deg_to_q214; // converts angle in degrees to angle in 2.14 hex format
        input real degrees;
        real radians;
        begin
            radians = degrees * 3.141592653589793 / 180.0;
            deg_to_q214 = $rtoi(radians * (1 << 14)); end
endfunction

function real q214_to_real; // converts 2.14 hex to real numbers
    input [15:0] fixed;
    begin
        q214_to_real = $signed(fixed) / 16384.0;
    end
endfunction

initial begin
    file = $fopen("C:/Users/jasno/Desktop/cordic_output.csv", "w");
    $fwrite(file, "Angle (deg), Sine (Q2.14), Cosine (Q2.14), Sine, Cosine\n");
    //$display("================================== CORDIC Output ==================================");
    for (i = A1; i <= A2; i = i + 1) begin
        wrapped_angle = i % 360;
            if (wrapped_angle > 180)
                wrapped_angle = wrapped_angle - 360;
            else if (wrapped_angle < -180)
                wrapped_angle = wrapped_angle + 360;
        j = wrapped_angle;
        if (j >= -180 && j <= -91) begin
            deg = i;
            angle = deg_to_q214(180 + j);
            start = 1; #3 start = 0;
            wait (done);
            
            $fwrite(file, "%0.1f,0x%04h,0x%04h,%0.5f,%0.5f\n", deg, -sint, -cost, q214_to_real(-sint), q214_to_real(-cost));
            //$display("Iterations = %0.1d", N);
            //$display("Angle = %0.1f deg | Sine = %0.5f | Cosine = %0.5f", deg, q214_to_real(-sint), q214_to_real(-cost));
            //$display("Angle = 0x%04h rad | Sine = 0x%04h | Cosine = 0x%04h", angle, -sint, -cost);
            //$display("===================================================================================");
            #10; end
        else if (j >= -90 && j <= -1) begin
            deg = i;
            angle = deg_to_q214(j);
            start = 1; #3 start = 0;
            wait (done);
            
            $fwrite(file, "%0.1f,0x%04h,0x%04h,%0.5f,%0.5f\n", deg, sint, cost, q214_to_real(sint), q214_to_real(cost));
            //$display("Iterations = %0.1d", N);
            //$display("Angle = %0.1f deg | Sine = %0.5f | Cosine = %0.5f", deg, q214_to_real(sint), q214_to_real(cost));
            //$display("Angle = 0x%04h rad | Sine = 0x%04h | Cosine = 0x%04h", angle, sint, cost);
            //$display("===================================================================================");
            #10; end
        else if (j >= 0 && j <= 89) begin
            deg = i;
            angle = deg_to_q214(j);
            start = 1; #3 start = 0;
            wait (done);
            
            $fwrite(file, "%0.1f,0x%04h,0x%04h,%0.5f,%0.5f\n", deg, sint, cost, q214_to_real(sint), q214_to_real(cost));
            //$display("Iterations = %0.1d", N);
            //$display("Angle = %0.1f deg | Sine = %0.5f | Cosine = %0.5f", deg, q214_to_real(sint), q214_to_real(cost));
            //$display("Angle = 0x%04h rad | Sine = 0x%04h | Cosine = 0x%04h", angle, sint, cost);
            //$display("===================================================================================");
            #10; end
        else if (j >= 90 && j <= 179) begin
            deg = i;
            angle = deg_to_q214(180 - j);
            start = 1; #3 start = 0;
            wait (done);
            
            $fwrite(file, "%0.1f,0x%04h,0x%04h,%0.5f,%0.5f\n", deg, sint, -cost, q214_to_real(sint), q214_to_real(-cost));
            //$display("Iterations = %0.1d", N);
            //$display("Angle = %0.1f deg | Sine = %0.5f | Cosine = %0.5f", deg, q214_to_real(sint), q214_to_real(-cost));
            //$display("Angle = 0x%04h rad | Sine = 0x%04h | Cosine = 0x%04h", angle, sint, -cost);
            //$display("===================================================================================");
            #10; end end
   
    //$display("======== All angles processed ========");
    $fclose(file);
    $finish; end
endmodule