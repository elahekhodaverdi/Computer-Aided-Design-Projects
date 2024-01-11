module  pe_dp(clk, rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file,
                z, img_buffer_index, buffer_cntr, res_index, wr_adr, imgs, filters, pe_num, layer_num);
                
    parameter NUM_IMAGES = 1;
    parameter IMG_SIZE = 16;
    parameter MAX_MEM_SIZE = 128;
    input clk, rst, rst_acc, acc_en, res_buffer_en, rst_res_reg, wr_en, wr_file;
    input [7:0] z, img_buffer_index, buffer_cntr, res_index, wr_adr;
    input [7:0] imgs[0 : NUM_IMAGES - 1][0:IMG_SIZE * IMG_SIZE - 1];
    input [7:0] filters[0:NUM_IMAGES - 1][0:15];
    input [31:0] pe_num, layer_num;

    wire [7:0] buffers_4_4 [0:NUM_IMAGES-1][0:15]; 
    wire [7 : 0] mac_out [0:NUM_IMAGES-1];
    wire [31:0] reg4_out;
    reg [7 : 0] macs_sum;

    reg [31:0] mem [0:MAX_MEM_SIZE-1];

    genvar i, j, k;
    generate
        for (i = 0; i < NUM_IMAGES; i++) begin
            for (j = 0; j < 4; j++) begin
                for (k = 0; k < 4; k++)begin
                    assign buffers_4_4[i][j * 4 + k] = imgs[i][img_buffer_index + j * IMG_SIZE + k]; 
                end
            end
        end
    endgenerate

    generate
        for (i = 0; i < NUM_IMAGES; i++)begin
            mac macc (clk, rst, rst_acc, acc_en, filters[i][buffer_cntr], buffers_4_4[i][buffer_cntr], mac_out[i]);
        end
    endgenerate

    register4word res_buffer(clk, res_buffer_en, rst | rst_res_reg, res_index, macs_sum, reg4_out);

    always @(*) begin
        macs_sum = 0;
        for (integer i = 0; i < NUM_IMAGES; i = i + 1)begin
            macs_sum = macs_sum + mac_out[i];
        end
    end

    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= reg4_out;
        end
    end

    always @(posedge clk) begin
        if (wr_file)begin
            string file_output;
            file_output = $sformatf("./sim/file/my_output_%0d_L%0d.dat", pe_num, layer_num);
            //file_output = $sformatf("file/my_output_%0d.dat", pe_num);
            $writememh(file_output, mem);
        end
    end

    
    
endmodule