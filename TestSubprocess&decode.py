#coding=gbk
__author__ = 'lq'

import subprocess
# Todo: subprocess Popen :��ȡ��������Ľ��
o = subprocess.Popen('ping 127.0.0.1',stdout=subprocess.PIPE,shell=True)
print "subprocess..."

s = o.stdout.readline()

while(s):
    #TODO�� python Ĭ�ϱ���Ϊunicode��decode��unicode����gbk
    print s.decode("gbk")

    s = o.stdout.readline()


i = 1
j =10
