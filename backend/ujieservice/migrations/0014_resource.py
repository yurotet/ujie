# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('ujieservice', '0013_auto_20150424_1532'),
    ]

    operations = [
        migrations.CreateModel(
            name='Resource',
            fields=[
                ('resource_id', models.AutoField(serialize=False, primary_key=True)),
                ('img_path', models.CharField(max_length=255, blank=True)),
                ('created_time', models.DateTimeField(auto_now_add=True, null=True)),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'resource',
            },
            bases=(models.Model,),
        ),
    ]
