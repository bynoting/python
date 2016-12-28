#coding=gbk

import os

def deleteFile():
    #dofile = "_desktop.ini"
    dofile = ".pyc"
    a = os.curdir

    for rootpath,dirnames,filenames in os.walk(a) :
        for fname in filenames :
            print os.path.splitext(fname)
            if os.path.splitext(fname)[1] :
                if os.path.splitext(fname)[1] == dofile:
                    print os.path.splitext(fname)[1]
                    # 注意 用os.path 得到的 curdir 都是 顶层curdir（以“.”表示）
                    # print 得到是 
                    dfname =  os.path.join(rootpath,fname)
                    print dfname
                    if os.path.isfile(dfname):
                        os.remove( dfname )
                    
    exit = raw_input("exit")

if __name__=="__main__":
    import traceback
    try:        
        deleteFile()
       
    except Exception ,e:
        f = open('deletefile-error.txt','w')
        traceback.print_exc( file = f )
     
        f.writelines(os.path.abspath(os.curdir))
        f.flush()
        
        f.close()
        print "出现异常：",e

        
