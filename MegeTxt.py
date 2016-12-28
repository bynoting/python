
'''
Created on 2012-3-24

@author: lq
实现txt文件的合并，并将子文件名作为章节名加入在每章前
要求建立欲生成的文件名的文件夹，将各个子文件放在该文件夹下，脚本也放置到该目录下执行。
'''
# ## coding=utf-8
#coding=gbk
import os
import codecs
 #os.path.abspath(os.curdir)
 
_curpath = os.path.abspath(os.curdir)
_filelist=[]

#切换到当前目录
os.chdir(_curpath)
print('curpath:',_curpath)

_newFileName = os.path.basename(_curpath) +'.txt'
print ("new file name is:",_newFileName)
if os.path.isfile(_newFileName): 
    os.remove(_newFileName)
    
for file in os.listdir(_curpath) :
    #print(os.path.abspath(file))
    if os.path.isfile(file):  
        #过滤掉其他文件
        if str(file).endswith('.txt')  :  
            _filelist.append(file)
            
        pass;
    else:
        pass;
print('Begin Deal files\r\n','================')

def DoWork():
    _filelist.sort(key=None, reverse=False)
    print( os.path.abspath(_filelist[0]))
    
    f = open(_newFileName,'a')#,-1,'gbk')
    
    for fitem in _filelist:  
       
        title = os.path.basename(fitem);
        title = os.path.splitext(title)[0]
        
        #print('标题：',title)
        print('fitem:',fitem)        
        f1 = open(fitem,'r')#,-1,'gbk')
        
        #print('类型 the type is :',type(f1))
        filesize = os.path.getsize(fitem )
                
        #print('file size is %d'%filesize)   
        detail =f1.read()
        
        f.write(title)
        f.write(detail)
        #print (str)
        f1.close() 
         
        pass;
    f.close();
    
DoWork()
    



