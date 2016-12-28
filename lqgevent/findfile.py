__author__ = 'lq'
#coding = gbk

import gevent
import sys
import os

search_start_root = ""
search_item = ""

def get_ext_file(afilename):
	if os.path.splitext(afilename)[1] :
		if os.path.splitext(afilename)[1] == search_item:
			return afilename
	return None

def get_base_file(afilename):
	if os.path.splitext(afilename)[0] :
		if os.path.splitext(afilename)[0].lower() == search_item.lower():
			return afilename
	return None

def get_fullname_file(afilename):
	if os.path.basename(afilename).lower() == search_item.lower():
		return afilename
	return None

def printResult2file(aMessage):
	with open(r"c:\searchEnd.txt",'a') as f:
		print>>f,aMessage


def search():
	for rootpath,dirnames,filenames in os.walk(search_start_root) :
		for fname in filenames :
			if get_base_file(fname):
				dfname =  os.path.join(rootpath,fname)
				printResult2file(dfname)

				print "test"


