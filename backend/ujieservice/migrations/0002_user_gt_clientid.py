# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='gt_clientid',
            field=models.CharField(max_length=200, blank=True),
            preserve_default=True,
        ),
    ]
