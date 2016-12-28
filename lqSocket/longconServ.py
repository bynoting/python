__author__ = 'lq'

import gevent

from gevent.server import StreamServer

def shandler(socket,address):
	while True:
		data = socket.recv(10)
		print data

def main():
	ss = StreamServer(("0.0.0.0",9020) ,shandler)
	ss.serve_forever()

if __name__=="__main__":

	main()

