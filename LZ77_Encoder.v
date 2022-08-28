module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);

input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output reg 			valid;
output  			encode;
output reg 			finish;
output reg 	[4:0] 	offset;
output reg 	[4:0] 	match_len;
output reg 	[7:0] 	char_nxt;


reg			[1:0]	current_state, next_state;
reg			[13:0]	counter; // 8192+1
reg			[4:0]	search_index; //
reg			[4:0]	lookahead_index; //
reg			[3:0]	str_buffer	[8191:0]; //
reg			[3:0]	search_buffer	[29:0]; //

wire				equal	[24:0]; //
wire		[13:0]	current_encode_len; //
wire		[4:0]	curr_lookahead_index; //
wire		[3:0]	match_char [23:0]; //

parameter [1:0] IN=2'b00, ENCODE=2'b01, ENCODE_OUT=2'b10, SHIFT_ENCODE=2'b11;

integer i;

assign	encode = 1'b1;


assign	match_char[0] = search_buffer[search_index];
assign	match_char[1] = (search_index >= 1) ? search_buffer[search_index-1] : str_buffer[search_index];
assign	match_char[2] = (search_index >= 2) ? search_buffer[search_index-2] : str_buffer[1-search_index];
assign	match_char[3] = (search_index >= 3) ? search_buffer[search_index-3] : str_buffer[2-search_index];
assign	match_char[4] = (search_index >= 4) ? search_buffer[search_index-4] : str_buffer[3-search_index];
assign	match_char[5] = (search_index >= 5) ? search_buffer[search_index-5] : str_buffer[4-search_index];
assign	match_char[6] = (search_index >= 6) ? search_buffer[search_index-6] : str_buffer[5-search_index]; //
assign	match_char[7] = (search_index >= 7) ? search_buffer[search_index-7] : str_buffer[6-search_index];
assign	match_char[8] = (search_index >= 8) ? search_buffer[search_index-8] : str_buffer[7-search_index];
assign	match_char[9] = (search_index >= 9) ? search_buffer[search_index-9] : str_buffer[8-search_index];
assign	match_char[10] = (search_index >= 10) ? search_buffer[search_index-10] : str_buffer[9-search_index];
assign	match_char[11] = (search_index >= 11) ? search_buffer[search_index-11] : str_buffer[10-search_index];
assign	match_char[12] = (search_index >= 12) ? search_buffer[search_index-12] : str_buffer[11-search_index];
assign	match_char[13] = (search_index >= 13) ? search_buffer[search_index-13] : str_buffer[12-search_index];
assign	match_char[14] = (search_index >= 14) ? search_buffer[search_index-14] : str_buffer[13-search_index];
assign	match_char[15] = (search_index >= 15) ? search_buffer[search_index-15] : str_buffer[14-search_index];
assign	match_char[16] = (search_index >= 16) ? search_buffer[search_index-16] : str_buffer[15-search_index];
assign	match_char[17] = (search_index >= 17) ? search_buffer[search_index-17] : str_buffer[16-search_index];
assign	match_char[18] = (search_index >= 18) ? search_buffer[search_index-18] : str_buffer[17-search_index];
assign	match_char[19] = (search_index >= 19) ? search_buffer[search_index-19] : str_buffer[18-search_index];
assign	match_char[20] = (search_index >= 20) ? search_buffer[search_index-20] : str_buffer[19-search_index];
assign	match_char[21] = (search_index >= 21) ? search_buffer[search_index-21] : str_buffer[20-search_index];
assign	match_char[22] = (search_index >= 22) ? search_buffer[search_index-22] : str_buffer[21-search_index];
assign	match_char[23] = (search_index >= 23) ? search_buffer[search_index-23] : str_buffer[22-search_index];

