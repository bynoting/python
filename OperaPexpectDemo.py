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
        print len(list)
        for line in list:
            # if len(line) == 0: # in splitlines ,not need judge this
            #     break
            print "====="
            items = line.split()
            for item in items:
                print item


    finally:
        print "end"
if __name__ == "__main__":
    main()