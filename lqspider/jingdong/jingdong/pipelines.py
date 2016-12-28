# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

# Todo:summray sqllite保存结果
import sqlite3
from os import path
from scrapy import signals
from scrapy.xlib.pydispatch import dispatcher
import datetime


class JingdongPipeline(object):
    # def process_item(self,item,spider):
    #     return item
    filename = 'db.sqlite'
    def __init__(self):
        self.conn=None
        dispatcher.connect(self.initialize,signals.engine_started)
        dispatcher.connect(self.finalize,signals.engine_stopped)

    def process_item(self,item,spider):
        try:
            # Todo:summary sqllite中的datetime比较个性。。用符合其特定规定的字符串格式进行匹配解决
            createdateStr = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')

            print "  **************************"+ createdateStr + "  **************************"
            self.conn.execute('insert into test values(?,?,?,?,?)',\
                              (None,item['name'][0],item['url'][0],float(item['price'][0]),createdateStr ))
            self.conn.execute("insert into tt values(?)",(createdateStr,))
            self.conn.commit()
        except Exception,e:
            print e

        return item
    def initialize(self):
        if path.exists(self.filename):
            self.conn=sqlite3.connect(self.filename)
        else:
            self.conn=self.create_table(self.filename)

    def finalize(self):
        if self.conn is not None:
            self.conn.commit()
            self.conn.close()
            self.conn=None

    def create_table(self,filename):
        conn=sqlite3.connect(filename)
        conn.execute("""create table test(id integer primary key autoincrement,name text,url text,price decimal,createdate datetime)""")
        # conn.execute("""create table test(name text,url text,price text)""")
        conn.commit()
        return conn