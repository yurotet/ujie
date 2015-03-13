from django.contrib.auth.models import User, Group
from rest_framework import serializers
from ujieservice.models import Profile


class DriverProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        read_only_fields = ('driver_status',)
        fields = ('mobile', 'driver_status', 'driver_name', 'driver_contact', 'driver_account_no', 'driver_account_name', 'driver_account_bank', 'driver_account_bsb_no', 'driver_driving_license')


class CustomerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        # read_only_fields = ('user.username',)
        fields = ('mobile',)