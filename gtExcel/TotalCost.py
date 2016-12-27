#coding=gbk

# __author__ = 'Administrator'
'''
需求：取id的价格并写入表，便于excel合计
'''
import xlrd
import xlutils.copy
import xlwt
import logging

# Wfile = unicode("wfile.xlsx" , "utf8")
# Rfile = unicode("rfile.xls","utf8")

Rfile = "Rfile.xls"
Wfile = "Wfile.xls"

logging.basicConfig\
	(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='myapp.log',
                filemode='w')


def main():
	rfile = xlrd.open_workbook(Rfile)
	rsheet = rfile.sheet_by_index(2)

	# xlrd 只能读取不能修改
	wfile = xlrd.open_workbook(Wfile)
	wsheet = wfile.sheet_by_index(2)

	# xlutils的copy从xlrd读取的内容 以写文件的方式修改
	wfile2 =  xlutils.copy.copy(wfile)
	wsheet2 = wfile2.get_sheet(2)

	for writeLine in range(1,wsheet.nrows -1):
		id = wsheet.cell(writeLine,0).value
		for readLine in range(1,rsheet.nrows-1):
			if id == rsheet.cell(readLine,0).value:
				logging.debug( rsheet.cell(readLine,2).value )
				# wsheet.cell(writeLine,2).value = rsheet.cell(writeLine,2).value
				# wsheet.cell(writeLine,3).value = rsheet.cell(writeLine,3).value
				wsheet2.write(writeLine,2,rsheet.cell(readLine,2).value)
				wsheet2.write(writeLine,3,rsheet.cell(readLine,3).value)
				break
	wfile2.save('result.xls')


if __name__ == "__main__":
    main()

