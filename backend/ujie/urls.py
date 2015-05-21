from django.conf.urls import patterns, include
from django.contrib import admin
from rest_framework import routers
from rest_framework import authtoken
from rest_framework.authtoken import views as auth_views
from ujieservice.rest.customer.api import CustomerProfile

from ujieservice.rest.driver import api as driver_api
from ujieservice.rest.customer import api as customer_api
from ujieservice.rest.common import api as common_api
from ujieservice.rest import user_api, chat_api



# driver_router = routers.DefaultRouter()
# driver_router.register(r'profile/', driver_api.DriverProfile)
#
# customer_router = routers.DefaultRouter()
# customer_router.register(r'profile/', customer_api.CustomerProfile)

# router = routers.DefaultRouter()
# router.register(r'manufactuers', common_api.ManufactuerViewSet.as_view({'get': 'list'}))
from ujieservice.rest.driver.api import User, VehiclesView, VehicleDetailView

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'ujie.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    (r'^$', 'ujieservice.wechat.api.hello'),
    (r'^admin/', include(admin.site.urls)),
    (r'^api/verify', 'ujieservice.wechat.api.verify'),
    (r'^token/refresh_access_token', 'ujieservice.wechat.token.refresh_access_token'),
    (r'^token/refresh_jsapi_ticket', 'ujieservice.wechat.token.refresh_jsapi_ticket'),
    (r'^token/sign_jsapi', 'ujieservice.wechat.token.sign_jsapi'),

    (r'^h5/authorize', 'ujieservice.wechat.h5.authorize'),
    (r'^h5/order/create', 'ujieservice.wechat.h5.create_order'),
    (r'^h5/order/(\d+)/$', 'ujieservice.wechat.h5.order_detail'),
    (r'^h5/order/(\d+)/notify/$', 'ujieservice.wechat.h5.notify_order'),
    (r'^h5/order/$', 'ujieservice.wechat.h5.order_list'),

    # (r'^rest/api/', include(router.urls)),
    # return token-auth
    # (r'^rest/user/login/', auth_views.obtain_auth_token),
    (r'^rest/user/login/$', user_api.UserLogin.as_view()),
    (r'^rest/chat/send/$', chat_api.Send.as_view()),

    (r'^rest/auth/', include('rest_framework.urls', namespace='rest_framework')),
    (r'^rest/driver/user/$', User.as_view()),
    (r'^rest/driver/vehicles/$', VehiclesView.as_view()),
    (r'^rest/driver/vehicles/(?P<pk>[0-9]+)/$', VehicleDetailView.as_view()),
    (r'^rest/customer/profile/$', CustomerProfile.as_view()),
    (r'^rest/common/user/$', common_api.User.as_view()),
    (r'^rest/common/manufactuers/$', common_api.ManufactuerList.as_view()),
    (r'^rest/common/manufactuers/(?P<pk>[0-9]+)/$', common_api.ManufactuerDetail.as_view()),
    (r'^rest/common/manufactuers/(?P<pk>[0-9]+)/models/$', common_api.ModelList.as_view()),
    (r'^rest/common/avatar/$', common_api.Avatar.as_view()),
    (r'^rest/common/wxstaticupload/$', common_api.WxStaticUpload.as_view()),
    (r'^rest/common/wxuserupload/$', common_api.WxUserUpload.as_view()),
    (r'^rest/common/resource/(?P<pk>[0-9]+)/$', common_api.Resource.as_view()),
    (r'^rest/common/flightsug/(?P<keyword>.*)/$', common_api.FlightNoSug.as_view()),
    (r'^rest/common/restaurantsug/(?P<keyword>.*)/$', common_api.RestaurantSug.as_view()),
    (r'^rest/common/restaurantdetail/$', common_api.RestaurantDetail.as_view()),
    # (r'^rest/api/common/manufactuer/(\d+)$', CustomerProfile.as_view()),
    # (r'^rest/api/customer/', include(customer_router.urls)),
)

#set prefix url, related to deployment path
urlpatterns = patterns('',
    (r'^service/', include(urlpatterns))
)
