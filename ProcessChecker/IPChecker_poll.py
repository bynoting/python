#coding=utf-8
import subprocess
'''
Python实时获取命令行输出范例
'''
popen = subprocess.Popen(['ping','www.baidu.com','-t'],stdout=subprocess.PIPE,shell=True)
while True:
    next_line = popen.stdout.readline().decode('gbk')#把bytes转为unicode
    if next_line and popen.poll()!=None:
        break
    else:
        print (next_line)



