from gevent.pool import Pool
import gevent
from gevent import Greenlet
from gevent_zeromq import zmq
context = zmq.Context()

class SocketPool( object):
	def __init__( self):
		self.pool = Pool(1000)
		self.pool.start(Greenlet())

	def listen( self, socket):
		while True:
			socket. recv()
	def add_handler( self, socket):
		if self. pool. full():
			raise Exception( "At maximum pool size")
		else:
			self. pool. spawn( self. listen, socket)
	def shutdown( self):
		self. pool. kill()

if __name__ == "__main__":
	socketpool = SocketPool()
	socket = context.socket(zmq.REQ)
	socket.bind("tcp://127.0.0.1:5000")
	socketpool.listen(socket)
	for a in range(100):
		socketpool.add_handler(socket)









