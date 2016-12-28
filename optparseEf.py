#! /usr/bin/env python
#coding=gbk
from optparse import OptionParser 

parser = OptionParser()

parser.add_option("-f","--file",dest="filename",help="写入文件",metavar="File")

(options, args) = parser.parse_args()  

print options.filename
