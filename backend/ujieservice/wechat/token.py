#coding:utf-8
import hashlib
import requests
import json
import time
from django.http import HttpResponse, HttpResponseForbidden, HttpRequest
from ujie import settings

ACCESS_TOKEN = ''
JSAPI_TICKET = ''

REQUEST_SECRET = 'fdasfasdflrewqrqwerqsdffsd'

# 请求必须携带参数token_secret
def refresh_access_token(request):
    token_secret = request.REQUEST.get('request_secret', '')
    if token_secret == REQUEST_SECRET:
        req = requests.get('https://api.weixin.qq.com/cgi-bin/token', params={
            'grant_type': 'client_credential',
            'appid': settings.APPID,
            'secret': settings.APPSECRET,
        })
        result = json.loads(req.text)
        global ACCESS_TOKEN
        ACCESS_TOKEN = result['access_token']

        #retrieve userinfo
        print 'access token updated, current value:' + ACCESS_TOKEN
        return HttpResponse(json.dumps({
            "expires_in": result['expires_in']
        }), content_type="application/json")
    else:
        return HttpResponseForbidden()


def refresh_jsapi_ticket(request):
    token_secret = request.REQUEST.get('request_secret', '')
    if token_secret == REQUEST_SECRET:
        req = requests.get('https://api.weixin.qq.com/cgi-bin/ticket/getticket', params={
            'type': 'jsapi',
            'access_token': ACCESS_TOKEN
        })
        result = json.loads(req.text)
        global JSAPI_TICKET
        JSAPI_TICKET = result['ticket']

        #retrieve userinfo
        print 'jsapi ticket updated, current value:' + JSAPI_TICKET
        return HttpResponse(json.dumps({
            "expires_in": result['expires_in']
        }), content_type="application/json")
    else:
        return HttpResponseForbidden()


def sign_jsapi(request):
    noncestr = request.REQUEST.get('noncestr')
    timestamp = request.REQUEST.get('timestamp')
    url = request.REQUEST.get('url')
    arr = [
        'jsapi_ticket=' + JSAPI_TICKET,
        # 'jsapi_ticket=' + 'sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg',
        'noncestr=' + noncestr,
        'timestamp=' + timestamp,
        'url=' + url
    ]
    tmp = '&'.join(arr)
    tmp = hashlib.sha1(tmp).hexdigest()
    return HttpResponse(json.dumps({
        'signature': tmp
    }))