__author__ = 'lq'
import gevent

def job():

	t = gevent.spawn(lambda x:x+1,2)

	t.join()

if __name__ == "__main__":
	job()
