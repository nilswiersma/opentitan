// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES SBox testbench

module aes_tb #(
) (
  input  logic clk_i,
  input  logic rst_ni,

  output logic test_done_o,
  output logic test_passed_o
);


  /////// sbox lut
  // import aes_pkg::*;

  // logic [8:0] count_d, count_q;
  // logic [7:0] stimulus;
  // ciph_op_e   op;

  // localparam int NUM_SBOX_IMPLS = 1;
  // localparam int NUM_SBOX_IMPLS_MASKED = 0;
  // localparam int NumSBoxImplsTotal = NUM_SBOX_IMPLS + NUM_SBOX_IMPLS_MASKED;
  // logic [7:0] responses[NumSBoxImplsTotal];

  // // Generate the stimuli
  // assign count_d = count_q + 9'h1;
  // always_ff @(posedge clk_i or negedge rst_ni) begin : reg_count
  //   if (!rst_ni) begin
  //     count_q <= '0;
  //   end else begin
  //     count_q <= count_d;
  //   end
  // end

  // assign op = count_q[8] ? CIPH_FWD : CIPH_INV;
  // assign stimulus = count_q[7:0];

  // // Instantiate SBox Implementations
  // aes_sbox #(
  //   .SBoxImpl ( "lut" )
  // ) aes_sbox_lut (
  //   .op_i   ( op           ),
  //   .data_i ( stimulus     ),
  //   .data_o ( responses[0] )
  // );

  // // Check responses, signal end of simulation
  // always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl
  //   test_done_o   <= 1'b0;
  //   test_passed_o <= 1'b1;

  //   for (int i=1; i<NumSBoxImplsTotal; i++) begin
  //     if (rst_ni && (responses[i] != responses[0])) begin
  //       $display("\nERROR: Mismatch between LUT-based S-Box and Implementation %0d found.", i);
  //       $display("op = %s, stimulus = 8'h%h, expected resp = 8'h%h, actual resp = 8'h%h\n",
  //           (op == CIPH_FWD) ? "CIPH_FWD" : "CIPH_INV", stimulus, responses[0], responses[i]);
  //       test_passed_o <= 1'b0;
  //       test_done_o   <= 1'b1;
  //     end
  //   end

  //   if (count_q == 9'h1FF) begin
  //     $display("\nSUCCESS: Outputs of all S-Box implementations match.");
  //     test_done_o <= 1'b1;
  //   end
  // end

  // /////// trying to strip aes
  // import aes_reg_pkg::*;
  // import aes_pkg::*;

  // aes_reg2hw_t reg2hw;
  // aes_hw2reg_t hw2reg;

  // aes_core #(
  //   .AES192Enable ( 0 ),
  //   .SBoxImpl     ( "lut"     )
  // ) aes_core (
  //   .clk_i,
  //   .rst_ni,
  //   .reg2hw,
  //   .hw2reg
  // );

  ///////// aes core?
  // // Input handshake signals
  // logic                 cipher_in_valid;
  // logic                 cipher_in_ready;

  // // Output handshake signals
  // logic                 cipher_out_valid;
  // logic                 cipher_out_ready;

  // // Control and sync signals
  // aes_pkg::ciph_op_e    cipher_op;
  // aes_pkg::key_len_e    key_len_q;
  // logic                 cipher_crypt;
  // logic                 cipher_crypt_busy;
  // logic                 cipher_dec_key_gen;
  // logic                 cipher_dec_key_gen_busy;
  // logic                 cipher_key_clear;
  // logic                 cipher_key_clear_busy;
  // logic                 cipher_data_out_clear; // Re-use the cipher core muxes.
  // logic                 cipher_data_out_clear_busy;

  // // Pseudo-random data
  // logic          [63:0] prng_data_i;

  // // I/O data & initial key
  // logic [3:0][3:0][7:0] state_init;
  // logic     [7:0][31:0] key_init_q;
  // logic [3:0][3:0][7:0] state_done;

  // aes_cipher_core #(
  //   .AES192Enable ( 0 ),
  //   .SBoxImpl     ( "lut"     )
  // ) dut (
  //   .clk_i            ( clk_i                      ),
  //   .rst_ni           ( rst_ni                     ),

  //   .in_valid_i       ( cipher_in_valid            ),
  //   .in_ready_o       ( cipher_in_ready            ),
  //   .out_valid_o      ( cipher_out_valid           ),
  //   .out_ready_i      ( cipher_out_ready           ),
  //   .op_i             ( cipher_op                  ),
  //   .key_len_i        ( key_len_q                  ),
  //   .crypt_i          ( cipher_crypt               ),
  //   .crypt_o          ( cipher_crypt_busy          ),
  //   .dec_key_gen_i    ( cipher_dec_key_gen         ),
  //   .dec_key_gen_o    ( cipher_dec_key_gen_busy    ),
  //   .key_clear_i      ( cipher_key_clear           ),
  //   .key_clear_o      ( cipher_key_clear_busy      ),
  //   .data_out_clear_i ( cipher_data_out_clear      ),
  //   .data_out_clear_o ( cipher_data_out_clear_busy ),

  //   .prng_data_i      ( prng_data_i                ),

  //   .state_init_i     ( state_init                 ),
  //   .key_init_i       ( key_init_q                 ),
  //   .state_o          ( state_done                 )
  // );


  // logic [7:0] count;

  // always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl

  //   if (!rst_ni) begin
  //     count <= 8'b0;
  //     test_done_o <= 1'b0;
  //     test_passed_o <= 1'b0;
  //   end else begin
  //     count <= count + 8'b1;
  //   end

  //   if (count == 9'hFF) begin
  //     test_done_o <= 1'b1;
  //   end

  //   cipher_in_valid <= 1'b1;
  //   $display("\nLoop %0d.", count);
  // end

  /////// aes including wrapper
  // import uvm_pkg::*;
  // import dv_utils_pkg::*;
  // import aes_env_pkg::*;
  // import aes_test_pkg::*;
  import aes_pkg::*;
  import aes_reg_pkg::*;

  wire tlul_pkg::tl_h2d_t h2d; // req
  wire tlul_pkg::tl_d2h_t d2h; // rsp

  // tlul_pkg::tl_h2d_t h2d_int; // req (internal)
  // tlul_pkg::tl_d2h_t d2h_int; // rsp (internal)

  // dv_utils_pkg::if_mode_e if_mode; // interface mode - Host or Device

  prim_alert_pkg::alert_rx_t [aes_pkg::NumAlerts-1:0] alert_rx;
  assign alert_rx[0] = 4'b0101;


  aes aes (
    .clk_i                (clk_i      ),
    .rst_ni               (rst_ni     ),

    .idle_o               (           ),

    .tl_i                 (      h2d  ),
    .tl_o                 (      d2h  ),

    .alert_rx_i           ( alert_rx  ),
    .alert_tx_o           (           )
  );

  logic [31:0] count;
  logic [31:0] reg_offset;
  logic [31:0] fsm;

  always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl

    if (!rst_ni) begin
      count <= 32'b0;
      test_done_o <= 1'b0;
      test_passed_o <= 1'b0;
      // reg_offset <= 32'b0;
      fsm <= 32'b0;

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
        if (fsm == 32'b0) begin
          if (count > 32'h20) begin
            // $display("count %0h.", count);
            // $display("fsm   %0h.", fsm);
            if (count % 32'h8 == 7) begin
              fsm <= {1'b1, AES_CTRL_SHADOWED_OFFSET};
              h2d.d_ready   <= 1'b1;          
              h2d.a_valid   <= 1'b1;          

            end
          end
        end

        if (fsm == {2'h1, AES_CTRL_SHADOWED_OFFSET}) begin
          // $display("count %0h.", count);
          // $display("fsm   %0h.", fsm);
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_CTRL_SHADOWED_OFFSET;
            h2d.a_data    <= {1'b1, 3'b001, 4'b0001, 1'b0}; // manual_operation=manual, key_len=aes_128, mode=aes_ecb, operation=encrypt
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY0_OFFSET};
          end
        end

        if (fsm == {1'b1, AES_KEY0_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY0_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY1_OFFSET};
          end
        end

        if (fsm == {1'b1, AES_KEY1_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY1_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY2_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY2_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY2_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY3_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY3_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY3_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY4_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY4_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY4_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY5_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY5_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY5_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY6_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY6_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY6_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_KEY7_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_KEY7_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_KEY7_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_IV0_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_IV0_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_IV0_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_IV1_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_IV1_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_IV1_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_IV2_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_IV2_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_IV2_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_IV3_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_IV3_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_IV3_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_DATA_IN0_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN0_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_DATA_IN0_OFFSET;
            h2d.a_data    <= 32'b01;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_DATA_IN1_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN1_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_DATA_IN1_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_DATA_IN2_OFFSET};
          end
        end
        
        if (fsm == {1'b1, AES_DATA_IN2_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_DATA_IN2_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_DATA_IN3_OFFSET};
          end
        end

        if (fsm == {1'b1, AES_DATA_IN3_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_DATA_IN3_OFFSET;
            h2d.a_data    <= 32'b0;//$random;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= {1'b1, AES_TRIGGER_OFFSET};
          end
        end

        if (fsm == {1'b1, AES_TRIGGER_OFFSET}) begin
          if (count % 32'h8 == 0) begin
            h2d.a_address <= AES_TRIGGER_OFFSET;
            h2d.a_data    <= 1'b1;
            h2d.a_mask     <= 4'b1111;
          end else if (count % 32'h8 == 7) begin
            fsm <= 9'h100;
          end
        end

        if (fsm == 9'h100) begin
          h2d.a_valid    <= 1'b1;
          fsm <= 9'h100;

          h2d.a_opcode   <= 3'b001;//32'b0;//
          h2d.a_address  <= AES_STATUS_OFFSET;

          if (d2h.d_data == 4'b1101) begin
            test_done_o <= 1'b1;
          end

          $display("d2h.d_data %0h.", d2h.d_data);
        end
      // above works

      if (count > 32'h8FF) begin
        test_done_o <= 1'b1;
      end
    end

    // $display("Loop %0d.", count);
    // $display("h2d.a_data %0d.", h2d.a_data);
  end


endmodule


