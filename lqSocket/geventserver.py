import gevent

from gevent.pool import Pool

import zmq
import time
def serverfun():
	context = zmq.Context()
	print "start client send data%s"%str(id)
	serversocket = context.socket(zmq.REP)

	t = serversocket.bind("tcp://127.0.0.1:10001")

	while True:
		msg = serversocket.recv()
		print msg
		serversocket.send("server send:%s"%msg)

serverfun()

