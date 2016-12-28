#coding=gbk
import socket
import os
# source from http://blog.csdn.net/rebelqsp/article/details/22109925
__author__ = 'Administrator'
IPADRESS = "localhost"
PORT = 9999
def runServer():
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.bind((IPADRESS,PORT))
    s.listen(100)
    while(True):
        conn,addr=s.accept()
        print 'connected by %s'%(str(addr))
        while(1):
            
            data = conn.recv(1024*1000)
            writeFile(data)
            conn.sendall('Done.')

    conn.close()

def writeFile(data):
    f = open("netfile.txt",'w')
    f.write(data)
    f.close()
if __name__ == "__main__":
    runServer()

