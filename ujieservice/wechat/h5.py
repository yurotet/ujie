import hashlib
import json
import urllib2
from django.contrib.auth.models import User
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
    code = req.REQUEST.get('code', '')
    state = req.REQUEST.get('state', '')
    if code == '':
        return HttpResponse('error')
    else:
        request_url = ['https://api.weixin.qq.com/sns/oauth2/access_token?appid=', settings.APPID, '&secret=', settings.APPSECRET, '&code=', code,  '&grant_type=authorization_code']
        request_url = ''.join(request_url)
        stream = urllib2.urlopen(request_url)
        res2_str = stream.read();
        res2_json = json.loads(res2_str)
        access_info = {
            "access_token": res2_json['access_token'],
            "expires_in": res2_json['expires_in'],
            "refresh_token": res2_json['refresh_token'],
            "openid": res2_json['openid'],
            "scope": res2_json['scope']
        }
        return HttpResponse(res2_str)