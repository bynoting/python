from gevent.pool import Pool
from gevent.server import StreamServer
import gevent
from gevent import Greenlet
import zmq.green as zmq
context = zmq.Context()

class SocketPool( object):
	def __init__( self):
		self.pool = Pool(1000)
		self.pool.start(Greenlet())

	def listen( self, socket):
		while True:
			socket.recv()
	def add_handler( self, socket):
		if self. pool. full():
			raise Exception( "At maximum pool size")
		else:
			self. pool. spawn( self. listen, socket)
	def shutdown( self):
		self. pool. kill()
	def server(self):
		server = StreamServer(('0.0.0.0', 8000), connection_handler)
		server.serve_forever()
	def connection_handler(self,socket,address):
		socket.send("server send to client ")
		socket.close()


if __name__ == "__main__":
	socketpool = SocketPool()
	clientsocket = context.socket(zmq.REQ)
	clientsocket.connect("tcp://127.0.0.1:5000")
	socketpool.listen(clientsocket)
	for a in range(100):
		socketpool.add_handler(socketpool)









