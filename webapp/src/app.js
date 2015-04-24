//wx config
wx.config({
    debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
    appId: 'wxe2c38ce50f1ccb58', // 必填，公众号的唯一标识
    timestamp: '', // 必填，生成签名的时间戳
    nonceStr: '', // 必填，生成签名的随机串
    signature: '',// 必填，签名，见附录1
    jsApiList: [] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
});

var Vue = require('vue');
var nav = require('common/navigator');
var FastClick = require('fastclick');
var vueTouch = require('vue-touch');

FastClick.attach(document.body);

vueTouch.registerCustomEvent('doubletap', {
  type: 'tap',
  taps: 2
});
Vue.use(vueTouch)


// Vue.config.debug = true;
nav.init();


$('[data-route]').on('click', function() {
	var route = $(this).data('route');
	nav.goTo(route);
});