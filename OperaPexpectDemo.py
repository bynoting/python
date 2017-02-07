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
        print child.before
    finally:
        print "end"
if __name__ == "__main__":
    main()