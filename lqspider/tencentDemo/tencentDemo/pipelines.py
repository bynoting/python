# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
from scrapy import signals  
import json  
import codecs  

# 注意该类名要注册到settings中
class JsonWithEncodingTencentPipeline1(object):  
  
    def __init__(self):  
        self.file = codecs.open('tencent.json', 'w', encoding='utf-8')  
  
    def process_item(self, item, spider):  
        line = json.dumps(dict(item), ensure_ascii=False) + "\n"  
        self.file.write(line)  
        return item  
  
    # def spider_closed(self, spider):  
    def close_spider(self, spider):  
        self.file.close()  




