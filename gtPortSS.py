# coding=gbk
import gevent
from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import socket

class InnerServer(object):
	def __init__(self):
		print "__init__"
		# gevent.joinall([gevent.spawn(self.server())])
		self.pool = Pool(100)
		self.pool.add(self.server())

		print "__init__ed"

	def testPort(self, ipport):
		print "端口【%s】开始测试"%ipport[1]
		try:
			clientSocket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
			clientSocket.connect(ipport)
			clientSocket.send("it's server msg")
			s = clientSocket.recv(1024)
			print "端口【%s】测试ok!"%ipport[1]
		except Exception ,e:
			raise

	def listen2test( self, socket,address):

		print "listen"

		try	:
			f = socket.makefile()
			ports = f.readline().strip()
			port_list = ports.split()
			print port_list
			if port_list :
				ipport_list = [(address[0],port) for port in port_list ]
				self.pool.map(self.testPort,ipport_list)
		except Exception,e:
			raise

	def server_handler(self, socket, address):
		if self.pool.full():
			raise Exception( "At maximum pool size")
		else:
			print (" pool insert")
			s = self.pool.spawn(self.listen2test(socket,address))
			# self. pool.spawn( self. listen, socket,address)

	def shutdown( self):
		self. pool. kill()

	def server(self):
		print "server"
		#gevent.sleep(0)
		server = StreamServer(('0.0.0.0', 9015), self.server_handler)
		server.serve_forever()

if __name__ == "__main__":
	innerServer = InnerServer()


