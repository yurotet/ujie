from django.conf.urls import patterns, include, url
from django.contrib import admin
from rest_framework import routers
from tastypie.api import Api
from ujieservice.rest import api

router = routers.DefaultRouter()
router.register(r'users', api.UserViewSet)
router.register(r'groups', api.GroupViewSet)

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'ujie.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    (r'^$', 'ujieservice.wechat.api.hello'),
    (r'^admin/', include(admin.site.urls)),
    (r'^token/refresh', 'ujieservice.wechat.token.refresh'),
    (r'^api/verify', 'ujieservice.wechat.api.verify'),
    (r'^h5/authorize', 'ujieservice.wechat.h5.authorize'),
    (r'^h5/order/create', 'ujieservice.wechat.h5.create_order'),
    (r'^h5/order/(\d+)/$', 'ujieservice.wechat.h5.order_detail'),
    (r'^h5/order/(\d+)/notify/$', 'ujieservice.wechat.h5.notify_order'),
    (r'^h5/order/$', 'ujieservice.wechat.h5.order_list'),
    (r'^rest/api/', include(router.urls)),
    (r'^rest/auth/', include('rest_framework.urls', namespace='rest_framework'))
)
