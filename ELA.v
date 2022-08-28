`timescale 1ns/10ps

module ELA(clk, rst, ready, in_data, data_rd, req, wen, addr, data_wr, done);

	input				clk;
	input				rst;
	input				ready;
	input		[7:0]	in_data;
	input		[7:0]	data_rd;
	output 	reg			req;
	output 	reg			wen;
	output 	reg	[12:0]	addr;
	output 	reg	[7:0]	data_wr;
	output 	reg			done;


	/*-------------------------------------/
	/		Write your code here~		   /
	/-------------------------------------*/
reg  [1:0]state_1,state_2;
reg  [7:0] a,b,c;
parameter t0=0,t1=1,t2=2;	
reg[7:0]get_data[127:0];
reg[7:0]get_data2[127:0];
reg[7:0]regdata;
reg[2:0] c_state,n_state;
parameter a0=0,//
          a1=1,//
          a2=2,//        
          a3=3,//
          a4=4;//done          
reg[14:0]  count_5;
reg[10:0]  c_10;
reg[7:0]  count_1,count_2,count_6,count_7,count_8,c_9;
reg[7:0]  count_3;
reg [10:0] d1,d2,d3;
integer i,k;
always @(*)begin
   case(c_state)
     a0:begin 
       if(!rst)
        n_state=a1;
       end
     a1:begin
        n_state=a2;
     end
     a2:begin
      if(c_9 == 128 & count_3==1)
         n_state=a1;
       else if(c_9 == 128 & count_3 >=2)
         n_state=a3;
       else
         n_state=a2;
     end
     a3:begin
      if(c_10==383 & count_3==2)
         n_state=a1;   
      else if(c_10==255 & count_3==3)
         n_state=a1;
      else if(c_10==255 & count_3==4)
         n_state=a1;
      else if(c_10==255 & count_3==5)
         n_state=a1;
      else if(c_10==255 & count_3==6)
         n_state=a1;
      else if(c_10==255 & count_3==7)
         n_state=a1;
      else if(c_10==255 & count_3==8)
         n_state=a1;
      else if(c_10==255 & count_3==9)
         n_state=a1;
      else if(c_10==255 & count_3==10)
         n_state=a1;
      else if(c_10==255 & count_3==11)
         n_state=a1; 
      else if(c_10==255 & count_3==12)
         n_state=a1;
      else if(c_10==255 & count_3==13)
         n_state=a1;
      else if(c_10==255 & count_3==14)
         n_state=a1;
      else if(c_10==255 & count_3==15)
         n_state=a1;
      else if(c_10==255 & count_3==16)
         n_state=a1;   
      else if(c_10==255 & count_3==17)
         n_state=a1;
      else if(c_10==255 & count_3==18)
         n_state=a1;
      else if(c_10==255 & count_3==19)
         n_state=a1;
      else if(c_10==255 & count_3==20)
         n_state=a1;
      else if(c_10==255 & count_3==21)
         n_state=a1;
      else if(c_10==255 & count_3==22)
         n_state=a1;
      else if(c_10==255 & count_3==23)
         n_state=a1;
      else if(c_10==255 & count_3==24)
         n_state=a1;
      else if(c_10==255 & count_3==25)
         n_state=a1; 
      else if(c_10==255 & count_3==26)
         n_state=a1;
      else if(c_10==255 & count_3==27)
         n_state=a1;
      else if(c_10==255 & count_3==28)
         n_state=a1;
      else if(c_10==255 & count_3==29)
         n_state=a1;
      else if(c_10==255 & count_3==30)
         n_state=a1;
      else if(c_10==255 & count_3==31)
         n_state=a1;   
      else if(c_10==256 & count_3==32)         
         n_state=a4;
       else
         n_state=a3;
     end
     a4:begin
         n_state=a4;
      end
   endcase      
end 
always @(posedge clk or posedge rst)begin 
   if(rst)begin   
     for(i=0;i<128;i=i+1)begin
       get_data[i]<=0;
     end
	   for(k=0;k<128;k=k+1)begin
       get_data2[k]<=0;
     end
	   data_wr<=0;	 
     c_state<=a0;
     count_1<=0;//input
     count_2<=0;//32check
     count_3<=0;//16round
     count_5<=0;//addr
     count_6<=0;//addr_getdata
     count_7<=0;//addr_newdata
     count_8<=0;
     a<=0;
     b<=0;
	   regdata <= 0;
   end
 else if (ready ==1)begin
   c_state<=n_state;
    
   case(c_state)
       a1:begin
         c_9<=0;
         count_1 <= 0;
         count_2 <= 0;
         count_3<=count_3 +1; 
       end
       a2:begin
         c_10<=0;
         if(count_3>=3 )begin
         state_1=t1;
         end
         else begin
         state_1=t0;  
         end
         if(count_1==0 &count_2==0)           
             req <= 1;
         else 
             req<=0; 
         if(count_3==1 |count_3==3 |count_3==5 |count_3==7 |count_3==9 |count_3==11 |count_3==13 |count_3==15
          |count_3==17 |count_3==19 |count_3==21 |count_3==23 |count_3==25 |count_3==27 |count_3==29 |count_3==31 |count_3==33)begin
          get_data[count_1-1]<= in_data;
		      regdata<=in_data;
		      c_9<=c_9+1;
           count_1 <= count_1 +1;
          end
          else begin
          get_data2[count_2-1]<= in_data;
		      regdata<=in_data;
		      c_9<=c_9+1;
           count_2 <= count_2 +1;
          end
       end               
      a3:begin
          state_1<=state_2;             
          case(state_1)
          t0:begin
               addr<=count_5;
               data_wr<=get_data[count_6];
               count_5<= count_5 +1;
               count_6<= count_6 +1;
               count_8<= 0;
               c_10<=c_10+1;
               a <=a+1;
               b<=0;
               count_7<= 0;
           end
           t1:begin               
               addr<=count_5;                
               count_5<= count_5 +1;
               count_6<= 0;
               count_8<= 0;
               c_10<=c_10+1;
               b <=b+1;
               c<=0;
               a<=0;
               if (count_3==3 |count_3==5 |count_3==7 |count_3==9 |count_3==11 |count_3==13 |count_3==15|count_3==17
                |count_3==19 |count_3==21 |count_3==23 |count_3==25 |count_3==27 |count_3==29 |count_3==31 |count_3==33)begin
                    if(count_7==0 | count_7==127)begin          
                       data_wr <=(get_data[count_7]+get_data2[count_7])/2;
                       count_7<=count_7 +1;
                    end
                    else begin
                        if(d1<d2 & d1<d3 )begin
                           data_wr <=  (get_data[count_7-1]+get_data2[count_7+1])/2;
                        end
                        else if(d2<=d1 & d2<=d3)begin
                             data_wr <=  (get_data[count_7  ]+get_data2[count_7])/2;
                        end
                        else if (d3<d2 & d3<=d1)begin
                           data_wr <=  (get_data[count_7+1]+get_data2[count_7-1])/2;         
                        end
                      count_7<=count_7 +1;
                   end  
              end      
              else if (count_3==2 |count_3==4 |count_3==6 |count_3==8 |count_3==10 |count_3==12 |count_3==14|count_3==16
                    |count_3==18 |count_3==20 |count_3==22 |count_3==24 |count_3==26 |count_3==28 |count_3==30| count_3==32 )begin
                  if(count_7==0 | count_7==127)begin          
                   data_wr <=(get_data[count_7]+get_data2[count_7])/2;
                   count_7<=count_7 +1;
                  end
                 else begin
              if(d1<d2 & d1<=d3 )begin
               data_wr <=  (get_data[count_7-1]+get_data2[count_7+1])/2;
              end
              else if(d2<=d1 & d2<=d3)begin
                data_wr <=  (get_data[count_7  ]+get_data2[count_7])/2;
              end
              else if (d3<d2 & d3<d1)begin
              data_wr <=  (get_data[count_7+1]+get_data2[count_7-1])/2;
         
              end             
           count_7<=count_7 +1;
          end
      end
            end
            t2:begin
               addr<=count_5;
               data_wr<=get_data2[count_8];
               count_5<= count_5 +1;
               count_8<= count_8 +1;
               count_6<= 0;
               c_10<=c_10+1;
               c <=c+1;
               b<=0;
               a<=0;
               count_7<= 0;
            end
          endcase                                                                                       
      end        
    endcase
  end
end    
always @(*)begin
  if(c_state == 3)begin
    case(state_1)
      t0:begin
        if(a<=126)
          state_2=t0;
        else
          state_2=t1;
      end
      t1:begin
        if(b==127&count_3==3 )begin         
          state_2=t0;
        end
        else if(b==127&count_3==5 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==7 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==9 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==11 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==13 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==15 )begin         
          state_2=t0;
        end
        else if(b==127&count_3==17 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==19 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==21 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==23 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==25 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==27 )begin         
          state_2=t0;
        end
        else if(b==127&count_3==29 )begin         
          state_2=t0;
        end 
        else if(b==127&count_3==31 )begin         
          state_2=t0;
        end             
        else if(b==127)begin
        state_2=t2;
        end
        else begin
        state_2=t1; 
        end
      end
      t2:begin
        if(c<=126)
        state_2=t2;
        else
        state_2=t0;
      end
    endcase
  end
end 
always @(*)begin
   if(c_state == 3 & state_1==1)begin
       d1= (get_data[count_7-1]>=get_data2[count_7+1])?(get_data[count_7-1]-get_data2[count_7+1]):(get_data2[count_7+1]-get_data[count_7-1]);
       d2= (get_data[count_7  ]>=get_data2[count_7])?(get_data[count_7  ]-get_data2[count_7]):(get_data2[count_7]-get_data[count_7  ]);
       d3= (get_data[count_7+1]>=get_data2[count_7-1])?(get_data[count_7+1]-get_data2[count_7-1]):(get_data2[count_7-1]-get_data[count_7+1]);
   end
end 
always @(*)begin
  case(c_state)
    a0:begin
      {wen,done}=2'b00;
    end
    a1:begin
      {wen,done}=3'b10;
    end
    a2:begin
      {wen,done}=3'b10;
    end
    a3:begin
      {wen,done}=3'b10;
    end
    a4:begin
      {wen,done}=3'b01;
    end
 endcase
 end	

endmodule