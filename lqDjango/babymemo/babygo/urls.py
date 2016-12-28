#coding=utf-8

from django.conf.urls import patterns,  url
from babygo.views import *



urlpatterns = patterns('',
					url(r'^$',IndexView.as_view(),name='index_url'), # 1.5 以后版本 取消了direct_to_template),查手册 修改、
					url(r'^posts/$',PostListView.as_view(),name='postlist_url'),
					url(r'^posts/(?P<pk>\d+)/$',PostDetailView.as_view(),name='postdetail_url'), # 经调试才发现 ： Generic detail view PostDetailView must be called with either an object pk or a slug
					url(r'^photos/(?P<pk>\d+)/$', PhotoDetailView.as_view(),name='photodetail_url'),
					)


# urlpatterns += patterns('',
#     (r'^site_media/(?P<path>.*)','django.views.static.serve',{'document_root':'F:/Research/python/lqDjango/babymemo'}),  #配置相关的静态路径
# ）
