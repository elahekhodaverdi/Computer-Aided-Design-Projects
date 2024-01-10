`define idle 5'b00000
`define init 5'b00001
`define load_filter 5'b00010
`define check_load8 5'b00011
`define load_8_x1 5'b00100
`define load_8_x2 5'b00101
`define nex_row8 5'b00110
`define load_buf4x4 5'b00111
`define mac 5'b01000
`define wb_buf_mac 5'b01001
`define idk 5'b01010
`define wb_memory 5'b01011
`define shift 5'b01100
`define next_row_img 5'b01101
`define check 5'b01110
`define check_shift 5'b01111
`define done 5'b10000


module controller(
    input clk,
    input rst,
    input start,
    input is_finished,
    input co_row_filter,
    input co_temp_y,
    input co_temp_x,
    input co_y3,
    input co_mac,
    input co_buf_mac_index,
    input co_shift,
    output reg load_addrs,
    output reg load_row_img,
    output reg load_row_img_temp,
    output reg row_img_temp_en,
    output reg row_img_en,
    output reg init_counters,
    output reg init_temps_counter,
    output reg col_img_en,
    output reg row_filter_en,
    output reg row_res_en,
    output reg sel_mem_w,
    output reg buf8_we,
    output reg buf4w_we,
    output reg buf4f_we,
    output reg shift_en,
    output reg y_load_buf8_e,
    output reg x_load_buf8_e,
    output reg mac_c_en,
    output reg macbuf_c_en,
    output reg shift_c_en,
    output reg jump,
    output reg c3_en,
    output reg load_mac,
    output reg init_mac,
    output reg en_mac_c,
    output reg step_c_en,
    output reg init_mac_buf,
    output reg buf_mac_we,
    output reg we_memory,
    output reg done
);
    reg[4:0] ns =`idle;
    reg[4:0] ps =`idle;

    always @(ps) begin 
        {load_addrs, load_row_img, init_counters, row_img_en, row_filter_en, row_res_en, row_img_temp_en} <= 7'b0;
        {sel_mem_w, buf8_we, buf4w_we, buf4f_we, shift_en, y_load_buf8_e, macbuf_c_en, done} <= 8'b0;
        {x_load_buf8_e, mac_c_en, jump, c3_en, load_mac, init_mac, shift_c_en, load_row_img_temp} <= 8'b0;
        {en_mac_c, step_c_en, init_mac_buf, buf_mac_we, we_memory, col_img_en, init_temps_counter} <= 7'b0;
        case(ps)
            `idle: begin end 
            `init: begin  
                init_counters <= 1'b1;
                        init_mac <= 1'b1;
                        init_mac_buf <= 1'b1;
                    load_addrs <= 1'b1;
                    init_temps_counter <= 1'b1;
                     end
            `load_filter: begin 
                    row_filter_en <= 1'b1;
                    buf4f_we <= 1'b1;
                    sel_mem_w <= 1'b1;
                    load_row_img <= 1'b1;
                    load_row_img_temp <= 1'b1;
                end
            `load_8_x1: begin
                    col_img_en <= 1'b1;
                    x_load_buf8_e <= 1'b1;
                    buf8_we <= 1'b1;
                end
            `load_8_x2: begin
                x_load_buf8_e <= 1'b1;
                col_img_en <= 1'b1;
                buf8_we <= 1'b1;
                jump <= 1;
            end
            `nex_row8: begin 
                row_img_temp_en <= 1'b1;
                y_load_buf8_e <= 1'b1;
             end
            `load_buf4x4: begin
                c3_en <=1'b1;
                buf4w_we <= 1'b1;
            end
            `mac: begin
                load_mac <= 1'b1;
                c3_en <=1'b1;
                mac_c_en <= 1'b1;
            end
            `wb_buf_mac: begin                 
                buf_mac_we <= 1'b1;
                macbuf_c_en <= 1'b1;
            end
            `idk: begin 
                init_mac <= 1'b1;
            end
            `wb_memory: begin
                we_memory <= 1'b1;
                row_res_en <= 1'b1;
                init_mac_buf <= 1'b1;
             end
            `shift:
            begin 
                shift_c_en <= 1'b1;
                shift_en <= 1'b1;
            end
            `check_shift: begin  end
            `next_row_img: begin 
                row_img_en <= 1'b1;
                step_c_en <= 1'b1;
            end
            `check: begin
                    init_temps_counter <= 1'b1;
                    load_row_img_temp <= 1'b1;
            end
            `done: begin done <= 1'b1;
            we_memory <= 1'b1;
            end
        endcase
    end

    always @(start, is_finished, ps, co_row_filter, co_temp_y, co_temp_x, co_y3, co_mac, co_buf_mac_index, co_shift) begin
        case(ps)
            `idle: ns <= start ? `init : `idle;
            `init: ns <= start ? `init : `load_filter;
            `load_filter: ns <= co_row_filter ? `check_load8 : `load_filter;
            `check_load8: ns <= co_temp_y ? `load_buf4x4: `load_8_x1;
            `load_8_x1: ns <=   co_temp_x ? `load_8_x2 : `load_8_x1;
            `load_8_x2:  ns <= co_temp_x ? `nex_row8 : `load_8_x2;
            `nex_row8: ns <= `check_load8;
            `load_buf4x4: ns <= co_y3? `mac : `load_buf4x4;
            `mac: ns <= co_mac ? `wb_buf_mac : `mac;
            `wb_buf_mac : ns <= `idk;
            `idk:  ns <= co_buf_mac_index ? `wb_memory : `shift;
            `wb_memory: ns <= `shift;
            `shift : ns <= `check_shift;
            `check_shift: ns <=  co_shift ? `next_row_img : `load_buf4x4;
            `next_row_img: ns <= `check;
            `check : ns <= is_finished ? `done : `check_load8;
            `done: ns <= `idle;
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= `idle;
        else
            ps <= ns;
     end

endmodule


