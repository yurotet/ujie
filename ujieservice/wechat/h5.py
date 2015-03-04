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
from ujieservice.models import Profile


def authorize(req):
    assert isinstance(req, HttpRequest)
    code = req.REQUEST.get('code', '')
    state = req.REQUEST.get('state', '')
    target = req.REQUEST.get('target', '')
    if code == '':
        return HttpResponse('error')
    else:
        open_id = req.session.get('open_id', '')
        if open_id == '':
            open_id = _get_access_token(code)['openid']
            req.session['open_id'] = open_id
        else:
            print 'session open_id:' + open_id
        user = authenticate(username=open_id, password=open_id)
        if user is None:
            user = User.objects.create_user(username=open_id, password=open_id)
            profile = Profile.objects.create(user=user)
            profile.save()
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
    req2 = requests.get('https://api.weixin.qq.com/sns/oauth2/access_token', params={
       'appid': settings.APPID,
       'secret': settings.APPSECRET,
       'code': code,
       'grant_type': 'authorization_code'
    })
    res2_json = json.loads(req2.text)
    #retrieve userinfo
    return res2_json

def push(req):
    assert isinstance(req, HttpRequest)
