# myapp/api.py
from django.contrib.auth.models import User
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
