#!/usr/bin/python
import subprocess
import shlex

def runSSh():

    #ssh -t -D 0.0.0.0:9999 585c9c8e2d527108680000dc@wp-maodou.rhcloud.com
    args ="{cmd} {argTty} {argPort} {IP}:{Port} {sshKey}".format(cmd="ssh",argTty="-t",argPort="-D",IP="0.0.0.0",Port ="9999",sshKey="585c9c8e2d527108680000dc@wp-maodou.rhcloud.com")
    print args
    sshargs = shlex.split(  args)
    o = subprocess.Popen(sshargs,stdout=subprocess.PIPE,shell= False)
    x = o.stdout.readline()
    while(x):
        print x
        x = o.stdout.readline()



runSSh()
