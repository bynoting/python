__author__ = 'lq'
#coding = gbk

import zmq.green as zmq
context = zmq.Context()

if __name__ = "__main__":
	clientsocket = context.socket(zmq.REQ)
	clientsocket.connect("tcp://127.0.0.1:5000")