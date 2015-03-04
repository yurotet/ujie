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
            name='Driver',
            fields=[
                ('driver_id', models.AutoField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, blank=True)),
                ('birth', models.DateField(null=True, blank=True)),
                ('timestamp', models.DateTimeField(null=True, blank=True)),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'driver',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('order_id', models.AutoField(serialize=False, primary_key=True)),
                ('status', models.IntegerField(null=True, blank=True)),
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
                ('timestamp', models.DateTimeField(null=True, blank=True)),
                ('driver', models.ForeignKey(to='ujieservice.Driver')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
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
                ('access_token', models.CharField(max_length=100, blank=True)),
                ('expiration', models.DateTimeField(null=True, blank=True)),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'profile',
            },
            bases=(models.Model,),
        ),
    ]
