# coding=gbk
import gevent
from gevent.queue import Queue
from gevent.pool import Pool
from gevent import getcurrent

def DoSomething():
	print "thread %s " % id(getcurrent())
	gevent.sleep(3)

# 本测试发现：pool中add 后超出size 限制 即会开始执行，可以看做pool size +1 =限制容量大小
# greenlet 对象在推拉窗模式中 可以复用
pool = Pool(2) # 可并行 n + 1 个任务
print pool.free_count()
pool.add(gevent.spawn(DoSomething))
pool.join()

raw_input("waiting...")
# print "stage"
# for i in range(10):
# 	pool.add(gevent.spawn(DoSomething))
#pool.join()
