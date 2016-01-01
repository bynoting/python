# coding=utf-8
'''
os.popen()的做法。
'''
from time import *
import Logger
import os 
  

#webf= open("webs.txt","r") 
webs=["127.0.0.1"] 
'''
for w in webf: 
    webs.append(w.strip()) 
'''

'''
def logAppend(log,info): 
    inttime = time() 
    structtime = localtime(inttime) 
    strtime = strftime("%Y-%m-%d,%H:%M:%S",structtime) 
    print("at ",strtime )
    log.write("==================  "+strtime+"  ==================\n") 
    log.write(info) 
    log.write("\n\n") 
    print("append info to file :",log.name )
    print ( info )
'''  
  
def netCheck(): 
    while True: 
        for url in webs: 
            p = os.popen("ping %s"%url)
            #注意此处，read出来的是str类型
            out = p.read()
             
            if out==None:
                break
            print("out value is:%s"%out)
            log = Logger.Logger("log\\"+url+".log")
            log.LogAppend(out)
            log.LogClose()
##            log = open("log\\"+url+".log","a") 
##  
##            logAppend(log,out) 
##            log.close() 
            sleep(0.01) 
        print( "waiting ..." )
        sleep(60*15) #sleep for 15min. 60*15  
    return 
  
def main(): 
    """
    the main function
    """ 
    print( "start..." )
    netCheck() 
    print ("end." )
  
  
if __name__ == "__main__": 
    main() 
