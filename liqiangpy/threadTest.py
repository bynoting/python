# -*- coding: utf-8 -*-
'''
Created on 2013-4-8

@author: gtlq
'''
import threading
import time


def threadMethod():
    time.sleep(5)
    print("t thread work is over")
    
t1 = threading.Thread(target=threadMethod,args=())


t1.start()
t1.join()

print("test is over")
