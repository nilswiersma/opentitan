// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES SBox testbench

module aes_tb #(
) (
  input  logic clk_i,
  input  logic rst_ni,

  input logic [127:0] aes_input,
  input logic [127:0] aes_key,
  output logic [127:0] aes_output,

  output logic test_done_o,
  output logic test_passed_o
);

  import aes_pkg::*;
  import aes_reg_pkg::*;
  import tlul_pkg::*;

  tl_h2d_t h2d; // req
  tl_d2h_t d2h; // rsp

  // tlul_pkg::tl_h2d_t h2d_int; // req (internal)
  // tlul_pkg::tl_d2h_t d2h_int; // rsp (internal)

  // dv_utils_pkg::if_mode_e if_mode; // interface mode - Host or Device

  // prim_alert_pkg::alert_rx_t [aes_pkg::NumAlerts-1:0] alert_rx;
  // assign alert_rx[0] = 4'b0101;


  aes aes (
    .clk_i                (clk_i      ),
    .rst_ni               (rst_ni     ),

    .idle_o               (           ),

    .tl_i                 (      h2d  ),
    .tl_o                 (      d2h  ),

    .alert_rx_i           (           ),
    .alert_tx_o           (           )
  );

  logic [31:0] count;
  // logic [31:0] reg_offset;
  logic [7:0] fsm;

  // logic [127:0] aes_input;
  // logic [127:0] aes_key;
  // logic [127:0] aes_output;

  always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl

    if (!rst_ni) begin
      count <= 32'b0;
      // aes_key <= 127'h2b7e1516_28aed2a6_abf71588_09cf4f3c;//00000000_00000000_00000000_00000000;//
      // aes_input <= 127'h6bc1bee2_2e409f96_e93d7e11_7393172a;//00000000_00000000_00000000_00000001;//
      // aes_input <= 127'h0000_0000_0000_0000;

      test_done_o <= 1'b0;
      test_passed_o <= 1'b0;
      // reg_offset <= 32'b0;
      fsm <= 8'b0;

      h2d.a_valid    <= 1'b0;
      h2d.a_opcode   <= 3'b000;//32'b0;//
      h2d.a_param    <= 3'b0;//32'b0;//
      h2d.a_address  <= 32'hFFFFFFFF;
      h2d.a_data     <= 32'hFFFFFFFF; // manual_operation=manual, key_len=aes_128, mode=aes_ecb, operation=encrypt
      h2d.a_source   <= 8'hDE;//32'b0;//
      h2d.a_size     <= 2'b10;//32'b0;//
      h2d.a_mask     <= 4'b1111;;//32'b0;//
      h2d.a_user     <= 16'hDEAD;//32'b0;//
      h2d.d_ready    <= 1'b1;
    end else begin

      count <= count + 32'b1;

      // below works 
        if (fsm == 8'b0) begin
          if (count > 32'h20) begin
            fsm <= {1'b1, AES_CTRL_SHADOWED_OFFSET};
            count         <= 32'b0;        
            h2d.d_ready   <= 1'b1;          
            h2d.a_valid   <= 1'b1;
          end
        end

        if (fsm == {1'b1, AES_CTRL_SHADOWED_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_CTRL_SHADOWED_OFFSET};
            h2d.a_data    <= {23'b0, 1'b1, 3'b001, 4'b0001, 1'b0}; // manual_operation=manual, key_len=aes_128, mode=aes_ecb, operation=encrypt
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 3) begin // ctrl needs a few more cycles to setup than data
            fsm <= {1'b1, AES_KEY0_OFFSET};
            count <= 32'b0;        
          end
        end

        if (fsm == {1'b1, AES_KEY0_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY0_OFFSET};
            h2d.a_data    <= aes_key[31:0];//32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY1_OFFSET};
            count <= 32'b0;        
          end
        end

        if (fsm == {1'b1, AES_KEY1_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY1_OFFSET};
            h2d.a_data    <= aes_key[63:32];//32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY2_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY2_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY2_OFFSET};
            h2d.a_data    <= aes_key[95:64];//32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY3_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY3_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY3_OFFSET};
            h2d.a_data    <= aes_key[127:96];//32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY4_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY4_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY4_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY5_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY5_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY5_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY6_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY6_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY6_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_KEY7_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_KEY7_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_KEY7_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_IV0_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_IV0_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_IV0_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_IV1_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_IV1_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_IV1_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_IV2_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_IV2_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_IV2_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_IV3_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_IV3_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_IV3_OFFSET};
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_DATA_IN0_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN0_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_DATA_IN0_OFFSET};
            h2d.a_data    <= aes_input[31:0];//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_DATA_IN1_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN1_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_DATA_IN1_OFFSET};
            h2d.a_data    <= aes_input[63:32];//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_DATA_IN2_OFFSET};
            count <= 32'b0;        
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN2_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_DATA_IN2_OFFSET};
            h2d.a_data    <= aes_input[95:64];//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_DATA_IN3_OFFSET};
            count <= 32'b0;        
          end
        end

        if (fsm == {1'b1, AES_DATA_IN3_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_DATA_IN3_OFFSET};
            h2d.a_data    <= aes_input[127:96];//$random;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_TRIGGER_OFFSET};
            count <= 32'b0;        
          end
        end

        if (fsm == {1'b1, AES_TRIGGER_OFFSET}) begin
          if (count == 0) begin
            h2d.a_address <= {25'b0, AES_TRIGGER_OFFSET};
            h2d.a_data    <= 32'b1;
            h2d.a_mask     <= 4'b1111;
          end 
          if (count == 1) begin
            fsm <= {1'b1, AES_STATUS_OFFSET};
            count  <= 32'b0;        
          end
        end

        if (fsm == {1'b1, AES_STATUS_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            // h2d.a_valid    <= 1'b1;
            h2d.a_opcode   <= 3'b001;//32'b0;//
            h2d.a_address  <= {25'b0, AES_STATUS_OFFSET};
          end

          if (|(d2h.d_data & 32'b0100)) begin
            fsm <= {1'b1, AES_DATA_OUT0_OFFSET};
            count <= 32'b0;        
          end

          // $display("AES_STATUS_OFFSET %0h.", d2h.d_data);
        end
      // above works

      if (fsm == {1'b1, AES_DATA_OUT0_OFFSET}) begin
        if (count == 0) begin
          h2d.a_address <= {25'b0, AES_DATA_OUT0_OFFSET};
        end 
        if (count == 3) begin // these reads also take more cycles to have data ready
          // $display("AES_DATA_OUT0_OFFSET %0h.", d2h.d_data);
          aes_output[31:0] <= d2h.d_data;
          fsm <= {1'b1, AES_DATA_OUT1_OFFSET};
          count <= 32'b0;        
        end
      end

      if (fsm == {1'b1, AES_DATA_OUT1_OFFSET}) begin
        if (count == 0) begin
          h2d.a_address <= {25'b0, AES_DATA_OUT1_OFFSET};
        end 
        if (count == 3) begin
          // $display("AES_DATA_OUT1_OFFSET %0h.", d2h.d_data);
          aes_output[63:32] <= d2h.d_data;
          fsm <= {1'b1, AES_DATA_OUT2_OFFSET};
          count <= 32'b0;        
        end
      end

      if (fsm == {1'b1, AES_DATA_OUT2_OFFSET}) begin
        if (count == 0) begin
          h2d.a_address <= {25'b0, AES_DATA_OUT2_OFFSET};
        end 
        if (count == 3) begin
          // $display("AES_DATA_OUT2_OFFSET %0h.", d2h.d_data);
          aes_output[95:64] <= d2h.d_data;
          fsm <= {1'b1, AES_DATA_OUT3_OFFSET};
          count <= 32'b0;        
        end
      end

      if (fsm == {1'b1, AES_DATA_OUT3_OFFSET}) begin
        if (count == 0) begin
          h2d.a_address <= {25'b0, AES_DATA_OUT3_OFFSET};
        end 
        if (count == 3) begin
          // $display("AES_DATA_OUT3_OFFSET %0h.", d2h.d_data);
          aes_output[127:96] <= d2h.d_data;
          fsm <= 8'hFF;
          count <= 32'b0;   
          test_done_o <= 1'b1;
        end
      end

      if (fsm == 8'hFF) begin
        // $display("aes_key    %h", aes_key);
        // $display("aes_input  %h", aes_input);
        // $display("aes_output %h", aes_output);
        test_done_o <= 1'b1;
      end

      if (count > 32'hFF) begin
        test_done_o <= 1'b1;
      end
    end

    // $display("Loop %0d.", count);
    // $display("h2d.a_data %0d.", h2d.a_data);
  end


endmodule


