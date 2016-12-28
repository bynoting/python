#coding=gbk
'''
Created on 2013-3-22

@author: gtlq
'''


import cmd
import sys

class PyCDC(cmd.Cmd): 
    def __init__(self): 
        cmd.Cmd.__init__(self)                # initialize the base class 
    def help_EOF(self): 
        print ("退出程序 Quits the program" )
    def do_EOF(self, line): 
        sys.exit()   
    def help_walk(self):
        print ("cd and export into *.cdc" )
    def do_walk(self, filename): 
        if filename == "":
            filename = input("cdc::") 
        print ("保存文件名称:'%s'" % filename) 
  
    def help_dir(self): 
        print ("save/搜索 search ")
   
    def do_dir(self, pathname): 
        if pathname == "":
            pathname = input("输入制定保存 /search ")
  
    def help_find(self): 
        print ("search key 关键字 ") 
    def do_find(self, keyword): 
        if keyword == "": keyword = input("input key :") 
        print ("search key:'%s'" % keyword )
if __name__ == '__main__':      # this way the module can be 
    cdc = PyCDC()            # imported by other programs as well 
    cdc.cmdloop()