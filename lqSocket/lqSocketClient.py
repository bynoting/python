#coding=gbk
__author__ = 'lq'
import socket
import sys


def run():
    HOST='127.0.0.1'
    PORT=9999

    print sys.getdefaultencoding()
    s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)      #����socket���ͣ�����ͨ�ţ�TCP
    s.connect((HOST,PORT))       #Ҫ���ӵ�IP��˿�
    while 1:
        cmd=raw_input("Please input cmd:")       #���˽�������������
        f = open("������.txt",'r')
        data = f.read()
        s.sendall(data)      #������͸��Զ�
        data2=s.recv(1024)     #�ѽ��յ����ݶ���Ϊ����
        str = data2.decode('gbk')
        print str         #�������
    s.close()   #�ر�����

if __name__ == "__main__":
    run()
