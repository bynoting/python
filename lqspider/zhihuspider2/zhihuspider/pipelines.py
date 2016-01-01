# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import json
import codecs

class ZhihuspiderPipeline(object):
	# def process_item(self, item, spider):
	#     return item
	def __init__(self):
		self.file = codecs.open('zhihu.json', 'w', encoding='utf-8')

	def process_item(self, item, spider):
		if item['answer']:
			if int(( item['answer'][0][:-3] ).strip()) >= 100 :
				line = json.dumps(dict(item), ensure_ascii=False) + "\n"
				self.file.write(line)
				return item
		return  None

	# def spider_closed(self, spider):
	def close_spider(self, spider):
		self.file.close()
