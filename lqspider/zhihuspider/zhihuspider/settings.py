# -*- coding: utf-8 -*-

# Scrapy settings for zhihuspider project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'zhihu'

SPIDER_MODULES = ['zhihuspider.spiders']
NEWSPIDER_MODULE = 'zhihuspider.spiders'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'zhihuspider (+http://www.yourdomain.com)'

ITEM_PIPELINES = ['zhihuspider.pipelines.ZhihuspiderPipeline']
DOWNLOAD_DELAY = 0.25   #设置下载间隔为250ms

