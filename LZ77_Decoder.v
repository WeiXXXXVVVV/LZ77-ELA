module LZ77_Decoder(clk,reset,ready,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input				ready;
input 		[4:0] 	code_pos;
input 		[4:0] 	code_len;
input 		[7:0] 	chardata;
output  	reg		encode;
output  	reg		finish;
output 	 reg [7:0] 	char_nxt;


	/*-------------------------------------/
	/		Write your code here~		   /
	/-------------------------------------*/
reg [7:0] data [29:0];
reg [4:0] count;
integer i;
reg  cstat,nstat;
parameter a0=0, a1=1;
always @ (posedge clk or posedge reset)begin
    if(reset)begin  
      for(i=0;i<32;i=i+1)
      begin
          data[i]<=0;
      end
      count<=0;
      cstat<=a0;
      //finish <=0;
    end
    else if(ready==1)begin
      cstat <= nstat;
         if(cstat==a0)begin
          data[1]<=data[0];
          data[2]<=data[1];
          data[3]<=data[2];
          data[4]<=data[3];
          data[5]<=data[4];
          data[6]<=data[5];
          data[7]<=data[6];
          data[8]<=data[7];
          data[9]<=data[8];
          data[10]<=data[9];          
          data[11]<=data[10];
          data[12]<=data[11];
          data[13]<=data[12];
          data[14]<=data[13];
          data[15]<=data[14];
          data[16]<=data[15];
          data[17]<=data[16];
          data[18]<=data[17];
          data[19]<=data[18];
          data[20]<=data[19];
          data[21]<=data[20];
          data[22]<=data[21];
          data[23]<=data[22];
          data[24]<=data[23];
          data[25]<=data[24];
          data[26]<=data[25];
          data[27]<=data[26];
          data[28]<=data[27];
          data[29]<=data[28]; 
          if(code_len==0 || count==code_len)begin
              char_nxt<=chardata;
              data[0]<=chardata;
              count<=0;
          end
          else begin
           char_nxt<=data[code_pos];
           data[0]<=data[code_pos];
           count<=count+1;
          end
         end         
     end      
end
always @(*)begin
  case(cstat)  
    a0:begin
      if(char_nxt == 8'h24)begin
       nstat=a1;
      end
      else 
      nstat=a0;
    end
    a1:begin
      nstat=a1;
    end
  endcase
end
always @(*)begin
  case(cstat)  
    a0:begin
     {encode,finish}=2'b00;
   end
    a1:begin
      {encode,finish}=2'b01;
      end
      endcase
end
endmodule
