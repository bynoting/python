#coding=gbk
__author__ = 'lq'
import socket
import sys


def run():
    HOST='127.0.0.1'
    PORT=9999

    print sys.getdefaultencoding()
    s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)      #定义socket类型，网络通信，TCP
    s.connect((HOST,PORT))       #要连接的IP与端口
    while 1:
        cmd=raw_input("Please input cmd:")       #与人交互，输入命令
        f = open("春秋左传.txt",'r')
        data = f.read()
        s.sendall(data)      #把命令发送给对端
        data2=s.recv(1024)     #把接收的数据定义为变量
        str = data2.decode('gbk')
        print str         #输出变量
    s.close()   #关闭连接

if __name__ == "__main__":
    run()
