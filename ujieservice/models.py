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
from django.contrib.auth.models import AbstractBaseUser, User

from django.db import models


class Driver(models.Model):
    user = models.OneToOneField(User)
    driver_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, blank=True)
    birth = models.DateField(blank=True, null=True)
    timestamp = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'driver'


class Order(models.Model):
    user = models.OneToOneField(User)
    order_id = models.AutoField(primary_key=True)
    driver_id = models.IntegerField(blank=True, null=True)
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