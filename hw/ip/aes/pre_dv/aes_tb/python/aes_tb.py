#!/usr/bin/python3
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

import subprocess, os

k = os.urandom(16)
aes = Cipher(algorithms.AES(k[::-1]), modes.ECB(), default_backend())
aes_encrypt = aes.encryptor().update

print(__file__)
print(os.path.basename(__file__))
print(os.path.dirname(__file__))
print(os.path.abspath(__file__))
Vexec = os.path.join(os.path.split(os.path.abspath(__file__))[0], 
	'..', '..', '..', '..', '..', '..', 'build', 'lowrisc_dv_verilator_aes_tb_0', 'default-verilator', 'Vaes_tb')

for _ in range(200):
	i = os.urandom(16)
	c = aes_encrypt(i[::-1])[::-1]
	cmd = [Vexec,
		f'-k{k.hex()}',
		f'-i{i.hex()}']

	print(' '.join(cmd))
		
	try:
		o = subprocess.check_output(cmd)#, stderr=STDOUT, shell=True)
		returncode = 0
	except subprocess.CalledProcessError as ex:
		o = ex.output
		returncode = ex.returncode
		if returncode != 1: # some other error happened
			raise

	for o_split in o.split(b'\n'):
		if o_split.startswith(b'aes_key'):
			print('aes_key')
			print(k.hex())
			print(o_split.split(b' ')[-1].decode())
			print(k.hex() == o_split.split(b' ')[-1].decode())

		if o_split.startswith(b'aes_input'):
			print('aes_input')
			print(i.hex())
			print(o_split.split(b' ')[-1].decode())
			print(i.hex() == o_split.split(b' ')[-1].decode())

		if o_split.startswith(b'aes_output'):
			print('aes_output')
			print(c.hex())
			print(o_split.split(b' ')[-1].decode())
			print(c.hex() == o_split.split(b' ')[-1].decode())
