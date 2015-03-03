import hashlib
import json
import urllib2
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
# https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe2c38ce50f1ccb58&redirect_uri=http%3A%2F%2Fwx.ujietrip.com%2Fapi%2Fauthorize&response_type=code&scope=snsapi_base&state=123#wechat_redirect
def authorize(req):
    assert isinstance(req, HttpRequest)
    code = req.REQUEST.get('code', '')
    state = req.REQUEST.get('state', '')
    if code == '':
        return HttpResponse('error')
    else:
        request_url = ['https://api.weixin.qq.com/sns/oauth2/access_token?appid=', settings.APPID, '&secret=', settings.APPSECRET, '&code=', code,  '&grant_type=authorization_code']
        request_url = ''.join(request_url)
        stream = urllib2.urlopen(request_url)
        res2_str = stream.read()
        res2_json = json.loads(res2_str)
        #retrieve userinfo
        open_id = res2_json['openid']
        user = authenticate(username=open_id, password=open_id)
        if user is not None:
            return HttpResponse('user found')
        else:
            user = User.objects.create_user(username=open_id, password=open_id)
            user.save()
            user = authenticate(username=open_id, password=open_id)
        req.session['access_token'] = res2_json['access_token']
        req.session['expires_in'] = res2_json['expires_in']
        req.session['refresh_token'] = res2_json['refresh_token']
        req.session['scope'] = res2_json['scope']
        return HttpResponse(res2_str)