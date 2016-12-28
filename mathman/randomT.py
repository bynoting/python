#coding=gbk
__author__ = 'Administrator'
import random
#随机数1 ： 不重复g
print random.sample(['a', 'b', 'c', 'd'], 3)
print sorted( random.sample(range(1,6),5) )
#随机数2：

print random.randint(1,5)

print sorted([random.randint(1,20) for _ in range(10)])
