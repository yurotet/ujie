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
from django.contrib.auth.models import AbstractBaseUser, User, UserManager

from django.db import models


class UjieUser(User):
    USER_TYPE = (
        ('driver', 'Driver'),
        ('customer', 'Customer'),
    )
    DRIVER_STATUS = (
        ('unverified', 'Unverified'),
        ('verifying', 'Verifying'),
        ('verified', 'Verified'),
        ('needmore', 'Need More Information'),
    )
    access_token = models.CharField(max_length=200, blank=True)
    expiration = models.DateTimeField(blank=True, null=True)
    mobile = models.CharField(max_length=50, blank=True)
    type = models.CharField(max_length=50, choices=USER_TYPE, default='customer')
    open_id = models.CharField(max_length=200, blank=True, db_index=True)
    objects = UserManager()

    #driver info
    driver_name = models.CharField(max_length=100, blank=True)
    driver_birth = models.DateField(blank=True, null=True)
    driver_status = models.CharField(max_length=50, choices=DRIVER_STATUS, default='unverified')
    driver_contact = models.CharField(max_length=100, blank=True)
    driver_account_no = models.CharField(max_length=100, blank=True)
    driver_account_name = models.CharField(max_length=100, blank=True)
    driver_account_bank = models.CharField(max_length=100, blank=True)
    driver_account_bsb_no = models.CharField(max_length=100, blank=True)
    driver_account_name = models.CharField(max_length=200, blank=True)
    driver_driving_license = models.FilePathField(max_length=255, blank=True)

    #customer_info

    class Meta:
        db_table = 'ujie_user'


class Vehicle(models. Model):
    vehicle_id = models.AutoField(primary_key=True)
    driver = models.ForeignKey(UjieUser, related_name='vehicles')
    brand = models.CharField(max_length=100, blank=True)
    model = models.CharField(max_length=100, blank=True)
    vehicle_licence = models.FilePathField(max_length=255, blank=True)
    plate_no = models.CharField(max_length=100, blank=True)

    class Meta:
        db_table = 'Vehicle'


class Order(models.Model):
    order_id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(UjieUser, related_name='customer_orders'),
    driver = models.ForeignKey(UjieUser, related_name='driver_orders'),
    status = models.IntegerField(blank=True, null=True)
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
    timestamp = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'order'