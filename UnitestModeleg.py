# coding=utf-8
'''
Created on 2013-9-8

@author: lq

'''
# import sys
# import os
# import win32serviceutil
# from subprocess import *
# from multiprocessing import Process
# import multiprocessing as mul
# # res = call(('dir' ,r'c:\windows\addins'),shell=True)
#
#
# # coding: utf-8
#
#
#
#
# print os.path.abspath( os.path.basename(os.path.curdir) )
# #cpu num
#
# print mul.cpu_count()
#
# a =1.1
# a = round(2/3,2)
# print a
#
# dicc = {"1":1,"2":2}
# rtn = [dicc]
# print type(rtn)
#
# print hasattr(dicc,"__iter__")
# for path in sys.path:
#     print path
# raw_input()
#
#
# a= []
# a[0] = '1'
# a[1] = "2"
#
# print a

def creater():
    print 'init'
    for i in range(2):
        yield i*2

def custom(c):
    #next(c)
    for i in range(2):
        m = next(c)
        print "%i creater %i"%(i,m)
c = creater()

custom(c)








