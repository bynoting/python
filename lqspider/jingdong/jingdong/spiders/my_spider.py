# coding=gbk
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.selector import Selector
from scrapy.http import Request, FormRequest
from jingdong.items import JingdongItem
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor as sle
import os
class MySpider(CrawlSpider):
    name = "jingdong"
    allowed_domains = ["jd.com","3.cn"]
    start_urls = [
        "http://www.jd.com/",
    ]
    # Todo��summary CrawSpider�е�rules ���ø����parse �ӵ�һ��ҳ�濪ʼ����ץȡ��ע��ҳ����ת�����˵�����Ҫ��˳�����η����б�
    # �߼����ƺ��Ѿ�Ĭ�ϵ��ø����parse�����߼���ҳ���е����Ӱ�rules�еĹ���ʼ����
    rules = ( # ������ȡURL�Ĺ���
         Rule(sle(allow=("http://channel.jd.com/.+\.html"))),
         Rule(sle(allow=("http://item.jd.com/\d+\.html")), follow=True, callback='parse_item'),
              )
    # def parse_page(self, response):
    #     print response.url
    #     yield Request(response.url,callback=self.parse_item )

    def parse_item(self,response):
        sel = Selector(response)
        filename = response.url.split("/")[-1]
        item = JingdongItem()
        item["url"] = [response.url]
        item["name"] = sel.xpath('//*[@id="name"]/h1/text()').extract()
        # js���ɵļ۸񡣡���
        # item["price"] = sel.xpath('//div[2]/div[2]/strong/text()').extract()
        # �ο� ���� http://blog.csdn.net/lanshanlei/article/details/42741179
        productid = os.path.splitext(filename)[-2]  #response.url[19:29]
        priceUrl = 'http://p.3.cn/prices/mgets?skuIds=J_' + productid + 'J_'
        r = Request(priceUrl,callback= self.parsePrice)
        r.meta['item'] = item
        yield r

    def parsePrice(self,response):
        sel = Selector(response)
        item = response.meta['item']
        try:
            price = sel.xpath("//text()").extract()[0].encode('utf-8').split('"')[7]
        except Exception,ex:
            print ex
            price = -2

        item['price'] = [price]
        return item
