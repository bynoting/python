#! /usr/bin/env python
#coding=gbk
from optparse import OptionParser 

parser = OptionParser()

parser.add_option("-f","--file",dest="filename",help="д���ļ�",metavar="File")

(options, args) = parser.parse_args()  

print options.filename
