#coding=gbk
__author__ = 'http://www.cnblogs.com/zhangjing0502/archive/2012/05/30/2526552.html'
# 需求：将windows的远程桌面做一个端口转发。
#
# 即：有三台机器分别为A B C.在C上打开远程桌面服务，开启3389端口。
#
#       在B上运行端口转发程序，将发往B的1099端口的数据发送到C的3389.
#
#      这样在A上通过远程桌面客户端访问B的1099端口就可以远程访问C的机器。
from twisted.internet.protocol import Protocol,ClientCreator

from twisted.internet import reactor
from twisted.protocols.basic import LineReceiver
from twisted.internet.protocol import Factory,ClientFactory
from twisted.python import log, logfile

class Transfer(Protocol):
        def __init__(self):
                pass
        def connectionMade(self):
                logshow ("connected")
                c = ClientCreator(reactor,Clienttransfer)
                c.connectTCP("192.168.4.2",3389).addCallback(self.set_protocol) #连接并返回refer，设置callback
                self.transport.pauseProducing() # 代理服务暂停数据接收

        def set_protocol(self,p): #给转发客户端目标设置protocal
                self.client = p
                p.set_protocol(self)

        def dataReceived(self,data):
                logshow ("server data" + data)
                self.client.transport.write(data) # 服务收到数据后由客户端转发数据。此data 为远程客户机发来数据，client 为转发客户端目标

        def connectionLost(self,reason):
                self.transport.loseConnection()
                self.client.transport.loseConnection()

class Clienttransfer(Protocol):
        def __init__(self):
                pass

        def set_protocol(self,p):
                self.server = p    #server 为本地监听服务
                self.server.transport.resumeProducing()
                pass
        def dataReceived(self,data):# 此data为被监控主机返回数据
                logshow ("send data " + data)
                self.server.transport.write(data) # 返回给远程客户端数据
                pass
def logshow(msg):
        print msg


def main():
        logshow ("ready run()")
        factory = Factory()
        factory.protocol = Transfer
        reactor.listenTCP(9012,factory)
        reactor.run()


if __name__=="__main__":
        main()

