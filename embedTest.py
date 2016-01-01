__author__ = 'lq'

def deco(func):
	def _deco(a,b):
		print "before myfunc() called"
		ret = func(a,b)
		print "after myfunc() called"
		return ret
	return func
@deco
def myfunc(c,d):
	print " myfunc() called "
	return c + d

myfunc(1,2)
myfunc(3,4)
