from twisted.internet.defer import Deferred
from twisted.internet.protocol import Protocol
from twisted.internet.protocol import ClientFactory
from twisted.internet import reactor
from twisted.python import log
import sys

host = "58.30.28.131"
port = 9111

class MyPortocol(Protocol):
	def __init__(self):
		pass
	def connectionMade(self):
		log.msg("MyPortocol>> connectionMade")
	def dataReceived(self, data):
		log.msg("MyPortocol>> data is " + data)
		self.factory.GetData(data)
	def connectionLost(self, reason):
		log.msg("MyPortocol>> connectionLost  " + str(reason.value) )


class Myfactory(ClientFactory):
	protocol = MyPortocol
	def __init__(self,deferred):
		self.deferred= deferred

	def startedConnecting(self, connector):
		log.msg("Myfactory>> start Connect!")

	def GetData(self,data):
		log.msg("Myfactory>> GetData " + data)
		if self.deferred is not None:
			d,self.deferred = self.deferred,None
			d.callback(data)

	def clientConnectionLost(self, connector, reason):
		# log.msg("Myfactory>> clientConnectionLost " )
		if self.deferred is not None:
			log.msg("Myfactory>> clientConnectionLost " )
			d,self.deferred = self.deferred,None
			d.errback(reason)


def main():
	def getServData(data):
		log.msg("main>> callback: getServData "+data)

	def notgetServData(er):
		log.msg("main>> errback: notgetServData"+ er.value.args[0])
	def actionDone(data):
		if data is not None:
			log.msg("main>> actionDone :"+data)
		else:
			log.msg("main>> actionDone: err None" )
		reactor.stop()

	log.startLogging(open("my.log","w"))
	d = Deferred()
	d.addCallback(getServData)
	d.addErrback(notgetServData)
	d.addBoth(actionDone)
	factory = Myfactory(d)

	reactor.connectTCP(host,port,factory)
	reactor.run()

if __name__=="__main__":
	main()