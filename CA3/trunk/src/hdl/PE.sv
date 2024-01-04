module PE (clk, rst, rst_acc, rst_res_reg, res_buffer_en, acc_en, wr_en, wr_file,
           img_pixel, filter_value, res_index, wr_adr, pe_num);
    
    parameter MAX_MEM_SIZE = 128;

    input [31:0] pe_num;
    input clk, rst, rst_acc, rst_res_reg, acc_en, wr_en, wr_file, res_buffer_en;
    input [7:0] img_pixel, filter_value, res_index, wr_adr;
    wire [7:0] mac_out;
    wire [31:0] out;

    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    mac mac1 (clk, rst, rst_acc, acc_en, img_pixel, filter_value, mac_out);

    register4word res_buffer(clk, res_buffer_en, rst | rst_res_reg, res_index, mac_out, out);

    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= out;
        end
    end

    always @(posedge clk) begin
        if (wr_file)begin
            string file_output;
            file_output = $sformatf("./sim/file/my_output_%0d.dat", pe_num);
            $writememh(file_output, mem);
        end
    end


    
endmodule