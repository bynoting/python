# coding=gbk
from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import socket
import gevent
from gevent import Greenlet


class SocketPool(object):
	def __init__(self):
		self.pool = Pool(1000)
		self.server()

	# 适合聊天室的按回车发送文本方式
	def listen( self, socket,address):
		f = socket.makefile()
		print "listen"
		while True:
			name = f.readline().strip()
			print name

	def listen2( self, socket,address):
		print "listen2"
		while True:
			name =socket.recv(1010).strip()
			print name

	def add_handler( self, socket,address):
		if self.pool.full():
			raise Exception( "At maximum pool size")
		else:
			print (" pool insert")
			s = self.pool.spawn(self.listen2(socket,address))

			# self. pool.spawn( self. listen, socket,address)

	def shutdown( self):
		self. pool. kill()

	def server(self):
		print "server"
		server = StreamServer(('0.0.0.0', 8000), self.add_handler)
		server.serve_forever()

	# def connection_handler(self,socket,address):
	# 	socket.send("server send to client ")
	# 	socket.close()


if __name__ == "__main__":
	socketpool = SocketPool()

	# socketpool.listen(clientsocket)
	# for a in range(100):
	# 	socketpool.add_handler(socketpool)









