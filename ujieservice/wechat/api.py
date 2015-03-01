# myapp/api.py
import hashlib, binascii, hmac
from django.contrib.auth.models import User
from django.http import HttpRequest, HttpResponse
from tastypie import fields
from tastypie.resources import Resource

class VerifyResource(Resource):
    class Meta:
        resource_name = 'verify'
    def get_object_list(self, request):
    	return "test";

    def obj_get_list(self, bundle, **kwargs):
        # Filtering disabled for brevity...
        return self.get_object_list(bundle.request)

TOKEN = '75CD9F8F7A3D452392CEEC2A9573C3B7'

def verify(req):
    ispass = checksignature(req)
    if ispass:
        echostr = req.GET['echostr']
        return HttpResponse(echostr)
    else:
        return HttpResponse('error')

#check signature
def checksignature(req):
    assert isinstance(req, HttpRequest)
    signature = req.GET['signature']
    timestamp = req.GET['timestamp']
    nonce = req.GET['nonce']
    arr = [TOKEN, timestamp, nonce]
    arr.sort()
    tmp = ''.join(arr)
    tmp = hashlib.sha1(tmp).hexdigest()
    print tmp
    return tmp == signature