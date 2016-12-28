__author__ = 'lq'

import socket
import time



def main():
	ts = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	ts.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
	ts.connect(("127.0.0.1", 9020))
	while True:
		ts.send('hello world\r\n')
		print('send data')
		time.sleep(10)
if __name__=="__main__":

	main()

