# coding=gbk
import gevent
from gevent.queue import Queue
from gevent.pool import Pool
from gevent import getcurrent

def DoSomething():
	print "thread %s " % id(getcurrent())
	gevent.sleep(3)

# �����Է��֣�pool��add �󳬳�size ���� ���Ὺʼִ�У����Կ���pool size +1 =����������С
# greenlet ������������ģʽ�� ���Ը���
pool = Pool(2) # �ɲ��� n + 1 ������
print pool.free_count()
pool.add(gevent.spawn(DoSomething))
pool.join()

raw_input("waiting...")
# print "stage"
# for i in range(10):
# 	pool.add(gevent.spawn(DoSomething))
#pool.join()
