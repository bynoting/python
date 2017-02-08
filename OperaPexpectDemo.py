import pexpect
import sys
import getpass

def main():
    demo2()

def demo1():
    try:
        child = pexpect.spawn("ftp")
        child.expect("ftp>")
    except Exception ,e:
        print "except !!!!!!!!!!!!!!!" + e.message
    finally:
        print ">>>>>>>>>>>>>>>>>>>>>>>>end"
def demo2():

    try:
        child = pexpect.spawn("sudo lsof -i:9999")
        child.expect(pexpect.EOF)
        out = child.before
        if len(out)==0:
            print "no data"
            return
        print out
        # list = out.split('\r\n')
        list = out.splitlines() # its good ,no more empty line!
        if len(list) < 2: return
        items = list[1].split()
        if len(items) < 2: return
        pidstr = items[1]
        print pidstr


        child = pexpect.spawn( "sudo kill -9 {pid}".format(pid=pidstr) )
        child.logfile = sys.stdout
        child.expect(pexpect.EOF)
        # print child.before

        # child.sendline( "sudo /home/pi/shadowsocks.sh")


    finally:
        print "end"
if __name__ == "__main__":
    main()