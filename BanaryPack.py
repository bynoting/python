#coding=gbk
__author__ = 'lq'

import struct

bdata = struct.pack("3i10s",1000,100,10,"�༭������")

print struct.unpack("3i10s",bdata)[3]
