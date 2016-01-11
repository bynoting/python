import twisted
from twisted.internet import reactor
from twisted.internet.protocol import Protocol,ClientCreator
from twisted.internet.protocol import Factory,ClientFactory

class servPortocol(Protocol)：
	pass

if __name__ == "__main__":
	sFactory = Factory()

	reactor.listenTCP(10001,sFactory)
	reactor.run()

