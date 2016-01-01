
#coding=gbk
from ftplib import FTP
f=FTP('58.30.28.131')
f.login('jszc','jszc')


f.quit()

s="中文"
print s

