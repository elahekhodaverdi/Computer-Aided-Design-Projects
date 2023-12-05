module datapath(
    input clk,
    input load_addrs,
    input load_row_img,
    input init_counters,
    input init_temps_counter,
    input row_img_en,
    input col_img_en,
    input row_filter_en,
    input row_res_en,
    input sel_mem_w,
    input buf8_we,
    input buf4w_we,
    input buf4f_we,
    input buf16_she,
    input y_load_buf8_e,
    input x_load_buf8_e,
    input mac_c_en,
    input jump,
    input c3_en,
    input load_mac,
    input init_mac,
    input en_mac_c,
    input step_c_en,
    input init_mac_buf,
    input buf_mac_we,
    input we_memory,
    input macbuf_c_en,
    input shift_c_en,
    input load_row_img_temp,
    input row_img_temp_en,
    input [6:0] X,
    input [6:0] Y,
    input [6:0] Z,
    output co_steps,
    output co_row_filter,
    output co_temp_y,
    output co_temp_x,
    output co_y3,
    output co_mac,
    output co_buf_mac_index,
    output co_shift);

    wire co_row_res;
    wire co_x3;
    wire co_row_img, co_col_img;
    wire x_load_buf8;
    wire [1:0] buf_mac_index;
    wire [1:0] col_img;
    wire [1:0] row_filter;
    wire [1:0] y_temp_wr_buf8;
    wire [1:0] x3,y3;
    wire [3:0] shift_steps;
    wire [2:0] y_load_buf8;
    wire [3:0] steps;
    wire [6:0] img_addr, filter_addr, res_addr;
    wire [6:0] row_img;
    wire [6:0] row_img_temp;
    wire [3:0] mac_c;
    wire [3:0] index6, index7;
    wire [6:0] row_res;
    wire [5:0] index4,index5;
    wire [6:0] read_index;
    wire [6:0] index1,index2,index3;
    wire [7:0] buf_data;
    wire [7:0] f_mac,w_mac, res_mac;
    wire [31:0] buf_mac ; 
    wire [31:0] read_data_mem;

    Memory mem(
    .clk(clk),
    .we(we_memory),
    .write_address(index3),
    .read_address(read_index),
    .data_in(buf_mac),
    .data_out(read_data_mem));

    register #(7) reg1(.clk(clk), .init(1'b0), .load(load_addrs), .data_in(X), .data_out(img_addr));
    register #(7) reg2(.clk(clk), .init(1'b0), .load(load_addrs), .data_in(Y), .data_out(filter_addr));
    register #(7) reg3(.clk(clk), .init(1'b0), .load(load_addrs), .data_in(Z), .data_out(res_addr));
    counter #(7, 127) y_img(.clk(clk), .init(init_counters), .load(load_row_img), .enable(row_img_en), .load_value(img_addr), .increment_value(7'b0000100), .count(row_img), .carry_out(co_row_img));
    counter #(7, 127) y_img_temp(.clk(clk), .init(init_counters), .load(load_row_img_temp), .enable(row_img_temp_en), .load_value(row_img), .increment_value(7'b0000100), .count(row_img_temp), .carry_out(co_row_img_temp));
    counter #(2, 3) x_img(.clk(clk), .init(init_counters), .load(1'b0), .enable(col_img_en), .load_value(2'b00),  .increment_value(2'b01),.count(col_img), .carry_out(co_col_img));
    counter #(2, 3) x_filter(.clk(clk), .init(init_counters), .load(1'b0), .enable(row_filter_en), .load_value(2'b00),  .increment_value(2'b01),.count(row_filter), .carry_out(co_row_filter));
    counter #(7, 43) y_res(.clk(clk), .init(init_counters), .load(1'b0), .enable(row_res_en), .load_value(7'b0), .increment_value(7'b0000001),.count(row_res), .carry_out(co_row_res));
    mux2to1 #(7) muxread(.a(index1), .b(index2),.sel(sel_mem_w), .out(read_index));
    counter2 #(2, 3) tempybuf8(.clk(clk), .init(init_temps_counter), .load(1'b0), .enable(y_load_buf8_e), .load_value(2'b00),  .increment_value(2'b01),.count(y_temp_wr_buf8), .carry_out(co_temp_y));
    counter #(1, 1) tempxbuf8(.clk(clk), .init(init_temps_counter), .load(1'b0), .enable(x_load_buf8_e), .load_value(1'b0),  .increment_value(1'b1),.count(x_load_buf8), .carry_out(co_temp_x));
    coordinate_generator #(2, 2) cor3(.clk(clk), .init(init_counters), .enable(c3_en), .x_max(2'b11), .y_max(2'b11), .x(x3), .y(y3), .y_carryout(co_y3), .x_carryout(co_x3));
    buffer8x8 buf8(.clk(clk), .wr_en(buf8_we), .shift_en(buf16_she), .wr_addr(index4), .rd_addr(index5), .wr_data(read_data_mem), .rd_data(buf_data));
    mac macc(.clk(clk), .a(w_mac), .b(f_mac), .load(load_mac), .init(init_mac), .acc(res_mac));
    counter #(4, 15) mac_counter(.clk(clk), .init(init_temps_counter), .load(1'b0), .enable(mac_c_en), .load_value(4'b0),  .increment_value(4'b0001),.count(mac_c), .carry_out(co_mac));
    buf4x4_f buf4f(.clk(clk), .wr_en(buf4f_we), .wr_addr(index6), .rd_addr(index7), .wr_data(read_data_mem), .rd_data(f_mac));
    buf4x4_w buf4w(.clk(clk), .wr_en(buf4w_we), .wr_addr(index7), .rd_addr(index7), .wr_data(buf_data), .rd_data(w_mac));
    counter2 #(4, 12) steps_counter(.clk(clk), .init(init_counters), .load(1'b0), .enable(step_c_en), .load_value(4'b0),  .increment_value(4'b0001),.count(steps), .carry_out(co_steps));
    counter2 #(2, 3) buf_mac_c(.clk(clk), .init(init_counters), .load(1'b0), .enable(macbuf_c_en), .load_value(2'b0),  .increment_value(2'b01),.count(buf_mac_index), .carry_out(co_buf_mac_index));
    counter2 #(4, 12) shift_c(.clk(clk), .init(init_temps_counter), .load(1'b0), .enable(shift_c_en), .load_value(4'b0),  .increment_value(4'b0001),.count(shift_steps), .carry_out(co_shift));
    buffer4x1 buffmac(.clk(clk), .init(init_mac_buf),.address(buf_mac_index),  .data_in(res_mac), .write(buf_mac_we), .data_out(buf_mac));
    assign index1 = row_img_temp + {5'b0,col_img};
    assign index2 = filter_addr + {5'b0, row_filter}; 
    assign index3 = res_addr + {row_res};
    assign index4 = x_load_buf8*4 + {y_load_buf8}*8;
    assign index5 = x3 + y3*8;
    assign index6 = {1'b0,1'b0,row_filter}*4;
    assign index7 = x3+y3*4;
    assign y_load_buf8 = {1'b0,y_temp_wr_buf8} + {jump,1'b0,1'b0};
endmodule