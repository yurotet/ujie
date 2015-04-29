# coding:utf-8
import hashlib
import json
import urllib2
from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from django.template import loader, RequestContext
import requests
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User, UserManager, Permission
from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest, HttpResponseRedirect
from ujie import settings


# {
# "access_token":"ACCESS_TOKEN",
#    "expires_in":7200,
#    "refresh_token":"REFRESH_TOKEN",
#    "openid":"OPENID",
#    "scope":"SCOPE"
# }
# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe2c38ce50f1ccb58&redirect_uri=http%3A%2F%2Fwx.ujietrip.com%2Fh5%2Fauthorize%3Ftarget%3Dtmodel&response_type=code&scope=snsapi_base&state=123#wechat_redirect
# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe2c38ce50f1ccb58&redirect_uri=redirect_uri&response_type=code&scope=snsapi_base&state=123#wechat_redirect
from ujieservice import models
from ujieservice.wechat import token


def authorize(request):
    assert isinstance(request, HttpRequest)
    code = request.REQUEST.get('code', '')
    #state字段现在表示目标跳转地址
    state = request.REQUEST.get('state', '')
    next = state
    # 这里确定用户权限，可以是customer，也可以是driver
    user_type = request.REQUEST.get('user_type', 'customer')
    if not request.user.is_authenticated():
        if code == '':
            return HttpResponseBadRequest('invalid request')
        else:
            open_id = request.session.get('open_id', '')
            if open_id == '':
                token_result = _get_access_token(code)
                if token_result.has_key('openid'):
                    open_id = token_result['openid']
                    request.session['open_id'] = open_id
                else:
                    return HttpResponseBadRequest('code error, fail to fetch open_id')
            else:
                print 'session open_id:' + open_id
            user = authenticate(wx_open_id=open_id)
            codename = ''
            if user_type == 'customer':
                codename = 'user_customer'
            elif user_type == 'driver':
                codename = 'user_driver'
            if codename != '' and (not user.has_perm('ujieservice.' + codename)):
                perm = Permission.objects.get(codename=codename)
                user.user_permissions.add(perm)
            login(request, user)

            # profile = user.profile
            # profile.access_token = res2_json['access_token']
            # profile.save()
            #
            # user = authenticate(username=open_id, password=open_id)
            # req.session['access_token'] = res2_json['access_token']
            # req.session['expires_in'] = res2_json['expires_in']
            # req.session['refresh_token'] = res2_json['refresh_token']
            # req.session['scope'] = res2_json['scope']
    if next != '':
        return HttpResponseRedirect(next)


def _get_access_token(code):
    req = requests.get('https://api.weixin.qq.com/sns/oauth2/access_token', params={
        'appid': settings.APPID,
        'secret': settings.APPSECRET,
        'code': code,
        'grant_type': 'authorization_code'
    })
    result = json.loads(req.text)
    #retrieve userinfo
    return result


@login_required
def order_detail(request, order_id):
    print request.user
    return HttpResponse("order detail")


@login_required
def create_order(request):
    user = request.user
    profile = user.profile
    assert isinstance(profile, models.Profile)
    if profile.user_type == '0':
        order = models.Order(customer=user, departure_city_name="Shanghai", arrival_city_name="Sidney")
        order.save()
        return HttpResponse("order created successfully")
    else:
        return HttpResponseBadRequest('invalid request')
    return HttpResponse("order detail")

# @login_required
def order_list(request):
    user = request.user
    list = user.customer_orders.all()
    return render(request, 'order_list.html', {
        'order_list': list
    })


# @login_required
def notify_order(request, order_id):
    assert isinstance(request, HttpRequest)
    order = models.Order.objects.get(pk=order_id)
    url = 'https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=' + token.ACCESS_TOKEN
    open_id = order.customer.username
    payload = {
        "touser": open_id,
        "template_id": "jLXU9N-7IJBN5NGn7m2R1MjM-24IsCiNZhyv0KXBnHo",
        "url": "http://wx.ujietrip.com/h5/order",
        "topcolor": "#FF0000",
        "data": {
            "first": {
                "value": "通知成功！",
                "color": "#173177"
            },
            "keyword1": {
                "value": "接机"
            },
            "keyword2": {
                "value": order.passenger_number
            },
            "keyword3": {
                "value": order.arrival_city_name
            },
            "remark": {
                "value": "欢迎再次购买！",
                "color": "#173177"
            }
        }
    }
    res = requests.post(url, json.dumps(payload))
    return HttpResponse('user notified successfully!')
