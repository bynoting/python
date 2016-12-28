# coding=utf-8
'''
来源自网络：修正了python3下的写法:print
'''
from time import * 
from subprocess import * 
  
  
#webf= open("webs.txt","r") 
webs=["127.0.0.1"] 
'''
for w in webf: 
    webs.append(w.strip()) 
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
  
  
def netCheck(): 
    while True: 
        for url in webs: 
            p = Popen(["ping.exe",url,"-t"], stdin=PIPE,stdout=PIPE,stderr=PIPE, 
                       shell=True)
            #注意此处，read出来的是bytes类型 b\0x.. ,需要进行解码转换为str(unicode)。进过尝试是gb2312
            out = p.stdout.read().decode('gbk')
             
            if out==None:
                break
            print("out value is:%s"%out)
            log = open("log\\"+url+".log","a") 
  
            logAppend(log,out) 
            log.close() 
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
