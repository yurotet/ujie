from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'ujie.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    (r'^$', 'ujieservice.wechat.api.hello'),
    url(r'^admin/', include(admin.site.urls)),
    (r'^token/refresh', 'ujieservice.wechat.token.refresh'),
    (r'^api/verify', 'ujieservice.wechat.api.verify'),
    (r'^h5/authorize', 'ujieservice.wechat.h5.authorize'),
    (r'^h5/notify_order', 'ujieservice.wechat.h5.notify_order'),
    (r'^h5/order_detail', 'ujieservice.wechat.h5.order_detail'),
)
