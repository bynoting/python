__author__ = 'lq'
# coding=gbk

import zmq.green as zmq
context = zmq.Context()

# todo : zmq �е� socket ���ܵ���ʹ�á��������REQ �ͺ�REP ��Ӧ
if __name__ == "__main__":
	clientsocket = context.socket(zmq.REQ)
	clientsocket.connect("tcp://127.0.0.1:999")
	clientsocket.send("ddd")
	s = clientsocket.recv()
	print s