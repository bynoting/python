
import socketclient
import os

s=socketclient.socketclient(socketclient.AF_INET,socketclient.SOCK_STREAM)
s.bind(("192.168.10.155",8000))
s.listen(1)


while 1:

    clientSocket,clientAddr = s.accept()
    print 'Client connected!'
    clientSocket.sendall('Welcome to Python World!')

    clientSocket.close()

print "ok"
