# ###coding=utf-8
# coding=gbk
'''
检查windows进程(执行时候需要在windows环境下点击脚本方式运行！)
'''
import subprocess , sys , time

p=subprocess.Popen(['ping','127.0.0.1','-t','10'], stdin = subprocess.PIPE, 
                                         stdout = subprocess.PIPE, 
                                         stderr = subprocess.PIPE, 
                                         shell = True)
msg = p.read()

f= open("d:\\log.txt",mode='w',)
f.write(msg)
print("ok")