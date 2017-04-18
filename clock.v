`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:34:52 04/01/2017 
// Design Name: 
// Module Name:    clock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock(
input wire[0:1] sw,
input clk,
input clr,
input seth,	//设置小时
input setm,	//设置分钟
//下面的output变量都是用来输出显示的
output reg[3:0] an,
output reg[6:0] atog,
output reg[3:0] secondLow,	//秒数个位
output reg[3:0] secondHigh	//秒数十位
);

reg [3:0] hourLow;	//小时个位
reg [3:0] hourHigh;	//小时十位
reg [3:0] minuteLow;//分钟个位
reg [3:0] minuteHigh;//分钟十位
reg [26:0] counter;	//计数器
reg [7:0] hour;		//小时数字
reg [7:0] minute;	//分钟数字
reg [7:0] hourc;	//闹钟小时
reg [7:0] minutec;	//闹钟分钟
reg [7:0] second;	//秒数字
reg [3:0] digit;	//对于的数码管
reg [1:0] s;
integer i;			//用于求余数等时


always@(posedge clk or posedge clr)
begin
if (clr == 1)
	begin
	counter <= 0;
	hourLow <= 0;
	hourHigh <=0;
	minuteLow <= 0;
	minuteHigh <= 0;
	secondLow <= 0;
	secondHigh <= 0;
	hour <= 0;
	minute <= 0;
	second <= 0;
	end
else if(counter == 50000000)
begin
	counter <= 0;
	
	if (setm == 1 && sw[1] == 0)	//设置分钟
	begin
		if (minute == 59)
		begin
			minute <= 0;
			if (hour == 23 && sw[0] == 0)
			begin
			hour <= 0;
			end
			else if (hour == 11 && sw[0] == 1)
			begin
			hour <= 0;
			end
			else
			begin
			hour <= hour + 1;
			end
		end
		else if(minute < 59)
		begin
		minute <= minute + 1;
		end
	end
	
	if (setm == 1 && sw[1] == 1)	//设置闹钟分钟
	begin
		if (minutec == 59)
		begin
		minutec <= 0;
		end
		else if (minutec < 59)
		begin
		minutec <= minutec + 1;
		end
	end
	
	if (seth ==1 && sw[1] == 0)	//设置小时
	begin
		if (hour == 23 && sw[0] == 0)
		begin
			hour <= 0;
			minute <= 0;
			second <= 0;
		end
		else if (hour == 11 && sw[0] == 1)
		begin
			hour <= 0;
			minute <= 0;
			second <= 0;
		end
		else
		begin
		hour <= hour + 1;
		end
	end
	
	if (seth == 1 && sw[1] == 1) //设置闹钟小时
	begin 
		if (hourc == 23 && sw[0] == 0)
		begin
		hourc <= 0;
		end
		else if (hourc == 11 && sw[0] == 1)
		begin
		hourc <= 0;
		end
		else
		begin
		hourc <= hourc + 1;
		end
	end
	
	// 普通的计时
	if (second == 59)
	begin
		second <= 0;
		if (minute == 59)
		begin
			minute <= 0;
			if (hour == 23 && sw[0] == 0)
			begin
				hour <= 0;
				minute <= 0;
				second <= 0;
			end
			else if (hour == 11 && sw[0] == 1)
			begin
				hour <= 0;
				minute <= 0;
				second <= 0;
			end
			else
			begin
			hour <= hour + 1;
			end
		end
		else if (minute < 59)
		begin
		minute <= minute + 1;
		end	
	end
	else if(second < 59)
	begin
	second <= second + 1;
	end
	
	if (sw[0] == 0)
	begin
		if (sw[1] == 0)
		begin
			for (i=0; i<3; i=i+1)//小时处理
			begin
				if ((hour-i*10)<10)
				begin
					hourLow <= hour - i*10;
					hourHigh <= i;
					i = 3;
				end
			end
		end
		else if(sw[1] == 1)
		begin
			for (i=0; i<3; i=i+1)//小时处理
			begin
				if ((hourc-i*10)<10)
				begin
					hourLow <= hourc - i*10;
					hourHigh <= i;
					i = 3;
				end
			end		
		end
	end
	else if (sw[0] == 1)
	begin
		if (sw[1] == 0)
		begin
			for (i=0; i<2; i=i+1)//小时处理
			begin
				if ((hour-i*10)<10)
				begin
					hourLow <= hour - i*10;
					hourHigh <= i;
					i = 2;
				end
			end	
		end
		else if (sw[1] == 1)
		begin
			for (i=0; i<2; i=i+1)//小时处理
			begin
				if ((hourc-i*10)<10)
				begin
					hourLow <= hourc - i*10;
					hourHigh <= i;
					i = 2;
				end
			end	
		end
	end
	
	for (i=0; i<6; i=i+1)//分处理
	begin
		if (sw[1] == 0)
		begin
			if((minute-i*10) < 10)
			begin
			minuteLow <= minute - i*10;
			minuteHigh <= i;
			i = 6;
			end
		end
		else if (sw[1] == 1)
		begin
			if((minutec-i*10) < 10)
			begin
			minuteLow <= minutec - i*10;
			minuteHigh <= i;
			i = 6;
			end
		end		
	end	
	
	if (minute == 0 || (hourc == hour && minute == minutec))
	begin
		if (secondLow == 0)
		begin
			secondLow <= 4'b1111;
			secondHigh <= 4'b1111;
		end
		else if (secondLow > 0)
		begin
			secondLow <= 4'b0000;
			secondHigh <= 4'b0000;
		end
	end
	else if (minute > 0)
	begin
	for(i=0; i<6; i=i+1)// 秒处理
	begin
		if((second-i*10)<10)
		begin
		secondLow <= second - i*10;
		secondHigh <= i;
		i = 6;
		end
	end
	end
end
else
begin
	counter <= counter+1;
end

end

always@(*)
begin
	an = 4'b1111;
	s<=counter[14:13];
	an[s]=0;
	case(s)
		0:digit<=minuteLow;
		1:digit<=minuteHigh;
		2:digit<=hourLow;
		3:digit<=hourHigh;
	endcase
	case(digit)
       0:atog=7'b0000001;  
       1:atog=7'b1001111;  
       2:atog=7'b0010010;       
       3:atog=7'b0000110;  
       4:atog=7'b1001100;  
       5:atog=7'b0100100;  
       6:atog=7'b0100000;  
       7:atog=7'b0001111;  
       8:atog=7'b0000000;  
       9:atog=7'b0000100;  
       default:atog=7'b0000001; 
	endcase
end

endmodule