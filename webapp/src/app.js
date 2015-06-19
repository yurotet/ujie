//wx config
// wx.config({
//     debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
//     appId: 'wx918016703cee002f', // 必填，公众号的唯一标识
//     timestamp: 1434608016, // 必填，生成签名的时间戳
//     nonceStr: 'FGePnARKDmyn0ZHa', // 必填，生成签名的随机串
//     signature: '00a9b9787b653256c89fa5595db9f11c6e1be2c0',// 必填，签名，见附录1
//     jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
// });

var Vue = require('vue');
var nav = require('common/navigator');
var FastClick = require('fastclick');
var vueTouch = require('vue-touch');
var util = require('common/util');

function refreshWX() {
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
                // debug: true,
                appId: data.appId,
                timestamp: data.timestamp,
                nonceStr: data.nonceStr,
                signature: data.signature,
                jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']
              }

                wx.config(wxConfig);
                
              } else {

              }                          
            },
            complete:function() {
                          
            },
          
            error: function(xhr, type){
              
            }
        })  
      }

refreshWX();

FastClick.attach(document.body);

vueTouch.registerCustomEvent('doubletap', {
  type: 'tap',
  taps: 2
});
Vue.use(vueTouch);

// Vue.config.debug = true;
nav.init();


$('[data-route]').on('click', function() {
	var route = $(this).data('route');
	nav.goTo(route);
});