
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
	def show(self):
		print "I am N"

def objectShow(aC):
	ac.show()
if __name__ == "__main__":
	o = N()
	o.show() # duck type
	o.cvar=2000
	# C.cvar = 10000


	print C.cvar
	print o.cvar

