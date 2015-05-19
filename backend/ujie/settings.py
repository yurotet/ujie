"""
Django settings for ujie project.

For more information on this file, see
https://docs.djangoproject.com/en/1.7/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.7/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os

BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '6igdrd(%6^cd^=748oo#rx*7#r=wkv_)j#n1sm2o*md5c!1$ve'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []

MEDIA_ROOT = "D:/workspace/src/ujie/static/uploads/"

MEDIA_URL = "/static/uploads/"

USER_MEDIA_ROOT = "D:/workspace/src/ujie/user_uploads/"

USER_MEDIA_URL = "/service/rest/common/resource/"

# Application definition

INSTALLED_APPS = (
    'corsheaders',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # 'tastypie',
    'rest_framework',
    'ujieservice'
)

MIDDLEWARE_CLASSES = (
    'ujieservice.middleware.DisableCSRFCheck',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    # 'ujieservice.middleware.UjieMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'ujie.urls'

WSGI_APPLICATION = 'ujie.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.7/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ujietrip',
        'HOST': 'aliyun.invalo.com',
        'USER': 'ujietrip',
        'PASSWORD': 'ujie2015'
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.7/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

AUTHENTICATION_BACKENDS = [
    'django.contrib.auth.backends.ModelBackend',
    'ujieservice.auth.WxUserModelBackend'
]

# CUSTOM_USER_MODEL = 'ujieservice.UjieUser'

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.7/howto/static-files/

AUTH_USER_MODEL = "ujieservice.User"

STATIC_URL = '/static/'

#user profile
AUTH_PROFILE_MODULE = "ujieservice.Profile"

#LOGIN_URL
LOGIN_URL = 'ujieservice.wechat.h5.authorize'

#rest_framework settings
REST_FRAMEWORK = {
    # Use Django's standard `django.contrib.auth` permissions,
    # or allow read-only access for unauthenticated users.
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.DjangoModelPermissionsOrAnonReadOnly'
    ]
}

#wechat settings
APPID = 'wxe2c38ce50f1ccb58'
APPSECRET = '7f6607f8256daeb23bd0bfe98eba9603'
TOKEN = '75CD9F8F7A3D452392CEEC2A9573C3B7'

#getui settings
IGT_APPID = 'xU59AjyIp78pmBkmyaa6u3'
IGT_APPKEY = 'NlR9fMNhFN7G4LFh0BI4l9'
IGT_APPSECRET = 'CMZTYXqLHm67NHhVSD7iv1'
IGT_MASTERSECRET = '84wGJ753It6yUBCFzRB1r3'

#jpush settings
JP_APPKEY = '4bba9a1f3b5e90519ef6f6ec'
JP_MASTERSECRET = '568187604ee0bed33b948e98'

#CORS settings
CORS_ORIGIN_ALLOW_ALL = True