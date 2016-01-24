# coding=gbk
# __author__ = 'lq'
import gevent
import time
from gevent.threadpool import ThreadPool


def dosomething1(i):
	gevent.sleep(5)

	print i +11


def dosomething2(i):
	gevent.sleep(5)
	print i + 1000


def job():

	# gevent.joinall([gevent.spawn(dosomething1,2),gevent.spawn(dosomething2,2)])
	import time
	import gevent
	from gevent.pool import Pool
	from gevent import threadpool

	# todo：注意map的 Pool和threadPool的区别。 pool 处理 非IO 耗时计算时没有 显式gevent.sleep() 就会变成同步程序。。。换成threadPool
	pool = Pool(3)
	start = time.time()
	# for _ in xrange(2):
	# 	pool.add(gevent.spawn(time.sleep, 1))
	pool.imap(time.sleep,xrange(3))
	gevent.wait()
	delay = time.time() - start
	print 'Running "time.sleep(1)" 4 times with 3 threads. Should take about 2 seconds: %.3fs' %delay

if __name__ == "__main__":
	job()
