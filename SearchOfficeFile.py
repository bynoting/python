#! /usr/bin/env python
#coding=gbk

'''
Ԥ�ڣ�
�����ļ����Բ����ļ� ������ʽ���ļ� parm1������=ֵ�� ������
�������� ��׺end �ؼ���key ����data    ������optparse
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


# ����������� ��·���� ������
def main():
    # lobal _curpath #3.0�»���һ�����ϼ�Ƕ�׵�nonlocal    
    global _curpath
    global _list1
    global _list2 
    
    print _curpath    
    ParseArgv()
    
   
    outfile = open('mytmdjsjFile.txt','w')
    DoWork(_curpath,outfile)    
    outfile.close()
    
    #print wordSearch(os.path.j   oin(_curpath, "111.docx"),_wordKey)
    #Ŀǰ���ֲ��ɱ༭���ļ������Ǳ���
    #print wordSearch(r"i:\GTAlarm\�����ļ�\��Ŀ\���б�����������\20110526������̸��\0604\�й��������б����з�����Ƶ����������Ŀ��������(1).doc",_wordKey)
    #os.system("pause")
    input("puase")
    
def DoWork(aDir ,aOutfile):
    # �����ļ��������е��ļ�
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

# ɾ�������ļ�
def Deletefile (aDir,aOutfile):
    for rootpath,dirnames,filenames in os.walk(aDir) :
        for absFlie in (os.path.join(rootpath,name) for name in filenames ):
            pass
    if (a==b):
        pass

              

            
def CheckFile(aFile):
    
    # �Ժ�׺����word��ʱ�ļ�
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
    OldStr = "��ͨ"
    NewStr = "GTalarm"
    # ��google msdn application(word)
    word = win32com.client.gencache.EnsureDispatch('%s.Application' % app)
    word.Visible = 0
    word.DisplayAlerts = 0
    doc = word.Documents.Open(aFile)#,0,ReadOnly=True, AddToRecentFiles=0 )
    #range = doc.Content()
     
    # �ɲο�msdn���� Find.Execute��com˵��
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
    # lobal _curpath #3.0�»���һ�����ϼ�Ƕ�׵�nonlocal
    print "check sys.argv's count..."
    global _curpath
    global _list1
    global _list2  
        
    #����ű��ڱ�Ŀ¼��ִ�У�Ĭ��Ϊ��ǰ·��,ִ�б��������ļ��Ĳ���
    if len(sys.argv) == 1:
        print "�޲�������ʼ�����ļ�ɨ�衣����"
        #sys.exit()
    elif len(sys.argv)==2:
        # os.chdir(_curpath)
        _curpath = sys.argv[0]
        _list1 = str.split(sys.argv[1],'=') 
    else:
        _curpath = sys.argv[1]
        _condition = sys.argv[2]
            
        _list2 = str.split(sys.argv[2],'=')
    #�ж����Ƿ�Ϊ·��
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
        print "�����쳣��",e
        





