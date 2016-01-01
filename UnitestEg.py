# coding=utf-8
'''
Created on 2013-9-8

@author: lq

'''
import sys
import os
import win32serviceutil
from subprocess import *
from multiprocessing import Process
import multiprocessing as mul
# res = call(('dir' ,r'c:\windows\addins'),shell=True)

print os.path.abspath( os.path.basename(os.path.curdir) )
#cpu num

print mul.cpu_count()

a =1.1
a = round(2/3,2)
print a

b = [1,1,1,1]
print b*10

for path in sys.path: 
    print path

print  float('12213.120')
raw_input()


str = "/"
print str[1:]

def argstest(a,b=1):
    print a,
    print b

argstest(1,3)



