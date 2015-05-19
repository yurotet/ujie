# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0003_auto_20150519_1423'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='jp_registrationid',
            field=models.CharField(max_length=200, null=True, blank=True),
            preserve_default=True,
        ),
    ]
