var nodegrass = require('nodegrass');

var is_refresh_jsapi_ticket_started = false;
refresh_access_token();

function get_before_expires(expires_in) {
    return expires_in - 200;
}

function refresh_access_token() {
    var req = nodegrass.get('http://wx.ujietrip.com/service/token/refresh_access_token?request_secret=fdasfasdflrewqrqwerqsdffsd', function(data, status, headers) {
        if(status == '200') {
            data = JSON.parse(data);
            var expires_in = get_before_expires(data.expires_in);
            setTimeout(refresh_access_token, expires_in);
            if(!is_refresh_jsapi_ticket_started) {
                refresh_jsapi_ticket();
                is_refresh_jsapi_ticket_started = true;
            }
        } else {
            refresh_access_token()
        }
    });
}

function refresh_jsapi_ticket() {
    var req = nodegrass.get('http://wx.ujietrip.com/service/token/refresh_jsapi_ticket?request_secret=fdasfasdflrewqrqwerqsdffsd', function(data, status, headers) {
        if(status == '200') {
            data = JSON.parse(data);
            var expires_in = get_before_expires(data.expires_in);
            setTimeout(refresh_jsapi_ticket, expires_in);
        } else {
            refresh_jsapi_ticket()
        }
    });
}