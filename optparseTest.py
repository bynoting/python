__author__ = 'lq'
#coding=gbk

# Ĭ�ϲ���optionִ�з�������ֵ {}[]
# eg��ִ�� python optparse.Test.py 10000 20000  �� _���Ե�һ������
from optparse import OptionParser

parser = OptionParser()


_,address = parser.parse_args()

print address
