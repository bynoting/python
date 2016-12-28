# coding=gbk
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.selector import Selector
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.http import Request, FormRequest
from taobao.items import TaobaoItem
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor as sle

class MySpider(CrawlSpider):
    name = "taobao"
    allowed_domains = ["taobao.com"]
    start_urls = [
        "https://www.taobao.com",
    ]
    rules = [ # 定义爬取URL的规则
              # 在起始页面的下一级进行查找
        Rule(sle(allow=("https://www\.taobao\.com/market/.+"))),
        Rule(sle(allow=("item\.taobao\.com/item\.htm\?spm=.+")), follow=True, callback='parse_item')

    ]
    def parse_item(self, response):
        items = []
        # // filename = response.url.split("/")[-2]
        print "taobao =========================%s"%response.url
        return items


