import gevent

from gevent.pool import Pool
import zmq
import time
def clientfun(id):
	context = zmq.Context()
	print "start client send data%s"%str(id)
	clientsocket = context.socket(zmq.REQ)

	t = clientsocket.connect("tcp://127.0.0.1:10001")

	print t
	# clientsocket.send("hello")
	# time.sleep(1)
	# print clientsocket.recv()
p = Pool()
p.map(clientfun,xrange(100))
