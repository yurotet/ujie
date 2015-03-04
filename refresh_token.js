var http = require('http');

refresh_token();
setInterval(function() {
    refresh_token();
}, 100 * 60 * 1000);

function refresh_token() {
    var req = http.request({
        hostname: 'wx.ujietrip.com',
        port: 80,
        path: '/token/refresh?token_secret=fdasfasdflrewqrqwerqsdffsd',
        method: 'GET'
    });
    req.end();
}
//100 * 60 * 1000