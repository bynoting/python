#coding=gbk
'''
生成字幕文件srt
日期时间和字符串的转换，时间间隔的计算
'''
import os
from datetime import datetime,timedelta

def main():
	startTime= datetime.strptime("00:00:00","%H:%M:%S")
	nowTime = datetime.now()
	newline =os.linesep #"\n"
	with open("1.srt",'w+') as f:
		for i in range(1,600):
			f.write("{a}".format(a=str(i)))
			f.write(newline)

			endTime = startTime + timedelta(seconds=1)
			f.write('{a},000 --> {b},000'.format
					(a=datetime.strftime(startTime,'%H:%M:%S'),
					 b=datetime.strftime(endTime,'%H:%M:%S')
					 )
			)
			f.write(newline)

			f.write((nowTime + timedelta(seconds=i) ).strftime("%Y-%m-%d %H:%M:%S"))
			f.write(newline)

			f.write(newline)
			startTime = endTime


	import chardet
	print chardet.detect(open('1.srt','r').read())

if __name__ == "__main__":
	main()