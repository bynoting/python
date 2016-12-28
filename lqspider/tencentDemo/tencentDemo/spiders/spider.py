# coding=gbk
import re
import json

from tencentDemo.items import TencentdemoItem
from scrapy.spider import Spider
from scrapy.utils.response import get_base_url
from scrapy.utils.url import urljoin_rfc
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor as sle

from tencentDemo.items import *
from scrapy import *
from scrapy.log import *

# from tencentDemo.misc.log import *   # ��֪��Ϊ���


class tencentDemoSpider(CrawlSpider):
    name = "tencent"
    allowed_domains = ["tencent.com"]
    start_urls = [
        "http://hr.tencent.com/position.php"
    ]
    #Todo��summary CrawlSpider ��Ĭ�ϵ�parse ����start_urls .�������а�parse��parse_item�ϲ�һ���ˡ�
    # �Ե�һ��start_urls��������rules�Ĺ�����з��� ����һ�������ǣ���дrule��ֱ����дparse������������ֱ��ȡ��Ʒurl����һҳurl��Ҳ�ܺ���
    rules = [  # ������ȡURL�Ĺ���
               Rule(sle(allow=("/position\.php\?&start=\d{,4}#a")), follow=True, callback='parse')
            ]
    # parse yield���ظ�pipeline�ı�����item���ֵ䣬��Request ��
    def parse(self, response):  # ��ȡ���ݵ�Items���棬��Ҫ�õ�XPath��CSSѡ������ȡ��ҳ����
        items = []
        sel = Selector(response)
        base_url = get_base_url(response)
        sites_even = sel.css('table.tablelist tr.even')
        for site in sites_even:
            item = TencentdemoItem()
            item['name'] = site.css('.l.square a').xpath('text()').extract()
            relative_url = site.css('.l.square a').xpath('@href').extract()[0]
            item['detailLink'] = urljoin_rfc(base_url, relative_url)
            item['catalog'] = site.css('tr > td:nth-child(2)::text').extract()
            item['workLocation'] = site.css('tr > td:nth-child(4)::text').extract()
            item['recruitNumber'] = site.css('tr > td:nth-child(3)::text').extract()
            item['publishTime'] = site.css('tr > td:nth-child(5)::text').extract()
            # items.append(item)
            yield item
            # print repr(item).decode("unicode-escape") + '\n'

        sites_odd = sel.css('table.tablelist tr.odd')
        for site in sites_odd:
            item = TencentdemoItem()
            item['name'] = site.css('.l.square a').xpath('text()').extract()
            relative_url = site.css('.l.square a').xpath('@href').extract()[0]
            item['detailLink'] = urljoin_rfc(base_url, relative_url)
            item['catalog'] = site.css('tr > td:nth-child(2)::text').extract()
            item['workLocation'] = site.css('tr > td:nth-child(4)::text').extract()
            item['recruitNumber'] = site.css('tr > td:nth-child(3)::text').extract()
            item['publishTime'] = site.css('tr > td:nth-child(5)::text').extract()

            yield item
            # items.append(item)
            # print repr(item).decode("unicode-escape") + '\n'

        # info('parsed ' + str(response))

        #Todo��summary ��һҳ����
        urls = sel.xpath('//*[@id="next"]/@href').extract()
        for url in urls:
            print url
            yield Request(urljoin_rfc(base_url, url), callback=self.parse)


    # def _process_request(self, request):
    #     print('process===================== ' + str(request))
    #     return request
