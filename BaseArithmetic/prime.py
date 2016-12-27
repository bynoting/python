#coding=gbk

# 素数 求值 （一句话?）


def f2(unknow):
	for i in range(2,unknow):
		if unknow%i == 0 :
			print "%s is not prime data"%unknow
			return

	print "%s is prime data" % unknow
# print map( f,[3] )
f2(6)

import sys
print sys.getdefaultencoding()