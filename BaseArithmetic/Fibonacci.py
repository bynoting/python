#coding=gbk

# 쳲���������

import os


# 쳲���������1,2,3,5,8,13,21............���������Ĺ��ɣ����400����������쳲�������,��������ǵڼ���쳲���������


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

