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


Vue.config.debug = true;
nav.init();

$('input').on('click', function() {
	var route = $(this).val();
	nav.goTo(route);
});