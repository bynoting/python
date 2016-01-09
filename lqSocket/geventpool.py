import gevent

from gevent.pool import Pool
import zmq
import time
def client(id):
	context = zmq.Context()
	print "start client send data%s"%str(id)
	clientsocket = context.socket(zmq.REQ)
	clientsocket.connect("tcp://127.0.0.1:10001")
	clientsocket.send("hello")
	time.sleep(1)
	print clientsocket.recv()
p = Pool()
p.map(client,xrange(2))
