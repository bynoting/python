#coding=gbk
__author__ = 'lq'

import struct
import socket

IPADRESS = "localhost"
PORT = 9999
BUFFERSIZE = 2000
#简单协议体 头： 6s + data 体：数据
def runServer():
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.bind((IPADRESS,PORT))
    s.listen(1)
    Wsize = 0
    Fsize = 0

    sc,address = s.accept()
    while(1):
        data = sc.recv(BUFFERSIZE)
        print repr(data)

        if data[0:6] == '@size@':
            sstr , Fsize = struct.unpack("6si",data)
            print "Fsize:"+str(Fsize)
        else:

            writeFile(data)
            print "write len:" +str(len(data) )
            Wsize += len(data)
            if Wsize>=Fsize:
                print "break!!%s"%(str(Wsize))
                break


    sc.send('Done')


def writeFile(data):
    f = open("netfile.txt",'a')
    f.write(data)
    f.close()
if __name__ == "__main__":
    runServer()
