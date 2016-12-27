#coding=gbk

# 斐波契纳数列

import os


# 斐波契纳数列1,2,3,5,8,13,21............根据这样的规律，求出400万以内最大的斐波契纳数,并求出它是第几个斐波契纳数？


data1 = 1
data2 = 1
limitdata = 4000000
nums = 2
while(1 == 1 ):

	resultData = data1 + data2

	if resultData >= limitdata :
		print "Max Fibomacci data is %s,and the nums is %s "%(str(data2),str(nums))
		break
	data1,data2 = data2,resultData
	nums = nums + 1