assign	equal[0] = (search_index <= 29) ? ((match_char[0]==str_buffer[0]) ? 1'b1 : 1'b0) : 1'b0;
assign	equal[1] = (search_index <= 29) ? ((match_char[1]==str_buffer[1]) ? equal[0] : 1'b0) : 1'b0;
assign	equal[2] = (search_index <= 29) ? ((match_char[2]==str_buffer[2]) ? equal[1] : 1'b0) : 1'b0;
assign	equal[3] = (search_index <= 29) ? ((match_char[3]==str_buffer[3]) ? equal[2] : 1'b0) : 1'b0;
assign	equal[4] = (search_index <= 29) ? ((match_char[4]==str_buffer[4]) ? equal[3] : 1'b0) : 1'b0;
assign	equal[5] = (search_index <= 29) ? ((match_char[5]==str_buffer[5]) ? equal[4] : 1'b0) : 1'b0;
assign	equal[6] = (search_index <= 29) ? ((match_char[6]==str_buffer[6]) ? equal[5] : 1'b0) : 1'b0;  //
assign	equal[7] = (search_index <= 29) ? ((match_char[7]==str_buffer[7]) ? equal[6] : 1'b0) : 1'b0; 
assign	equal[8] = (search_index <= 29) ? ((match_char[8]==str_buffer[8]) ? equal[7] : 1'b0) : 1'b0; 
assign	equal[9] = (search_index <= 29) ? ((match_char[9]==str_buffer[9]) ? equal[8] : 1'b0) : 1'b0; 
assign	equal[10] = (search_index <= 29) ? ((match_char[10]==str_buffer[10]) ? equal[9] : 1'b0) : 1'b0; 
assign	equal[11] = (search_index <= 29) ? ((match_char[11]==str_buffer[11]) ? equal[10] : 1'b0) : 1'b0; 
assign	equal[12] = (search_index <= 29) ? ((match_char[12]==str_buffer[12]) ? equal[11] : 1'b0) : 1'b0; 
assign	equal[13] = (search_index <= 29) ? ((match_char[13]==str_buffer[13]) ? equal[12] : 1'b0) : 1'b0; 
assign	equal[14] = (search_index <= 29) ? ((match_char[14]==str_buffer[14]) ? equal[13] : 1'b0) : 1'b0; 
assign	equal[15] = (search_index <= 29) ? ((match_char[15]==str_buffer[15]) ? equal[14] : 1'b0) : 1'b0; 
assign	equal[16] = (search_index <= 29) ? ((match_char[16]==str_buffer[16]) ? equal[15] : 1'b0) : 1'b0; 
assign	equal[17] = (search_index <= 29) ? ((match_char[17]==str_buffer[17]) ? equal[16] : 1'b0) : 1'b0; 
assign	equal[18] = (search_index <= 29) ? ((match_char[18]==str_buffer[18]) ? equal[17] : 1'b0) : 1'b0; 
assign	equal[19] = (search_index <= 29) ? ((match_char[19]==str_buffer[19]) ? equal[18] : 1'b0) : 1'b0; 
assign	equal[20] = (search_index <= 29) ? ((match_char[20]==str_buffer[20]) ? equal[19] : 1'b0) : 1'b0; 
assign	equal[21] = (search_index <= 29) ? ((match_char[21]==str_buffer[21]) ? equal[20] : 1'b0) : 1'b0; 
assign	equal[22] = (search_index <= 29) ? ((match_char[22]==str_buffer[22]) ? equal[21] : 1'b0) : 1'b0; 
assign	equal[23] = (search_index <= 29) ? ((match_char[23]==str_buffer[23]) ? equal[22] : 1'b0) : 1'b0; 
assign	equal[24] = 1'b0;


assign	current_encode_len = counter+match_len+1;
assign	curr_lookahead_index = lookahead_index+1;


always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		current_state <= IN;
		counter <= 13'd0; //
		search_index <= 5'd0; //
		lookahead_index <= 5'd0; //
		valid <= 1'b0;
		finish <= 1'b0;
		offset <= 5'd0; //
		match_len <= 5'd0; //
		char_nxt <= 8'd0;

		search_buffer[0] <= 4'd0; //
		search_buffer[1] <= 4'd0;
		search_buffer[2] <= 4'd0;
		search_buffer[3] <= 4'd0;
		search_buffer[4] <= 4'd0;
		search_buffer[5] <= 4'd0;
		search_buffer[6] <= 4'd0;
		search_buffer[7] <= 4'd0;
		search_buffer[8] <= 4'd0;
		search_buffer[9] <= 4'd0;
		search_buffer[10] <= 4'd0;
		search_buffer[11] <= 4'd0;
		search_buffer[12] <= 4'd0;
		search_buffer[13] <= 4'd0;
		search_buffer[14] <= 4'd0;
		search_buffer[15] <= 4'd0;
		search_buffer[16] <= 4'd0;
		search_buffer[17] <= 4'd0;
		search_buffer[18] <= 4'd0;
		search_buffer[19] <= 4'd0;
		search_buffer[20] <= 4'd0;
		search_buffer[21] <= 4'd0;
		search_buffer[22] <= 4'd0;
		search_buffer[23] <= 4'd0;
		search_buffer[24] <= 4'd0;
		search_buffer[25] <= 4'd0;
		search_buffer[26] <= 4'd0;
		search_buffer[27] <= 4'd0;
		search_buffer[28] <= 4'd0;
		search_buffer[29] <= 4'd0;
	end
	else
	begin
		current_state <= next_state;
		
		case(current_state)
			IN:
			begin
				str_buffer[counter] <= chardata[3:0];
				counter <= (counter==8191) ? 0 : counter+1; //
			end
			ENCODE:
			begin
				if(equal[match_len]==1 && search_index < counter && current_encode_len <= 8192) //
				begin
					char_nxt <= str_buffer[curr_lookahead_index];
					match_len <= match_len+1;
					offset <= search_index;

					lookahead_index <= curr_lookahead_index;
				end
				else
				begin
					search_index <= (search_index==31) ? 0 : search_index-1; //
				end
			end
			ENCODE_OUT:
			begin
				valid <= 1;
				// offset <= offset;
				// match_len <= match_len;
				char_nxt <= (current_encode_len==8193) ? 8'h24 : (match_len==0) ? str_buffer[0] : char_nxt; //
				counter <= current_encode_len;
			end
			SHIFT_ENCODE:
			begin
				finish <= (counter==8193) ? 1 : 0; //
				offset <= 0;
				valid <= 0;
				match_len <= 0;
				search_index <= 29;  //
				lookahead_index <= (lookahead_index==0) ? 0 : lookahead_index-1;

				search_buffer[29] <= search_buffer[28]; 
				search_buffer[28] <= search_buffer[27]; 
				search_buffer[27] <= search_buffer[26]; 
				search_buffer[26] <= search_buffer[25]; 
				search_buffer[25] <= search_buffer[24]; 
				search_buffer[24] <= search_buffer[23]; 
				search_buffer[23] <= search_buffer[22]; 
				search_buffer[22] <= search_buffer[21]; 
				search_buffer[21] <= search_buffer[20]; 
				search_buffer[20] <= search_buffer[19]; 
				search_buffer[19] <= search_buffer[18]; 
				search_buffer[18] <= search_buffer[17]; 
				search_buffer[17] <= search_buffer[16]; 
				search_buffer[16] <= search_buffer[15]; 
				search_buffer[15] <= search_buffer[14]; 
				search_buffer[14] <= search_buffer[13]; 
				search_buffer[13] <= search_buffer[12]; 
				search_buffer[12] <= search_buffer[11]; 
				search_buffer[11] <= search_buffer[10]; 
				search_buffer[10] <= search_buffer[9]; 
				search_buffer[9] <= search_buffer[8]; 
				search_buffer[8] <= search_buffer[7]; //
				search_buffer[7] <= search_buffer[6];
				search_buffer[6] <= search_buffer[5];
				search_buffer[5] <= search_buffer[4];
				search_buffer[4] <= search_buffer[3];
				search_buffer[3] <= search_buffer[2];
				search_buffer[2] <= search_buffer[1];
				search_buffer[1] <= search_buffer[0];
				search_buffer[0] <= str_buffer[0];

				for (i=0; i<8191; i=i+1) begin //
					str_buffer[i] <= str_buffer[i+1];
				end
			end
		endcase
	end
end



always @(*)
begin
	case(current_state)
		IN:
		begin
			next_state = (counter==8191) ? ENCODE : IN; //
		end
		ENCODE:
		begin
		  next_state = (search_index==31 || match_len==24) ? ENCODE_OUT : ENCODE;
		end
		ENCODE_OUT:
		begin
			next_state = SHIFT_ENCODE;
		end
		SHIFT_ENCODE:
		begin
			next_state = (lookahead_index==0) ? ENCODE : SHIFT_ENCODE;
		end
		default:
		begin
			next_state = IN;
		end
	endcase
end

endmodule
