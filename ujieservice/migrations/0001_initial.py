# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Order',
            fields=[
                ('order_id', models.AutoField(serialize=False, primary_key=True)),
                ('status', models.CharField(default='0', max_length=50, choices=[('0', 'Created'), ('1', 'Dispatched'), ('2', 'Finished'), ('3', 'Canceled')])),
                ('flight_no', models.CharField(max_length=45, blank=True)),
                ('passenger_number', models.IntegerField(null=True, blank=True)),
                ('target_district_name', models.CharField(max_length=100, blank=True)),
                ('departure_date', models.DateTimeField(null=True, blank=True)),
                ('departure_country_name', models.CharField(max_length=100, blank=True)),
                ('departure_city_name', models.CharField(max_length=100, blank=True)),
                ('departure_terminal_name', models.CharField(max_length=100, blank=True)),
                ('arrival_date', models.DateTimeField(null=True, blank=True)),
                ('arrival_country_name', models.CharField(max_length=100, blank=True)),
                ('arrival_city_name', models.CharField(max_length=100, blank=True)),
                ('arrival_terminal_name', models.CharField(max_length=100, blank=True)),
                ('created_time', models.DateTimeField(auto_now_add=True, null=True)),
                ('timestamp', models.DateTimeField(auto_now=True, null=True)),
                ('customer', models.ForeignKey(related_name='customer_orders', to=settings.AUTH_USER_MODEL)),
                ('driver', models.ForeignKey(related_name='driver_orders', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'order',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('access_token', models.CharField(max_length=200, blank=True)),
                ('expiration', models.DateTimeField(null=True, blank=True)),
                ('mobile', models.CharField(max_length=50, blank=True)),
                ('type', models.CharField(default='0', max_length=50, choices=[('0', 'Customer'), ('1', 'Driver')])),
                ('open_id', models.CharField(db_index=True, max_length=200, blank=True)),
                ('driver_name', models.CharField(max_length=100, blank=True)),
                ('driver_birth', models.DateField(null=True, blank=True)),
                ('driver_status', models.CharField(default='0', max_length=50, choices=[('0', 'Unverified'), ('1', 'Verifying'), ('2', 'Verified'), ('3', 'Need More Information')])),
                ('driver_contact', models.CharField(max_length=100, blank=True)),
                ('driver_account_no', models.CharField(max_length=100, blank=True)),
                ('driver_account_bank', models.CharField(max_length=100, blank=True)),
                ('driver_account_bsb_no', models.CharField(max_length=100, blank=True)),
                ('driver_account_name', models.CharField(max_length=200, blank=True)),
                ('driver_driving_license', models.FilePathField(max_length=255, blank=True)),
                ('user', models.OneToOneField(related_name='profile', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'profile',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Vehicle',
            fields=[
                ('vehicle_id', models.AutoField(serialize=False, primary_key=True)),
                ('brand', models.CharField(max_length=100, blank=True)),
                ('model', models.CharField(max_length=100, blank=True)),
                ('vehicle_licence', models.FilePathField(max_length=255, blank=True)),
                ('plate_no', models.CharField(max_length=100, blank=True)),
                ('created_time', models.DateTimeField(auto_now_add=True, null=True)),
                ('driver', models.ForeignKey(related_name='vehicles', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'Vehicle',
            },
            bases=(models.Model,),
        ),
    ]
