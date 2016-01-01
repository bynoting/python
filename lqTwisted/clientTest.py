from twisted.internet.defer import Deferred
from twisted.internet.protocol import Protocol
from twisted.internet.protocol import ClientFactory
from twisted.internet import reactor
from twisted.python import log
from twisted.internet import defer
import sys

host = "58.30.28.131"
port = 9111

class MyPortocol(Protocol):
	def __init__(self):
		pass
	def connectionMade(self):
		log.msg("MyPortocol connectionMade")
	def dataReceived(self, data):
		log.msg("MyPortocol data is " + data)
		self.factory.GetData(data)
	def connectionLost(self, reason):
		log.msg("MyPortocol " + str(reason) )


class Myfactory(ClientFactory):
	protocol = MyPortocol
	def __init__(self,callback):
		self.callback = callback
	def startedConnecting(self, connector):
		log.msg("Myfactory start Connect!")
	def GetData(self,data):
		log.msg("Myfactory GetData " + data)
		self.callback(data)
	def clientConnectionLost(self, connector, reason):
		log.msg("Myfactory clientConnectionLost " + reason)


def main():

	def getServData(data):
		log.msg("main get data "+data)

	log.startLogging(open("my.log","a"))
	factory = Myfactory(getServData)

	reactor.connectTCP(host,port,factory)
	reactor.run()

if __name__=="__main__":
	main()