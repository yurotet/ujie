# myapp/api.py
import hashlib, binascii, hmac
from django.contrib.auth.models import User
from django.http import HttpRequest, HttpResponse
from tastypie import fields
from tastypie.resources import Resource
from ujieservice import constant


class VerifyResource(Resource):
    class Meta:
        resource_name = 'verify'
    def get_object_list(self, request):
    	return "test";

    def obj_get_list(self, bundle, **kwargs):
        # Filtering disabled for brevity...
        return self.get_object_list(bundle.request)

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

#check signature
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