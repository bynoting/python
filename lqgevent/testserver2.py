# coding=gbk
from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import socket
import gevent
from gevent import Greenlet

# 简单的socket服务模型，
def server(port):
    server = StreamServer(('0.0.0.0', port), shandler)
    server.serve_forever()
def shandler(socket,address):
    print address

    print socket.recv(10)

    socket.send("good")

if __name__ == '__main__':
    mypool = Pool(2)
    mypool.map(server,[8000,8001,8002])
    print "map starting ..."
    # mypool.kill()
    # t = gevent.spawn(server())
    # t.start()