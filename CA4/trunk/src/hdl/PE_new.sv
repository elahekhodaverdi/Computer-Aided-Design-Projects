module PE (clk, rst, rst_acc, rst_res_reg, res_buffer_en, acc_en, wr_en, wr_file,
           imgs, filter, countr16, res_index, wr_adr, pe_num);
    
    parameter NUM_OF_IMGS = 1;
    parameter IMG_SIZE = 64;
    parameter IMG_SIZE_2 = 64;
    parameter FILTER_SIZE = 64
    input [31:0] pe_num;
    input clk, rst, rst_acc, rst_res_reg, acc_en, wr_en, wr_file, res_buffer_en;
    input [7:0] res_index, wr_adr, countr16;
    input [7 : 0] imgs [0 : IMG_SIZE - 1];
    input [7 : 0] filter [0 : FILTER_SIZE - 1];

    wire [7:0] mac_out[0: NUM_OF_IMGS];
    wire [31:0] out[0: NUM_OF_IMGS];

    genvar img;
    generate
        for (img  = 0  ; img < NUM_OF_IMGS ; img = img + 1) begin
            mac macimg(clk, rst, rst_acc, acc_en, imgs[counter16 + img*16], filter[counter16 + img*16], mac_out[img]);
        end
    endgenerate

    genvar buffer;

    generate
        for (buffer  = 0  ; buffer < NUM_OF_IMGS ; buffer = buffer +1 ) begin
            mac res_buffer(clk, res_buffer_en, rst | rst_res_reg, res_index, mac_out[buffer], out[buffer]);
        end
    endgenerate


    reg [31:0] res;
    integer i;
    always @* begin
        res = 0;
        for (i = 0; i < NUM_OF_IMGS; i = i + 1) begin
            res = res + out[i];
        end
    end
    int wr_img;
    always @(posedge clk) begin
        if (wr_en) begin
            mem[wr_adr] <= res;
        end
    end

    always @(posedge clk) begin
        if (wr_file)begin
            string file_output;
            file_output = $sformatf("./sim/file/my_output_%0d.dat", pe_num);
            //file_output = $sformatf("file/my_output_%0d.dat", pe_num);
            $writememh(file_output, mem);
        end
    end


    
endmodule