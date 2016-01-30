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

USAGE = "用法: 输入端口号(0到65535的整数)，多个以空格分开"

PORTS = ""
def parse_input():
    printmsg("测试开始")
    inputstr = raw_input("%s 请输入："%USAGE)
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
        printmsg ("输入异常，%s"%USAGE)
        raise
    return map(parse_ports, ports)

def parse_ports(port):
    if not Re.match(
            "^([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5])(-([1-9]\d{0,3}|[1-5]\d{4}|6[0-5]{2}[0-3][0-5]))?$",
             port):
        printmsg( "输入端口[%s]不符合规则 %s"%(port,USAGE) )
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
        printmsg( "无法连接国通网络服务:%s:异常代码：%s \n"%(str((GTIPA,GTPOR)),e.args[0]) )
        return None

def runServer(port):
    try:
        printmsg( "开始启动[端口:%s]的测试监听.... "%port )
        s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        s.bind((IPADRESS,int(port) ))
        s.listen(10)
        s.settimeout(10)
        while(True):

            conn,addr=s.accept()
            # print '[端口:%s] connected by %s \n'%(port,str(addr))
            # while(1):
            data = conn.recv(1024)
            # print '[端口:%s] 接收数据 %s \n'% (port,data)
            conn.send ('Done.')
            # print '[端口:%s] 发送数据正常！\n'% port
            printmsg( '[端口:%s] 可正常使用！\n'% port )
        conn.close()
    except Exception ,e:
        printmsg( "[端口:%s]的测试失败%s \n" %(port,e.message) )


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

        for t in ts: #todo： python join 不会导致线程循环等待
            t.join(10)
    printmsg("运行结束!")
    raw_input()

if __name__ == "__main__":

    main()

# not used
def parse_args():
    usage = """用法: 输入端口号(0到65535的整数)，多个以空格分开 ...
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
    # 其他信息，暂时不用
    try:
        kk = urllib2.urlopen('http://ip.taobao.com/service/getIpInfo.php?ip=%s'%str(w_ip)).read()
        kk_dict = json.loads(kk)[u'data']
        data = kk_dict[u'country'].encode(PFENCODE)
        data = data + " " + kk_dict[u'region'].encode(PFENCODE)
        data = data + " " + kk_dict[u'city'].encode(PFENCODE)
        data = data + " " + kk_dict[u'county'].encode(PFENCODE)
        data = data + " " + kk_dict[u'isp'].encode(PFENCODE)

    except Exception ,e:
        print u"获取外网IP地址位置失败。".encode(PFENCODE)
        print str(e)
    print u"外网IP：".encode(PFENCODE) + str(w_ip)
    print u"地理位置：".encode(PFENCODE) + data

    return w_ip,port