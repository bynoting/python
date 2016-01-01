# -*- coding: utf-8 -*-

'''
Created on 2013-4-17

@author: gtlq
'''



f = open(r"c:\1.txt",mode="r",buffering=1)

for l in f:
    print(l)

f.close()
