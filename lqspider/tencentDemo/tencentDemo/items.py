# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item,Field


class TencentdemoItem(Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    name = Field()
    catalog = Field()
    workLocation = Field()
    recruitNumber = Field()       # 招聘人数  
    detailLink = Field()          # 职位详情页链接  
    publishTime = Field()         # 发布时间  
    

    