# -*- coding: utf-8 -*-

# Scrapy settings for tencentDemo project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'tencent'

SPIDER_MODULES = ['tencentDemo.spiders']
NEWSPIDER_MODULE = 'tencentDemo.spiders'


ITEM_PIPELINES = ['tencentDemo.pipelines.JsonWithEncodingTencentPipeline1']  
# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'tencentDemo (+http://www.yourdomain.com)'
