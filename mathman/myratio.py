#coding=gbk
'''
lq create 2015-03-12
get the ritio number
����������ֵ�ı���
'''


import os
import re

#check the input data famat
def checkData(inputData):
    isnumber = re.match('^[^0]\d+$',str(inputData) )
    if not isnumber :
        print "the data:" + str(inputData) +" not valid"
        sys.exit(0)
    return 1

#gongyueshu ��Լ��
def gongyueshu(m,n):    
    if m<n:        
        small = m    
    else:        
        small = n    
    for i in range (small,0,-1):        
        if m % i == 0 and n %i == 0:           
            return i
#gongbeishu ������
def gongbeishu(m,n):    
    gongyue = gongyueshu(m,n)    
    return (m*n)/gongyue

def getritio( one ,two ,gongyueData ):
    i = one/gongyueData
    j = two/gongyueData
    return str(i) + '/' + str(j)

a = raw_input("Please input data1:")
b = raw_input("Please input data2:")
print type(a)

checkData(a)
checkData(b)

c = gongyueshu(int(a),int(b))
print "��Լ�� is:%i" %  c

print "ritio�����ݱ�����" +" is:%s" % getritio(int(a),int(b),c)











    


