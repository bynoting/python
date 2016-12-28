from twisted.internet.defer import Deferred
class argsobj(object):
	def __init__(self,aArg):
		self.arg = aArg

def got_poem(res):
	print 'Your poem is served:'
	print res.arg , type(res)

def poem_failed(err):
	print 'No poetry for you.'

d = Deferred()

# add a callback/errback pair to the chain
d.addCallbacks(got_poem, poem_failed)

# fire the chain with a normal result
d.callback(argsobj('This poem is short.'))

print "Finished"
