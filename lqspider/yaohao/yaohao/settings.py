# -*- coding: utf-8 -*-

# Scrapy settings for yaohao project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'yaohao'

SPIDER_MODULES = ['yaohao.spiders']
NEWSPIDER_MODULE = 'yaohao.spiders'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'yaohao (+http://www.yourdomain.com)'

# 修改默认的 User_Agent 避免可能被ban掉
DOWNLOADER_MIDDLEWARES = {
        'scrapy.contrib.downloadermiddleware.useragent.UserAgentMiddleware' : None,
        'yaohao.spiders.rotate_useragent.RotateUserAgentMiddleware' :400
    }