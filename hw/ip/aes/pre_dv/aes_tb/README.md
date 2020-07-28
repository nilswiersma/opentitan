verilator testbench for hw/ip/aes

highly based on ../aes_sbox_tb

from opentitanroot:

`fusesoc --cores-root=. run --setup --build lowrisc:dv_verilator:aes_tb`

`./build/lowrisc_dv_verilator_aes_tb_0/default-verilator/Vaes_tb --trace`

`gtkwave sim.fst`