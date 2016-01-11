# coding=gbk
__author__ = 'Administrator'
from twisted.internet.protocol import Protocol,ClientCreator

from twisted.internet import reactor
def sendmsg(data):
	print "main send msg"

class SendMsgObj(Protocol):
	def __init__(self):
		pass
	def connectionMade(self):
		print "connectionMade"
		self.transport.write("hello i m client")
		pass
	def set_protocol(self):
		print "send someting"
		pass
	def dataReceived(self,data):# 此data为被监控主机返回数据
		print data
		pass
	def connectionLost(self,reason):
		print "connectionLost"
		pass

print "created"
c = ClientCreator(reactor,SendMsgObj)

d = c.connectTCP("127.0.0.1",8000)

d.addCallback(sendmsg)
reactor.run()


