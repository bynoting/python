# coding=gbk
from scrapy.selector import Selector
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor as sle

class MySpider(CrawlSpider):
    name = "yaohao"
    allowed_domains = ["bjhjyd.gov.cn"]
    start_urls = [
        "http://www.bjhjyd.gov.cn/",
    ]
    rules = [ # 定义爬取URL的规则
              # 在起始页面的下一级进行查找
        Rule(sle(allow=("https://www\.taobao\.com/market/.+"))),
        Rule(sle(allow=("item\.taobao\.com/item\.htm\?spm=.+")), follow=True, callback='parse_item')
    ]

    def parse_start_url(self, response):
        print response.url
        sel = Selector(response)
        print "+++++++++++++++++++++++"
        print sel.xpath('//*[@id="getValidCode"]').extract()
        return None

    def parse_item(self, response):
        items = []
    # // filename = response.url.split("/")[-2]
        print "taobao =========================%s"%response.url
        return items


