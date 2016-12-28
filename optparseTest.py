__author__ = 'lq'
#coding=gbk

# 默认不设option执行返回两个值 {}[]
# eg：执行 python optparse.Test.py 10000 20000  以 _忽略第一个参数
from optparse import OptionParser

parser = OptionParser()


_,address = parser.parse_args()

print address
