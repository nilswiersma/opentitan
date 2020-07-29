// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "Vaes_tb.h"
#include "verilated_toplevel.h"
#include "verilator_sim_ctrl.h"

#include <signal.h>
#include <functional>
#include <iostream>
#include <iomanip>
#include <getopt.h>

#include "sim_ctrl_extension.h"

class AESTB : public SimCtrlExtension {
  using SimCtrlExtension::SimCtrlExtension;

 public:
  AESTB(aes_tb *top);

  void OnClock(unsigned long sim_time);

  // add additional args for key and input
  bool ParseCLIArguments(int argc, char **argv, bool &exit_app);
  void PrintHelp() const;

 private:
  aes_tb *top_;
};

// Constructor:
// - Set up top_ ptr
AESTB::AESTB(aes_tb *top) : SimCtrlExtension{}, top_(top) {}

// Function called once every clock cycle from SimCtrl
void AESTB::OnClock(unsigned long sim_time) {
  if (top_->test_done_o) {
    VerilatorSimCtrl::GetInstance().RequestStop(top_->test_passed_o);
    std::cout << std::hex  
      << "aes_key    " 
      << std::setw(8) << std::setfill('0') << top_->aes_key[3] 
      << std::setw(8) << std::setfill('0') << top_->aes_key[2] 
      << std::setw(8) << std::setfill('0') << top_->aes_key[1] 
      << std::setw(8) << std::setfill('0') << top_->aes_key[0] 
      << std::endl 
      << "aes_input  " 
      << std::setw(8) << std::setfill('0') << top_->aes_input[3] 
      << std::setw(8) << std::setfill('0') << top_->aes_input[2] 
      << std::setw(8) << std::setfill('0') << top_->aes_input[1] 
      << std::setw(8) << std::setfill('0') << top_->aes_input[0] 
      << std::endl 
      << "aes_output " 
      << std::setw(8) << std::setfill('0') << top_->aes_output[3] 
      << std::setw(8) << std::setfill('0') << top_->aes_output[2] 
      << std::setw(8) << std::setfill('0') << top_->aes_output[1] 
      << std::setw(8) << std::setfill('0') << top_->aes_output[0] 
      << std::endl;
  }
}

bool AESTB::ParseCLIArguments(int argc, char **argv, bool &exit_app) {
  const struct option long_options[] = {
      {"key", required_argument, nullptr, 'k'},
      {"input", required_argument, nullptr, 'i'},
      {nullptr, no_argument, nullptr, 0}};

  // Reset the command parsing index in-case other utils have already parsed
  // some arguments
  optind = 1;

  while (1) {
    int c = getopt_long(argc, argv, "k:i:h", long_options, nullptr);
    if (c == -1) {
      break;
    }

    // Disable error reporting by getopt
    opterr = 0;

    switch (c) {
      case 0:
        break;
      case 'k': {
        std::string key_str(optarg);
        if (key_str.length() != 32) {
          std::cerr << "ERROR: Invalid --key arg length (" << key_str.length() << "): " << key_str << std::endl;
          return false;
        }
        top_->aes_key[3] = std::stoul(key_str.substr(0,8) , nullptr, 16);
        top_->aes_key[2] = std::stoul(key_str.substr(8,8) , nullptr, 16);
        top_->aes_key[1] = std::stoul(key_str.substr(16,8), nullptr, 16);
        top_->aes_key[0] = std::stoul(key_str.substr(24,8), nullptr, 16);
      } break;
      case 'i': {
        std::string input_str(optarg);
        if (input_str.length() != 32) {
          std::cerr << "ERROR: Invalid --key arg length (" << input_str.length() << "): " << input_str << std::endl;
          return false;
        }

        top_->aes_input[3] = std::stoul(input_str.substr(0,8) , nullptr, 16);
        top_->aes_input[2] = std::stoul(input_str.substr(8,8) , nullptr, 16);
        top_->aes_input[1] = std::stoul(input_str.substr(16,8), nullptr, 16);
        top_->aes_input[0] = std::stoul(input_str.substr(24,8), nullptr, 16);
      } break;
      case 'h':
        PrintHelp();
      case ':':  // missing argument
        std::cerr << "ERROR: Missing argument." << std::endl << std::endl;
        return false;
      case '?':
      default:;
        // Ignore unrecognized options since they might be consumed by
        // other utils
    }
  }

  return true;
}

void AESTB::PrintHelp() const {
  std::cout << "AES TB inputs:\n\n"
               "-k|--key=HEXSTRING\n"
               "  128bit key for AES ECB encrypt\n"
               "  default: 2b7e151628aed2a6abf7158809cf4f3c\n\n"
               "-i|--input=HEXSTRING\n"
               "  128bit input for AES ECB encrypt\n"
               "  default: 6bc1bee22e409f96e93d7e117393172a\n\n"
               "-h|--help\n"
               "  Show help\n\n";
}

int main(int argc, char **argv) {
  int ret_code;
  bool exit_app;

  // Init verilog instance
  aes_tb top;

  top.aes_key[3]   = 0x2b7e1516;
  top.aes_key[2]   = 0x28aed2a6;
  top.aes_key[1]   = 0xabf71588;
  top.aes_key[0]   = 0x09cf4f3c;
  top.aes_input[3] = 0x6bc1bee2;
  top.aes_input[2] = 0x2e409f96;
  top.aes_input[1] = 0xe93d7e11;
  top.aes_input[0] = 0x7393172a;

  // Init sim
  VerilatorSimCtrl &simctrl = VerilatorSimCtrl::GetInstance();
  simctrl.SetTop(&top, &top.clk_i, &top.rst_ni,
                 VerilatorSimCtrlFlags::ResetPolarityNegative);

  // Create and register VerilatorSimCtrl extension
  AESTB aestb(&top);
  simctrl.RegisterExtension(&aestb);

  std::cout << "Simulation of      AES" << std::endl
            << "======================" << std::endl
            << std::endl;

  // Get pass / fail from Verilator
  ret_code = simctrl.Exec(argc, argv);

  return ret_code;
}

