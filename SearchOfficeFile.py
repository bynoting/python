#! /usr/bin/env python
#coding=gbk

'''
预期：
按照文件属性查找文件 调用形式：文件 parm1（条件=值） 。。。
条件包括 后缀end 关键字key 内容data    可以用optparse
'''
import os,sys,shutil,re
import logging
import win32com.client
import ctypes
import soaplib
import json

_fileTypes = ("doc","docx") 
_wordKey = "Gtalarm"
_curpath = os.path.abspath(os.curdir)
_rootpath = ''
_condition = ''
_wordContent = ''


# 输入参数包括 ：路径名 条件名
def main():
    # lobal _curpath #3.0下还有一个到上级嵌套的nonlocal    
    global _curpath
    global _list1
    global _list2 
    
    print _curpath    
    ParseArgv()
    
   
    outfile = open('mytmdjsjFile.txt','w')
    DoWork(_curpath,outfile)    
    outfile.close()
    
    #print wordSearch(os.path.j   oin(_curpath, "111.docx"),_wordKey)
    #目前发现不可编辑的文件打开总是报错
    #print wordSearch(r"i:\GTAlarm\工作文件\项目\工行北京分行联网\20110526竞争性谈判\0604\中国工商银行北京市分行视频报警联网项目技术方案(1).doc",_wordKey)
    #os.system("pause")
    input("puase")
    
def DoWork(aDir ,aOutfile):
    # 遍历文件夹下所有的文件
    '''for rootpath,dirnames,filenames in os.walk(aDir):
        for name in filenames:
            absFile = os.path.join(rootpath,name)
            if CheckFile(absFile): 
                print absFile
		aOutfile.write( absFile + '\r\n' )
                if wordSearch(absFile,_wordKey):
                    print "find==="+absFile
                    aOutfile.write("find==="+ absFile + '\r\n' )
                else:
                    continue
            else:
                continue'''
    for rootpath,dirnames,filenames in os.walk(aDir) :
        for absFile in ( os.path.join(rootpath,name) for name in filenames if CheckFile( os.path.join(rootpath,name) ) ) :
            print absFile;
    
            aOutfile.write(absFile + '\r\n' )
            if wordSearch(absFile,_wordKey):
                print "find==="+absFile
                aOutfile.write("find==="+ absFile + '\r\n' ) 

# 删除类型文件
def Deletefile (aDir,aOutfile):
    for rootpath,dirnames,filenames in os.walk(aDir) :
        for absFlie in (os.path.join(rootpath,name) for name in filenames ):
            pass
    if (a==b):
        pass

              

            
def CheckFile(aFile):
    
    # 以后缀过滤word临时文件
    # 
    if not re.match("^[^~]+$",aFile):
        return False
    extstr = os.path.splitext(aFile)[1][1:]
    if extstr in _fileTypes:
        return True 
    else:
        return False 
    
def wordSearch(aFile,aKey):
    app = 'Word'
    OldStr = "国通"
    NewStr = "GTalarm"
    # 可google msdn application(word)
    word = win32com.client.gencache.EnsureDispatch('%s.Application' % app)
    word.Visible = 0
    word.DisplayAlerts = 0
    doc = word.Documents.Open(aFile)#,0,ReadOnly=True, AddToRecentFiles=0 )
    #range = doc.Content()
     
    # 可参考msdn关于 Find.Execute的com说明
    # expression .Execute(FindText, MatchCase, MatchWholeWord, MatchWildcards, MatchSoundsLike, MatchAllWordForms, 
    # Forward, Wrap, Format, ReplaceWith, Replace, MatchKashida, MatchDiacritics, MatchAlefHamza, MatchControl)
    
    word.Selection.Find.ClearFormatting()
    word.Selection.Find.Text = aKey
    
    #word.Selection.Find.Replacement.ClearFormatting()
    #word.Selection.Find.Replacement.Text = OldStr

    rtn = word.Selection.Find.Execute() 

    #word.Selection.Find.Execute(OldStr, False, False, False, False, False, True, 1, True, NewStr, 2)
    #doc.Save()
    
    doc.Close(False)
    word.Quit()
    return rtn
            
def ParseArgv():
    # lobal _curpath #3.0下还有一个到上级嵌套的nonlocal
    print "check sys.argv's count..."
    global _curpath
    global _list1
    global _list2  
        
    #如果脚本在本目录下执行，默认为当前路径,执行遍历所有文件的操作
    if len(sys.argv) == 1:
        print "无参数，开始本地文件扫描。。。"
        #sys.exit()
    elif len(sys.argv)==2:
        # os.chdir(_curpath)
        _curpath = sys.argv[0]
        _list1 = str.split(sys.argv[1],'=') 
    else:
        _curpath = sys.argv[1]
        _condition = sys.argv[2]
            
        _list2 = str.split(sys.argv[2],'=')
    #判断下是否为路径
    # os.path.isdir
    
if __name__=="__main__":
    import traceback
    try:        
        main()
    except Exception ,e:
        f = open('mytmdjsjFile-error.txt','w')
        traceback.print_exc( file = f )
        f.flush()
        f.close()
        print "出现异常：",e
        





