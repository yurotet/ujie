from django.conf.urls import patterns, include
from django.contrib import admin
from rest_framework import routers
from ujieservice.rest.customer.api import CustomerProfile

from ujieservice.rest.driver import api as driver_api
from ujieservice.rest.customer import api as customer_api
from ujieservice.rest.common import api as common_api


# driver_router = routers.DefaultRouter()
# driver_router.register(r'profile/', driver_api.DriverProfile)
#
# customer_router = routers.DefaultRouter()
# customer_router.register(r'profile/', customer_api.CustomerProfile)

# router = routers.DefaultRouter()
# router.register(r'manufactuers', common_api.ManufactuerViewSet.as_view({'get': 'list'}))

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

    # (r'^rest/api/', include(router.urls)),
    (r'^rest/auth/', include('rest_framework.urls', namespace='rest_framework')),
    # (r'^rest/api/driver/', include(driver_router.urls)),
    (r'^rest/api/customer/profile/$', CustomerProfile.as_view()),
    (r'^rest/api/common/manufactuers/$', common_api.ManufactuerList.as_view()),
    (r'^rest/api/common/manufactuers/(?P<pk>[0-9]+)/$', common_api.ManufactuerDetail.as_view()),
    (r'^rest/api/common/manufactuers/(?P<pk>[0-9]+)/models/$', common_api.ModelList.as_view()),
    (r'^rest/api/common/avatar/$', common_api.Avatar.as_view()),
    # (r'^rest/api/common/manufactuer/(\d+)$', CustomerProfile.as_view()),
    # (r'^rest/api/customer/', include(customer_router.urls)),
)
