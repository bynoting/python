# coding=gbk
import sys
import threading
import socket
import optparse
import urllib2,json
import Re
import os
import time
import string

if os.name == 'nt':
    PFENCODE = 'GBK'
else:
    PFENCODE = 'utf-8'

GTIPA ="58.30.28.131"
GTPOR = 9015

IPADRESS = "localhost"
PORT = [9999]

USAGE = "�÷�: ����˿ں�(0��65535������)������Կո�ֿ�"

PORTS = ""
def parse_input():
    printmsg("���Կ�ʼ")
    inputstr = raw_input("%s �����룺"%USAGE)
    inputstr_list =  inputstr.split()
    global PORTS
    PORTS = inputstr

    try:
        return parse_ipport(inputstr_list)
    except Exception, e:
        return None

def printmsgwrap(func):
    def wraper(args):
        print string.join([time.strftime('%Y-%m-%d %H:%M:%S'),args],' ')
    return wraper
@printmsgwrap
def printmsg(msg):
    pass



def parse_ipport(ports):
    if not ports:
        printmsg ("�����쳣��%s"%USAGE)
        raise
    return map(parse_ports, ports)

def parse_ports(port):
    if not Re.match(
            "^([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5])(-([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5]))?$",
             port):
        printmsg( "����˿�[%s]�����Ϲ��� %s"%(port,USAGE) )
        raise
    return port

def sendSelfIP():
    try :
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(10)
        s.connect((GTIPA, GTPOR))
        s.sendall(PORTS)
        s.close()
        return True
    except Exception ,e:
        printmsg( "�޷����ӹ�ͨ�������:%s:�쳣���룺%s \n"%(str((GTIPA,GTPOR)),e.args[0]) )
        return None

def runServer(port):
    try:
        printmsg( "��ʼ����[�˿�:%s]�Ĳ��Լ���.... "%port )
        s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        s.bind((IPADRESS,int(port) ))
        s.listen(10)
        s.settimeout(10)
        while(True):

            conn,addr=s.accept()
            # print '[�˿�:%s] connected by %s \n'%(port,str(addr))
            # while(1):
            data = conn.recv(1024)
            # print '[�˿�:%s] �������� %s \n'% (port,data)
            conn.send ('Done.')
            # print '[�˿�:%s] ��������������\n'% port
            printmsg( '[�˿�:%s] ������ʹ�ã�\n'% port )
        conn.close()
    except Exception ,e:
        printmsg( "[�˿�:%s]�Ĳ���ʧ��%s \n" %(port,e.message) )


def main():

    ports = parse_input()

    ts = []

    r = None
    if ports :
        r = sendSelfIP()

    if r:
        for port in ports:
            t = threading.Thread(target=runServer,args = (port,))
            t.setDaemon(True)
            t.start()
            ts.append(t)

        for t in ts: #todo�� python join ���ᵼ���߳�ѭ���ȴ�
            t.join(10)
    printmsg("���н���!")
    raw_input()

if __name__ == "__main__":

    main()

# not used
def parse_args():
    usage = """�÷�: ����˿ں�(0��65535������)������Կո�ֿ� ...
            """
    parser = optparse.OptionParser(usage)
    _, ports = parser.parse_args()
    if not ports:
        print parser.format_help()
        parser.exit()

    def parse_ports(port):
        if not Re.match("^([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5])(-([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5]))?$", port):
            print parser.format_help()
            parser.exit()
        return port

    return map(parse_ports,ports)

def getIP(port):

    ipinfo = " w_ip = "
    try:
        ipinfo = urllib2.urlopen('http://www.whereismyip.com').read()
        w_ip = Re.search('\d+\.\d+\.\d+\.\d+', ipinfo).group(0)
    except:
        try:
            ipinfo = urllib2.urlopen('http://ip138.com/ip2city.asp').read()
            w_ip = Re.search('\d+\.\d+\.\d+\.\d+', ipinfo).group(0)
        except Exception ,e:
            print str(e)
            return None
    # ������Ϣ����ʱ����
    try:
        kk = urllib2.urlopen('http://ip.taobao.com/service/getIpInfo.php?ip=%s'%str(w_ip)).read()
        kk_dict = json.loads(kk)[u'data']
        data = kk_dict[u'country'].encode(PFENCODE)
        data = data + " " + kk_dict[u'region'].encode(PFENCODE)
        data = data + " " + kk_dict[u'city'].encode(PFENCODE)
        data = data + " " + kk_dict[u'county'].encode(PFENCODE)
        data = data + " " + kk_dict[u'isp'].encode(PFENCODE)

    except Exception ,e:
        print u"��ȡ����IP��ַλ��ʧ�ܡ�".encode(PFENCODE)
        print str(e)
    print u"����IP��".encode(PFENCODE) + str(w_ip)
    print u"����λ�ã�".encode(PFENCODE) + data

    return w_ip,port