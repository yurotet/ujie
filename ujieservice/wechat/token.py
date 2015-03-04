#coding:utf-8
import requests
import json
import time
from django.http import HttpResponse, HttpResponseForbidden
from ujie import settings

ACCESS_TOKEN = None
TOKEN_SECRET = 'fdasfasdflrewqrqwerqsdffsd'


# 请求必须携带参数token_secret
def refresh(request):
    token_secret = request.REQUEST.get('token_secret', '')
    if token_secret == TOKEN_SECRET:
        req = requests.get('https://api.weixin.qq.com/cgi-bin/token', params={
            'grant_type': 'client_credential',
            'appid': settings.APPID,
            'secret': settings.APPSECRET,
        })
        result = json.loads(req.text)
        global ACCESS_TOKEN
        ACCESS_TOKEN = result['access_token']
        expires_in = result['expires_in']
        global _expire_time
        _expire_time = time.time() + expires_in

        #retrieve userinfo
        print 'token updated, current value:' + ACCESS_TOKEN
        return HttpResponse('ok')
    else:
        return HttpResponseForbidden()