# coding=utf-8
'''
写日志的基本类
'''

import os
from time import *

class Logger:
    def __init__(self,aFileName):
        self.fileName = aFileName
        self.log = open(self.fileName,'a')        
        
    def LogAppend(self,info): 
        inttime = time() 
        structtime = localtime(inttime)
        strtime = strftime("%Y-%m-%d,%H:%M:%S",structtime) 
        print("at ",strtime )
        self.log.write("==================  "+strtime+"  ==================\n") 
        self.log.write(info) 
        self.log.write("\n\n") 
        print("append info to file :",self.fileName )
        print ( info )    

    def LogClose(self):
        self.log.close()

        
