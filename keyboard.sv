module Keyboard(
 input logic clk,
 input logic rst,
 input logic kdata,
 input logic kclock,
 output logic hsync,
 output logic vsync,
 output logic [3:0]red,
 output logic [3:0]green,
 output logic [3:0]blue );

logic clk_25;
logic[9:0] x_count,y_count;

always_ff @(posedge clk)
begin
if (!rst)
	clk_25 <= 0;
else
	if (clk_25)
		clk_25 <= 0;
	else
		clk_25 <= 1;
end	 
 
 
//count x_count for pixels
always_ff @(posedge clk)
begin
if (!rst)
	x_count <= 0;
else
	if (clk_25)
		if(x_count==799) 
			x_count <= 0;
		else
			x_count <= x_count + 1;	
end

//counter y_count for rows
always_ff @(posedge clk)
begin
if (!rst)
	y_count <= 0;
else
	if (clk_25)
		if (x_count==799)
			if(y_count==523)
				y_count <= 0;
			else
				y_count <= y_count + 1;
end

//h_sync
always_comb
begin
if (x_count >= 656 && x_count < 754)
	hsync = 0;
else
	hsync = 1;
end

//v_sync
always_comb
begin
if (y_count >=490 && y_count < 492)
	vsync = 0;
else
	vsync = 1;
end

// synchronize

logic sync1,sync2,sync3;

always_ff @(posedge clk)
begin
 if (!rst)
   sync1 <= 0;
 else 
   sync1 <= kclock;
 end

always_ff @ ( posedge clk)
begin
 if (!rst)
  sync2 <= 0;
 else
  sync2 <= sync1;
end

always_ff @(posedge clk)
begin
 if (!rst)
  sync3 <= 0;
 else
  sync3 <= sync2;
end

assign rising_edge = (sync2 & !sync3);
assign falling_edge = (!sync2 & sync3);

logic bit0,bit1,bit2,bit3,bit4,bit5,bit6,bit7,bit8,bit9,bit10;

//create 11 flip flops to keep the price of 11 input bits
always_ff @ (posedge clk)
begin
if (!rst)
 bit0 <=0;
else
 if (falling_edge == 1) 
   bit0<=kdata;
end   

always_ff @ (posedge clk)
begin
if (!rst)
 bit1 <=0;
else
 if (falling_edge == 1) 
   bit1<=bit0;
end   
 
always_ff @ (posedge clk)
begin
if (!rst)
  bit2 <=0;
else
 if (falling_edge == 1) 
  bit2<=bit1;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit3 <=0;
else
 if (falling_edge == 1) 
   bit3<=bit2;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit4 <=0;
else
 if (falling_edge == 1) 
   bit4<=bit3;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit5 <=0;
else
 if (falling_edge == 1) 
   bit5<=bit4;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit6 <=0;
else
 if (falling_edge == 1) 
   bit6<=bit5;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit7 <=0;
else
 if (falling_edge == 1) 
   bit7<=bit6;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit8 <=0;
else
 if (falling_edge == 1) 
   bit8<=bit7;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit9 <=0;
else
 if (falling_edge == 1) 
   bit9<=bit8;
end

always_ff @ (posedge clk)
begin
if (!rst)
 bit10 <=0;
else
 if (falling_edge == 1) 
   bit10<=bit9;
end


//create a counter to know when has passed 11 cycles clock

logic [3:0]sum ;
always_ff @(posedge clk)
begin
 if (!rst)
   sum<=0;
 else  
   if (falling_edge)
     if (sum == 10)
       sum <=0;
     else 
       sum <= sum +1;	 
end

//check the numbet of acces

logic [3:0]sum_par ;
always_ff @ (posedge clk)
begin
if (!rst)
 sum_par=0;
else
 if (sum >= 2 && sum <= 10)
   if (kdata == 1)
     sum_par=sum_par +1 ;
end


// paint red the VGA when "R" come from keyboard	 
 
always_comb
begin
if (sum == 11) begin
 //if (sum_par == 1 || sum_par == 3 || sum_par == 5 || sum_par == 7 || sum_par ==9) begin // check the parity of input
   if (!bit9 && bit8 && bit7 && bit6 && !bit5 && bit4 && !bit3 && !bit2) begin  // the combination of bits for "R"
     if(x_count<640 && y_count<480) begin
        red=4'b1111;
        green=4'b0000;
        blue=4'b0000;
	end
     else begin
        red=4'b0000;
        green=4'b0000;
        blue=4'b0000;
	 end
  end	 
  else begin
        red=4'b0000;
        green=4'b0000;
        blue=4'b0000;
	 end
	end
 else begin
        red=4'b0000;
        green=4'b0000;
        blue=4'b0000; 
    end
end
else begin
        red=4'b0000;
        green=4'b0000;
        blue=4'b0000;
end
end		
endmodule 