# coding=gbk
class P(object):
	def __init__(self):
		print "P is init"
	def show(self):
		print "PPPPP"


class C(P):
	cvar = 10
	def __init__(self):
		#self.cvar = 1000
		super(C,self).__init__()
		print "C is init"
	def show(self):
		super(C,self).show()
		print "CCCC"
class N(object):
	r = object

	def show(self):
		instans = self.r() 
		print type(instans)
		instans.prt()
		print "I am N"


def objectShow(ac):
	ac.show()


class reftest(object):
	def __init__(self):
		print "reftest is ref!"
	def prt(self):
		print "reftest is prt ref!!!"

if __name__ == "__main__":
	o = N()
	# 动态实例化
	o.r = reftest
	o.show() # duck type


	# inst = o.r()
	# inst.prt()

	o.cvar=2000
	# C.cvar = 10000


	print C.cvar
	print o.cvar

