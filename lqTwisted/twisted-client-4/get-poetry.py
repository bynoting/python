__author__ = 'lq'


class PoetryClientFactory(ClientFactory):
	protocol=PoetryProtocol
	def __init__(self,):
def get_poetry(host,port):
	d=defer.Deferred()

	from twisted.internet import reactor
	factory=PoetryClientFactory(d)

	reactor.connectTCP(host,port,factory)
	return d
