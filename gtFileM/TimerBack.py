#coding=gbk

__author__ = 'Administrator'


'''
���ڶ�ʱ����ı��ݳ���:���������ļ��м����ļ��С��ļ�
'''

import logging
import time
import os
import shutil
logging.basicConfig\
	(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='myapp.log',
                filemode='w')

LocalDir = "D:\\gt"
BackDir = "d:\\gtbk"
today = os.path.join( BackDir , time.strftime('%Y%m%d'))
now = time.strftime('%H%M%S')

def main():
	if not os.path.exists(today):
		#os.mkdir(today)
		shutil.copytree(LocalDir,today)
logging.info(1,"backup is going..")
if __name__ == "__main__":
	try:
		main()
	except Exception as e:
		logging.warning(e.message)
	finally:
		logging.info("backup is finished!")