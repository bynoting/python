#!/usr/bin/python
import subprocess

def runSSh():

    #ssh -t -D 0.0.0.0:9999 585c9c8e2d527108680000dc@wp-maodou.rhcloud.com
    sshargs = ("{cmd} {argTty} {argPort} {IP}:{Port} {sshKey}".\
        format(cmd="ssh",argTty="-t",argPort="-D",IP="0.0.0.0",Port ="9999",sshKey="585c9c8e2d527108680000dc@wp-maodou.rhcloud.com") )
    o = subprocess.Popen(sshargs,stdout=subprocess.PIPE,shell= False)
    l = o.stdout.readline()
    while(l):
        print l
    runSSh()

runSSh()