import pexpect
import sys
import getpass

def main():
    demo1()

def demo1():
    try:
        child = pexpect.spawn("ftp")
        child.expect("ftp>")
    except Exception ,e:
        print "except !!!!!!!!!!!!!!!" + e.message
    finally:
        print ">>>>>>>>>>>>>>>>>>>>>>>>end"

if __name__ == "__main__":
    main()