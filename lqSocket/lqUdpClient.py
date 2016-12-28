#coding=gbk

__author__ = 'lq'
import struct
import socket
import sys
import os
import time
def run():
    HOST='127.0.0.1'
    PORT=9999
    BufferSize = 1000
    ReadSize =2000
    print sys.getdefaultencoding()

    s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)     #udp
    # d = s.getsockopt(socket.SOL_SOCKET,socket.SO_SNDBUF) 取得win下send buffer 8192
    s.setsockopt(socket.SOL_SOCKET,socket.SO_SNDBUF,BufferSize)
    #Todo:当send数据长度大于socket缓冲区大小，不管window还是linux，send都会分帧发送。。
    # 引自 http://www.360doc.com/content/13/0913/15/13047933_314202256.shtml
    # get file size
    f = open("春秋左传1.txt", 'rb')
    filesize = os.path.getsize("春秋左传1.txt")
    print "filesize:" + str( filesize)
    s.sendto(struct.pack("6si",'@size@',filesize),(HOST,PORT))

    data = f.read(ReadSize)
    print "tell len" + str( f.tell() )
    while (data!=''): #文本以''结尾
        print repr(data)
        print 'send len' +str(len(data))
        time.sleep(0.05)
        s.sendto(data,(HOST,PORT))

        #f.seek(ReadSize,1)
        data = f.read(ReadSize)
        # if not data :
        #     break

    data2=s.recv(1024)     #把接收的数据定义为变量
    strs = data2.decode('gbk')
    print strs         #输出变量
    s.close()   #关闭连接

if __name__ == "__main__":
    run()
