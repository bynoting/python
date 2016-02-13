# coding=gbk

from twisted.internet import reactor

from twisted.protocols.basic import LineReceiver

from twisted.internet.protocol import Factory,ClientCreator,Protocol,ClientFactory

from twisted.python import log,logfile


class NatServer(Protocol):
	def __init__(self):
		pass

class



def logShow(msg):
	print msg

def main():

	factory = Factory()
	factory.Portocol = NatServer
	reactor.ListenTCP(9013,factory)
	reactor.run()

if __name__=="__main__":
	main()