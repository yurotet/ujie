# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0004_user_jp_registrationid'),
    ]

    operations = [
        migrations.RenameField(
            model_name='user',
            old_name='jp_registrationid',
            new_name='jp_registration_id',
        ),
    ]
