#coding=utf-8
from django.conf.urls import patterns, include, url
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'babymemo.views.home', name='home'),
    url(r'^', include('babygo.urls')), # 坑：不能用 r'^$'

    url(r'^admin/', include(admin.site.urls)),
    url(r'^site_media/(?P<path>.*)$', 'django.views.static.serve',{'document_root': settings.STATIC_ROOT}), # 媒体目录下的路由
)
#urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)