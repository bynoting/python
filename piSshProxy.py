#!/usr/bin/python
import subprocess
import shlex

def runSSh():

    #ssh -t -D 0.0.0.0:9999 585c9c8e2d527108680000dc@wp-maodou.rhcloud.com
<<<<<<< HEAD
    args ="{cmd} {argTty} {argPort} {IP}:{Port} {sshKey}".format(cmd="ssh",argTty="-t",argPort="-D",IP="0.0.0.0",Port ="9999",sshKey="585c9c8e2d527108680000dc@wp-maodou.rhcloud.com")
    print args
    sshargs = shlex.split(  args)
=======
    sshargs = ("{cmd} {argTty} {argPort} {IP}:{Port} {sshKey}".\
        format(cmd="ssh",argTty="-t",argPort="-D",IP="0.0.0.0",Port ="9999",sshKey="585c9c8e2d527108680000dc@wp-maodou.rhcloud.com") )
>>>>>>> a6bb01945a80d51ae59f5952e4e22c1d7041d392
    o = subprocess.Popen(sshargs,stdout=subprocess.PIPE,shell= False)
    l = o.stdout.readline()
    while(l):
        print l

runSSh()
