#coding:utf-8
import hashlib
import json
import urllib2
import requests
from django.contrib.auth import authenticate
from django.contrib.auth.models import User, UserManager
from django.http import HttpRequest, HttpResponse
from ujie import settings


# {
#    "access_token":"ACCESS_TOKEN",
#    "expires_in":7200,
#    "refresh_token":"REFRESH_TOKEN",
#    "openid":"OPENID",
#    "scope":"SCOPE"
# }
# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe2c38ce50f1ccb58&redirect_uri=http%3A%2F%2Fwx.ujietrip.com%2Fh5%2Fauthorize%3Ftarget%3Dtmodel&response_type=code&scope=snsapi_base&state=123#wechat_redirect
from ujieservice.models import UjieUser
from ujieservice.wechat import token


def authorize(request):
    assert isinstance(request, HttpRequest)
    code = request.REQUEST.get('code', '')
    state = request.REQUEST.get('state', '')
    target = request.REQUEST.get('target', '')
    if code == '':
        return HttpResponse('error')
    else:
        open_id = request.session.get('open_id', '')
        if open_id == '':
            open_id = _get_access_token(code)['openid']
            request.session['open_id'] = open_id
        else:
            print 'session open_id:' + open_id
        print 'before authenticate'
        user = authenticate(open_id=open_id)
        print 'after authenticate'
        if user is None:
            user = UjieUser.objects.create_user(username=open_id, password=open_id, open_id=open_id)
            user.save()
        # profile = user.profile
        # profile.access_token = res2_json['access_token']
        # profile.save()
        #
        # user = authenticate(username=open_id, password=open_id)
        # req.session['access_token'] = res2_json['access_token']
        # req.session['expires_in'] = res2_json['expires_in']
        # req.session['refresh_token'] = res2_json['refresh_token']
        # req.session['scope'] = res2_json['scope']
        return HttpResponse(open_id)


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


def order_detail(request):
    return HttpResponse("order detail")


def notify_order(request):
    assert isinstance(request, HttpRequest)
    url = 'https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=' + token.ACCESS_TOKEN
    for u in User.objects:
        if u.profile.open_id != '':
            payload = {
                "touser": u.profile.open_id,
                "template_id": "jLXU9N-7IJBN5NGn7m2R1MjM-24IsCiNZhyv0KXBnHo",
                "url": "http://wx.ujietrip.com/h5/order_detail",
                "topcolor":"#FF0000",
                "data": {
                    "first": {
                       "value": "恭喜你购买成功！",
                       "color": "#173177"
                    },
                    "keynote1": {
                        "value": "巧克力",
                        "color": "#173177"
                    },
                    "keynote2": {
                        "value": "39.8元",
                        "color": "#173177"
                    },
                    "keynote3": {
                        "value": "2014年9月16日",
                        "color": "#173177"
                    },
                    "remark": {
                        "value": "欢迎再次购买！",
                        "color": "#173177"
                    }
                }
            }
            res = requests.post(url, json.dumps(payload))
    return HttpResponse('all users notified!')
