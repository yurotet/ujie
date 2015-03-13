var http = require('http');

refresh_token();
setInterval(function() {
    refresh_token();
}, 100 * 60 * 1000);

function refresh_token() {
    var req = http.request({
        hostname: '127.0.0.1',
        port: 8000,
        path: '/token/refresh?token_secret=fdasfasdflrewqrqwerqsdffsd',
        method: 'GET'
    });
    req.end();
}
//100 * 60 * 1000