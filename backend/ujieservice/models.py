# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [app_label]'
# into your database.
from __future__ import unicode_literals
from django.contrib.auth.models import AbstractUser, UserManager, BaseUserManager
from django.db import models


class UjieUserManager(UserManager):
    def create_user_by_wx_open_id(self, wx_open_id):
        username = wx_open_id
        password = username
        return self._create_user(username, None, password, False, False, wx_open_id=wx_open_id)

class Manufactuer(models.Model):
    manufactuer_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, blank=True, null=True)


class Model(models.Model):
    model_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, blank=True, null=True)
    manufactuer = models.ForeignKey(Manufactuer, related_name='models', null=True)


class User(AbstractUser):
    objects = UjieUserManager()

    wx_open_id = models.CharField(max_length=200, blank=True, db_index=True)
    access_token = models.CharField(max_length=200, blank=True, null=True)
    expiration = models.DateTimeField(blank=True, null=True)
    mobile = models.CharField(max_length=50, blank=True, null=True)

    gt_clientid = models.CharField(max_length=200, blank=True, null=True)
    jp_registration_id = models.CharField(max_length=200, blank=True, null=True)

    REGISTED_BY = (
        (0, 'System'),
        (1, 'Wechat Open Id'),
    )
    registed_by = models.IntegerField(choices=REGISTED_BY, default=0)

    #driver info
    driver_avatar = models.CharField(max_length=255, null=True)
    driver_name = models.CharField(max_length=100, blank=True)
    driver_birth = models.DateField(blank=True, null=True)

    DRIVER_STATUS = (
        (0, 'Unverified'),
        (1, 'Verifying'),
        (2, 'Verified'),
        (3, 'Need More Information'),
    )
    driver_status = models.IntegerField(choices=DRIVER_STATUS, default=0)
    driver_contact = models.CharField(max_length=100, blank=True)
    driver_account_no = models.CharField(max_length=100, blank=True)
    driver_account_name = models.CharField(max_length=100, blank=True)
    driver_account_bank = models.CharField(max_length=100, blank=True)
    driver_account_bsb_no = models.CharField(max_length=100, blank=True)
    driver_account_name = models.CharField(max_length=200, blank=True)
    driver_driving_license = models.CharField(max_length=255, blank=True)
    driver_driver_license = models.CharField(max_length=255, blank=True)

    class Meta:
        permissions = (
            ("user_customer", "customer perm"),
            ("user_driver", "driver perm")
        )


class Vehicle(models.Model):
    vehicle_id = models.AutoField(primary_key=True)
    driver = models.ForeignKey(User, related_name='driver_vehicles')
    brand = models.CharField(max_length=100, blank=True)
    model = models.ForeignKey(Model, related_name='vehicles', null=True)
    vehicle_licence = models.CharField(max_length=255, blank=True)
    plate_no = models.CharField(max_length=100, blank=True)
    created_time = models.DateTimeField(blank=True, null=True, auto_now_add=True)


class Order(models.Model):
    ORDER_STATUS = (
        ('0', 'Created'),
        ('1', 'Dispatched'),
        ('2', 'Finished'),
        ('3', 'Canceled'),
    )
    order_id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(User, related_name='customer_orders', null=True)
    driver = models.ForeignKey(User, related_name='driver_orders', null=True)
    status = models.CharField(max_length=50, choices=ORDER_STATUS, default='0')
    flight_no = models.CharField(max_length=45, blank=True)
    passenger_number = models.IntegerField(blank=True, null=True)
    target_district_name = models.CharField(max_length=100, blank=True)
    departure_date = models.DateTimeField(blank=True, null=True)
    departure_country_name = models.CharField(max_length=100, blank=True)
    departure_city_name = models.CharField(max_length=100, blank=True)
    departure_terminal_name = models.CharField(max_length=100, blank=True)
    arrival_date = models.DateTimeField(blank=True, null=True)
    arrival_country_name = models.CharField(max_length=100, blank=True)
    arrival_city_name = models.CharField(max_length=100, blank=True)
    arrival_terminal_name = models.CharField(max_length=100, blank=True)
    created_time = models.DateTimeField(blank=True, null=True, auto_now_add=True)
    updated_time = models.DateTimeField(blank=True, null=True, auto_now=True)


class Resource(models.Model):
    resource_id = models.AutoField(primary_key=True)
    img_path = models.CharField(max_length=255, blank=True)
    user = models.ForeignKey(User)
    created_time = models.DateTimeField(blank=True, null=True, auto_now_add=True)