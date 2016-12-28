# -*- coding: utf-8 -*-
'''
Created on 2013-3-23
python 不会执行基类默认构造函数
@author: lq
'''

import os
import sys
from simpleClass import *
class children(parent):
    #def __init__(self,str):
    #   print("child %s"%str)
    def __init__(self):
        parent.__init__(self)
        print("child init")
        self.data1="good"
    def showDir(self):
        print(dir(self))

c = children()

c.showDir()
print(c.data1)

        



