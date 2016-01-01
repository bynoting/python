__author__ = 'lq'

import subprocess
# Todo: subprocess Popen :读取命令输出的结果
o = subprocess.Popen('ping 127.0.0.1',stdout=subprocess.PIPE,shell=True)
print "subprocess..."

s = o.stdout.readline()

while(s):
    #TODO： python 默认编码为unicode，decode把unicode—》gbk
    print s.decode("gbk")

    s = o.stdout.readline()


i = 1
j =10
