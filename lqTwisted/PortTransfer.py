#coding=gbk
__author__ = 'http://www.cnblogs.com/zhangjing0502/archive/2012/05/30/2526552.html'
# ���󣺽�windows��Զ��������һ���˿�ת����
#
# ��������̨�����ֱ�ΪA B C.��C�ϴ�Զ��������񣬿���3389�˿ڡ�
#
#       ��B�����ж˿�ת�����򣬽�����B��1099�˿ڵ����ݷ��͵�C��3389.
#
#      ������A��ͨ��Զ������ͻ��˷���B��1099�˿ھͿ���Զ�̷���C�Ļ�����
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
                c.connectTCP("192.168.4.2",3389).addCallback(self.set_protocol) #���Ӳ�����refer������callback
                self.transport.pauseProducing() # ���������ͣ���ݽ���

        def set_protocol(self,p): #��ת���ͻ���Ŀ������protocal
                self.client = p
                p.set_protocol(self)

        def dataReceived(self,data):
                logshow ("server data" + data)
                self.client.transport.write(data) # �����յ����ݺ��ɿͻ���ת�����ݡ���data ΪԶ�̿ͻ����������ݣ�client Ϊת���ͻ���Ŀ��

        def connectionLost(self,reason):
                self.transport.loseConnection()
                self.client.transport.loseConnection()

class Clienttransfer(Protocol):
        def __init__(self):
                pass

        def set_protocol(self,p):
                self.server = p    #server Ϊ���ؼ�������
                self.server.transport.resumeProducing()
                pass
        def dataReceived(self,data):# ��dataΪ�����������������
                logshow ("send data " + data)
                self.server.transport.write(data) # ���ظ�Զ�̿ͻ�������
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

