`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 22:34:28
// Design Name: 
// Module Name: B_ram_read
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


module B_ram_read(clk,A,clk_out,seg);
wire read,ena; 
assign read =0,ena =1; //Values to set Enable Block Ram, and in Read Mode
input clk; //Input Clock
reg [13:0] aA = 0; //Address Register
reg [7:0] inA = 0; //Register for Input(Not Needed in Implementation)
wire [8:0] outA; //To take in the value at the current address
reg [783:0] pixels; //To take in Pixels of Image
reg [17:0] s [9:0]; //Summation of weighted Inputs of Layer 1
reg [25:0] f [9:0]; //Summation of weighted Inputs of Layer 2
output reg [3:0] A = 0; //Detected number
output reg [6:0] seg = 0; //Seven Segment equivalent of the detected number
reg [25:0] max; //To calculate the max value in Layer 2(Number Detected) 
initial
begin
s[0] = -197;
s[1] = 130;
s[2] = -144;
s[3] = 73;
s[4] = 136;
s[5] = -94;
s[6] = 142;
s[7] = 37;
s[8] = 111;
s[9] = -39;
f[0] = -9700;
f[1] = 16800;
f[2] = 2200;
f[3] = -27100;
f[4] = 3700;
f[5] = 34700;
f[6] = -1580;
f[7] = 32800;
f[8] = -12600;
f[9] = -7500; //Initializing the biase values of each node of both layers
end
output clk_out;
parameter W = 24; 
parameter N = 40;
reg [W-1:0] r_reg = 0;
wire [W-1:0] r_nxt;
reg clk_track = 0;
// The following is the clock divider logic
always @(posedge clk)
 
begin
 
  if (r_nxt == N)
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track;
	   end
 
  else 
      r_reg <= r_nxt;
end
 
assign r_nxt = r_reg+1;   	      
assign clk_out = clk_track;
// Instantiating the BRAM
blk_mem_gen_0 inst1(
.ena(ena),
.clka(clk_out),
.wea(read),
.addra(aA),
.dina(inA),
.douta(outA));
integer i=-2;
integer m;
// Reading the BRAM
always@(posedge clk_out)
begin
if(i<=8724)
begin

if(aA<=8723)
aA = aA + 1;
else
aA = 0;
if(i>=0 && i<=783) // Taking in the pixel values of image
begin
if(outA[7])// Threshold Function
pixels[i] <= 1;
else
pixels[i] <= 0;
end
else if(i>=784 && i<=8623)// Summation of weighted inputs in the first layer
begin
if(outA[8])// Logic to deal with negative numbers
s[(i-784)/784] = s[(i-784)/784] - (512-outA)*pixels[i%784];
else
s[(i-784)/784] = s[(i-784)/784] + outA*pixels[i%784]; // Compressed logic to access each node after 784 values
end

if(i==8624)//Relu Function
begin
for(m=0;m<=9;m=m+1)
begin
if(s[m][17]==1)
s[m]=0;
end
end
if(i>=8624 && i<=8723)// Summation of weighted inputs in the second layer
    begin
    if(s[(i-8624)%10][17])// Logic to deal with negative numbers
        begin
        if(outA[8])
            f[(i-8624)/10] = f[(i-8624)/10] + (512-outA)*(262144-s[(i-8624)%10]);
        else
            f[(i-8624)/10] = f[(i-8624)/10] - outA*(262144-s[(i-8624)%10]);
        end
    else
        begin
        if(outA[8])
            f[(i-8624)/10] = f[(i-8624)/10] - (512-outA)*s[(i-8624)%10];
        else
            f[(i-8624)/10] = f[(i-8624)/10] + outA*s[(i-8624)%10];// Compressed logic to access each node after 10 values
        end
    $display("%d %d %d %d %d %d %d",outA,outA[8],s[(i-8624)%10][17],s[(i-8624)%10],i,(i-8624)/10,f[(i-8624)/10]);
    end
i = i+1; // Counter Increment

$display("%d %d %d %d %d %d %d %d %d %d %d",f[0],f[1],f[2],f[3],f[4],f[5],f[6],f[7],f[8],f[9],seg); 
if(i==8724)// After all addresses have been accessed, checking at the end of calculation
begin
for(m=0;m<=9;m=m+1)
begin
if(f[m][25]==1)// Relu Function
f[m]=0;
end
max = f[0];
for(m=1;m<=9;m=m+1)// Finding Max Value
begin
if(f[m]>max)
begin
max = f[m];
A = m;
end
end
$display("%d",A);
end
case (A)// Logic for seven segment display

0: seg = 64;
1: seg = 121;
2: seg = 36;
3: seg = 48;
4: seg = 25;
5: seg = 18;
6: seg = 2;
7: seg = 120;
8: seg = 0;
9: seg = 16;
endcase
end
end
endmodule


