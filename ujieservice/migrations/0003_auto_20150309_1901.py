# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0002_auto_20150309_1833'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='customer',
            field=models.ForeignKey(related_name='customer_orders', to=settings.AUTH_USER_MODEL, null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='order',
            name='driver',
            field=models.ForeignKey(related_name='driver_orders', to=settings.AUTH_USER_MODEL, null=True),
            preserve_default=True,
        ),
    ]
