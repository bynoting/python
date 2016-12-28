#!/usr/bin/env python
# -*- coding:utf-8 -*-
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.selector import Selector
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.http import Request, FormRequest
from zhihuspider.items import ZhihuItem
from scrapy import log
# Todo 1：取出一百个回答以上的问题：url，作者。。存入sqllite数据库

class zhihusipder(CrawlSpider) :
    name = "zhihu"
    allowed_domains = ["www.zhihu.com"]
    start_urls = [
        "http://www.zhihu.com/"
    ]

    # log.start('log.txt',)
    rules = (
        Rule(SgmlLinkExtractor(allow = ('/question/\d+#.*?', )), callback = 'parse_page', follow = True),
        Rule(SgmlLinkExtractor(allow = ('/question/\d+', )), callback = 'parse_page', follow = True),
    )
    headers = {
    "Accept": "*/*",
    "Accept-Encoding": "gzip,deflate",
    "Accept-Language": "en-US,en;q=0.8,zh-TW;q=0.6,zh;q=0.4",
    "Connection": "keep-alive",
    "Content-Type":" application/x-www-form-urlencoded; charset=UTF-8",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36",
    "Referer": "http://www.zhihu.com/"
    }

    #重写了爬虫类的方法, 实现了自定义请求, 运行成功后会调用callback回调函数
    # 无法抓取知乎的登陆默认首页。不太清楚首页真实的URL规则。。。放弃
    def start_requests(self):
        return [Request("http://www.zhihu.com/#signin", meta = {'cookiejar' : 1}, callback = self.post_login)]

    #FormRequeset出问题了
    def post_login(self, response):
        print 'Preparing login'
        # log.msg('我的log')
        #下面这句话用于抓取请求网页后返回网页中的_xsrf字段的文字, 用于成功提交表单
        xsrf = Selector(response).xpath('//input[@name="_xsrf"]/@value').extract()[0]
        print xsrf
        #FormRequeset.from_response是Scrapy提供的一个函数, 用于post表单
        #登陆成功后, 会调用after_login回调函数
        return [FormRequest.from_response(response,   #"http://www.zhihu.com/login",
                            meta = {'cookiejar' : response.meta['cookiejar']},
                            headers = self.headers,  #注意此处的headers
                            formdata = {
                            '_xsrf': 'bf78d44941a3f55c92d477ecbece6179',
                            'email': 'bynoting@21cn.com',
                            'password': 'liqiang780912'
                            },
                            callback = self.after_login,
                            dont_filter = True
                            )]


    def after_login(self, response) :
        print "after_login--------------------%s"%response.url
        # for url in self.start_urls : # 下面方式同样能实现登陆后的页面跳转。。
        yield self.make_requests_from_url(response.url) # 对页面中的链接进行rules过滤，执行

            # yield self.parse_page(response)

    def parse_page(self, response):
        selecter = Selector(response)
        item = ZhihuItem()
        item['url'] = response.url


        # item['name'] = selecter.xpath('//h3[@class="name"]/text()').extract()
        # print item['name']
        item['title'] = selecter.xpath('//div/div[2]/h2/text()').extract()
        # item['description'] = selecter.xpath('//div[@class="zm-editable-content"]/text()').extract()
        # item['answer'] = selecter.xpath('//div[@class=" zm-editable-content clearfix"]/text()').extract()

        # item['answer'] = selecter.xpath('//*[@id="zh-question-answer-num"]/text()').extract()  # 回答人数 xpath中* 表示任意标签？
        answer = selecter.xpath('//*[@id="zh-question-answer-num"]/text()').extract()
        print '==================='
        # log.msg('==================',_level=INFO)
        print type(answer)
        # 方案一 ： 在spider中进行过滤 ，取出数字 找出大于100回答的item
        # if len( answer ) == 0 :
        #     return None
        # if int(( ( answer )[0][:-3] ).strip()) < 100: # python 中 字符和数字也能进行比较，导致不太容易查错。
        #     return None

        item['answer'] = answer
        item['name'] = selecter.xpath('//h3[@class="zm-item-answer-author-wrap"]/a[2]/text()').extract()

        return item
