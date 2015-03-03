# myapp/api.py
import hashlib
import json
import urllib2
from django.contrib.auth.models import User
from django.http import HttpRequest, HttpResponse
from ujie import settings

def hello(req):
    return HttpResponse('helloworld')


def verify(req):
    try:
        ispass = _check_signature(req)
        if ispass:
            echostr = req.REQUEST['echostr']
            return HttpResponse(echostr)
    except:
        return HttpResponse('error')


# check signature
def _check_signature(req):
    assert isinstance(req, HttpRequest)
    signature = req.REQUEST['signature']
    timestamp = req.REQUEST['timestamp']
    nonce = req.REQUEST['nonce']
    arr = [settings.TOKEN, timestamp, nonce]
    arr.sort()
    tmp = ''.join(arr)
    tmp = hashlib.sha1(tmp).hexdigest()
    print tmp
    return tmp == signature