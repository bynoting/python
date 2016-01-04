# coding=gbk
from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import socket
import gevent
from gevent import Greenlet

# 简单的socket服务模型，
def server():
    server = StreamServer(('0.0.0.0', 8000), shandler)
    server.serve_forever()
def shandler(socket,address):
    print address

    print socket.recv(10)

    socket.send("good")

 
if __name__ == '__main__':
    t = gevent.spawn(server())
    t.start()