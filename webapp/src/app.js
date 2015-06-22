var Vue = require('vue');
var nav = require('common/navigator');
var FastClick = require('fastclick');
var vueTouch = require('vue-touch');
var util = require('common/util');
var Promise = require('promise');

var _refreshWx = function() {
  return new Promise(function(resolve,reject){
  var nonceStr = util.uuid();
        var timestamp = +new Date();
        var url = location.href.split('#')[0];
        $.ajax({   
                type:'POST',          
                url: '/api/weixin_signature', 
                // data to be added to query string:
               data: {
                timestamp: timestamp,
                noncestr: nonceStr,
                url: url
            }, 
              // type of data we are expecting in return:
              dataType: 'json',
              timeout: 10000,
              context: this,
              success: function(body){  
                if (body.err_code == 0 ) {
                  var data = body.data;               
                  var wxConfig = {
                    debug: true,
                    appId: data.appId,
                    timestamp: data.timestamp,
                    nonceStr: data.nonceStr,
                    signature: data.signature,
                    jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']
                  }

                  wx.config(wxConfig);
                  resolve();
                } else {
                    reject();
                }                          
              },
              complete:function() {
                            
              },
            
              error: function(xhr, type){
                reject();
              }
          }) 
  });
}

FastClick.attach(document.body);

// Vue.config.debug = true;
vueTouch.registerCustomEvent('doubletap', {
  type: 'tap',
  taps: 2
});
Vue.use(vueTouch);


// nav.init();

_refreshWx().then(nav.init());

// $('[data-route]').on('click', function() {
// 	var route = $(this).data('route');
// 	nav.goTo(route);
// });