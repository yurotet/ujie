from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from ujieservice.wechat.api import VerifyResource

v1_api = Api(api_name='v1')
v1_api.register(VerifyResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'ujie.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    (r'^$', 'ujieservice.wechat.api.hello'),
    url(r'^admin/', include(admin.site.urls)),
    (r'^api/', include(v1_api.urls)),
    (r'^wechat/verify', 'ujieservice.wechat.api.verify'),
)
