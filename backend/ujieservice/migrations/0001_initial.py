# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
from django.conf import settings
import django.core.validators


class Migration(migrations.Migration):

    dependencies = [
        ('auth', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(help_text='Required. 30 characters or fewer. Letters, digits and @/./+/-/_ only.', unique=True, max_length=30, verbose_name='username', validators=[django.core.validators.RegexValidator('^[\\w.@+-]+$', 'Enter a valid username.', 'invalid')])),
                ('first_name', models.CharField(max_length=30, verbose_name='first name', blank=True)),
                ('last_name', models.CharField(max_length=30, verbose_name='last name', blank=True)),
                ('email', models.EmailField(max_length=75, verbose_name='email address', blank=True)),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('wx_open_id', models.CharField(db_index=True, max_length=200, blank=True)),
                ('access_token', models.CharField(max_length=200, blank=True)),
                ('expiration', models.DateTimeField(null=True, blank=True)),
                ('mobile', models.CharField(max_length=50, blank=True)),
                ('registed_by', models.IntegerField(default=0, choices=[(0, 'System'), (1, 'Wechat Open Id')])),
                ('driver_avatar', models.CharField(max_length=255, null=True)),
                ('driver_name', models.CharField(max_length=100, blank=True)),
                ('driver_birth', models.DateField(null=True, blank=True)),
                ('driver_status', models.IntegerField(default=0, choices=[(0, 'Unverified'), (1, 'Verifying'), (2, 'Verified'), (3, 'Need More Information')])),
                ('driver_contact', models.CharField(max_length=100, blank=True)),
                ('driver_account_no', models.CharField(max_length=100, blank=True)),
                ('driver_account_bank', models.CharField(max_length=100, blank=True)),
                ('driver_account_bsb_no', models.CharField(max_length=100, blank=True)),
                ('driver_account_name', models.CharField(max_length=200, blank=True)),
                ('driver_driving_license', models.CharField(max_length=255, blank=True)),
                ('driver_driver_license', models.CharField(max_length=255, blank=True)),
                ('groups', models.ManyToManyField(related_query_name='user', related_name='user_set', to='auth.Group', blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of his/her group.', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(related_query_name='user', related_name='user_set', to='auth.Permission', blank=True, help_text='Specific permissions for this user.', verbose_name='user permissions')),
            ],
            options={
                'permissions': (('user_customer', 'customer perm'), ('user_driver', 'driver perm')),
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Manufactuer',
            fields=[
                ('manufactuer_id', models.AutoField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, null=True, blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Model',
            fields=[
                ('model_id', models.AutoField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, null=True, blank=True)),
                ('manufactuer', models.ForeignKey(related_name='models', to='ujieservice.Manufactuer', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
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
                ('updated_time', models.DateTimeField(auto_now=True, null=True)),
                ('customer', models.ForeignKey(related_name='customer_orders', to=settings.AUTH_USER_MODEL, null=True)),
                ('driver', models.ForeignKey(related_name='driver_orders', to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Resource',
            fields=[
                ('resource_id', models.AutoField(serialize=False, primary_key=True)),
                ('img_path', models.CharField(max_length=255, blank=True)),
                ('created_time', models.DateTimeField(auto_now_add=True, null=True)),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Vehicle',
            fields=[
                ('vehicle_id', models.AutoField(serialize=False, primary_key=True)),
                ('brand', models.CharField(max_length=100, blank=True)),
                ('vehicle_licence', models.CharField(max_length=255, blank=True)),
                ('plate_no', models.CharField(max_length=100, blank=True)),
                ('created_time', models.DateTimeField(auto_now_add=True, null=True)),
                ('driver', models.ForeignKey(related_name='driver_vehicles', to=settings.AUTH_USER_MODEL)),
                ('model', models.ForeignKey(related_name='vehicles', to='ujieservice.Model', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
