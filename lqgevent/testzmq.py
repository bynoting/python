__author__ = 'lq'
# coding=gbk

import zmq.green as zmq
context = zmq.Context()

# todo : zmq 中的 socket 不能单独使用。如这里的REQ 就和REP 对应
if __name__ == "__main__":
	clientsocket = context.socket(zmq.REQ)
	clientsocket.connect("tcp://127.0.0.1:999")
	clientsocket.send("ddd")
	s = clientsocket.recv()
	print s