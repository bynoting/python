#coding=gbk
__author__ = 'lq'

import struct
import socket

IPADRESS = "localhost"
PORT = 9999

#��Э���� ͷ�� 6s + data �壺����
def runServer():
    s = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    s.bind((IPADRESS,PORT))
    Wsize = 0
    Fsize = 0
    while(1):
        data = s.recvfrom(2000) #return truple��data,ipport��
        print data

        if data[0][0:6] == '@size@':
            sstr , Fsize = struct.unpack("6si",data[0])
            print "Fsize:"+str(Fsize)
        else:

            writeFile(data[0])
            print "write len:" +str(len(data[0]) )
            Wsize += len(data[0])
            if Wsize>=Fsize:
                print "break!!%s"%(str(Wsize))
                break


    s.sendto('Done',data[1])


def writeFile(data):
    f = open("netfile.txt",'a')
    f.write(data)
    f.close()
if __name__ == "__main__":
    runServer()
