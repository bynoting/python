# coding=gbk
import gevent
import string
import time
from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import socket

def printmsgwrap(func):
	def wraper(args):
		print string.join([time.strftime('%Y-%m-%d %H:%M:%S'), args], ' ')

	return wraper

@printmsgwrap
def printmsg(msg):
	pass
class InnerServer(object):
	def __init__(self):
		printmsg( "__init__" )
		# gevent.joinall([gevent.spawn(self.server())])
		self.pool = Pool(100) # 用Pool 承载所有的IO线程
		self.pool.add(self.server())

		printmsg( "__init__ed" )

	def testPort(self, ipport):
		printmsg( "端口【%s】开始测试"%str(ipport))
		try:
			clientSocket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
			clientSocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
			clientSocket.connect(ipport)
			clientSocket.send("it's server msg")
			s = clientSocket.recv(1024)
			printmsg ( "端口【%s】测试ok!"%str(ipport))
		except Exception ,e:
			raise

	def listen2test( self, socket,address):

		printmsg ("%s listen start"%str(address) )

		try	:
			f = socket.makefile()
			ports = f.readline().strip()
			port_list = ports.split()
			printmsg ( str( port_list ) )
			if port_list :
				ipport_list = [(address[0],port) for port in port_list ]
				self.pool.map(self.testPort,ipport_list)
		except Exception,e:
			raise

	def server_handler(self, socket, address):
		if self.pool.full():
			raise Exception( "At maximum pool size")
		else:
			printmsg (" pool insert ")
			s = self.pool.spawn(self.listen2test(socket,address))
			# self. pool.spawn( self. listen, socket,address)

	def shutdown( self):
		self. pool. kill()

	def server(self):
		printmsg ("server start ")
		#gevent.sleep(0)
		server = StreamServer(('0.0.0.0', 9015), self.server_handler)
		server.serve_forever()

if __name__ == "__main__":
	innerServer = InnerServer()


