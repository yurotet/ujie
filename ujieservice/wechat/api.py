# myapp/api.py
import hashlib
import json
import urllib2
from django.contrib.auth.models import User
from django.http import HttpRequest, HttpResponse
from ujieservice import constant


def hello(req):
    return HttpResponse('helloworld')


def verify(req):
    try:
        ispass = checksignature(req)
        if ispass:
            echostr = req.REQUEST['echostr']
            return HttpResponse(echostr)
    except:
        return HttpResponse('error')


# {
#    "access_token":"ACCESS_TOKEN",
#    "expires_in":7200,
#    "refresh_token":"REFRESH_TOKEN",
#    "openid":"OPENID",
#    "scope":"SCOPE"
# }
def authorize(req):
    code = req.REQUEST.get('code', '')
    state = req.REQUEST.get('state', '')
    if code == '':
        return HttpResponse('error')
    else:
        request_url = ['https://api.weixin.qq.com/sns/oauth2/access_token?appid=', constant.APPID, '&secret=', constant.APPSECRET, '&code=', code,  '&grant_type=authorization_code']
        request_url = ''.join(request_url)
        print request_url
        stream = urllib2.urlopen(request_url)
        res2 = json.loads(stream.read())
        access_info = {
            "access_token": res2['access_token'],
            "expires_in": res2['expires_in'],
            "refresh_token": res2['refresh_token'],
            "openid": res2['openid'],
            "scope": res2['scope']
        }
        return HttpResponse(access_info)

# check signature
def checksignature(req):
    assert isinstance(req, HttpRequest)
    signature = req.REQUEST['signature']
    timestamp = req.REQUEST['timestamp']
    nonce = req.REQUEST['nonce']
    arr = [constant.TOKEN, timestamp, nonce]
    arr.sort()
    tmp = ''.join(arr)
    tmp = hashlib.sha1(tmp).hexdigest()
    print tmp
    return tmp == signature