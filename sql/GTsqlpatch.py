#coding=gbk
#���ִ�а汾Ŀ¼�µ�sql�ļ�
import os

#list current dir
cur_dir = os.getcwd()
print(cur_dir)

lists = os.listdir(cur_dir)
lists.sort()

os.chdir(cur_dir)

for dir in lists:
    #print(dir)
    
    dir = os.path.abspath(dir)
    
    print(dir)
    if os.path.isdir(dir):
        os.chdir(dir)
        os.system('cscript dbpatch.vbs')
    os.chdir(cur_dir)

input("ok")
