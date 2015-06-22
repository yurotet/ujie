var nav = require('common/navigator');
var Vue = require('vue');
var $Class = require('oo-class');

var M = Vue.extend({
});

$Class.mix(M.prototype, {
	name: 'BagePage',
	// startMode: "singleton",
	startMode: "newinstance",

	intervalCounter : 0,

	startPage: function(route) {
		nav.goTo(route);
	},
	startPageForResult: function(route, cb) {
	},
	back: function() {
		nav.back();
	},	

	hideToast:function(){

		var alert = document.getElementById("toast");

		if (alert)  {
			alert.style.opacity = 0;
			alert.style.display='none';	
			clearInterval(this.intervalCounter);
		}
	},

	getParam :function (name) {
		var hash = window.location.hash;
		var cutIndex = hash.indexOf('?');
		
		if (cutIndex!= -1) {
			 var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
			    var r = hash.substr(cutIndex +1).match(reg);
			    if (r != null) {
			        return unescape(r[2]);
			    }
		}
		
		 return null;
	},

	 showToast:function(message,isError){
	 	if (!message) return;

		this.hideToast();

		var alert = document.getElementById("toast");		

		if (alert == null){
			var toastHTML = '<div id="toast">' + message + '</div>';
			document.body.insertAdjacentHTML('beforeEnd', toastHTML);

		}
		else{
			$(alert).text(message);
			alert.style.display='block';
			alert.style.opacity = .9;
		}		

		intervalCounter = setInterval(this.hideToast,  isError? 2200:1300);

	},

	showLoading: function() {		
		$('.m-load2').css('display','block');
		$('.js-loading').addClass('active');
		setTimeout(this.hideLoading, 10000); // 10 seconds timeout
	},

	hideLoading: function() {
		$('.m-load2').css('display','none');
		$('.js-loading').removeClass('active');
	}
});

module.exports = M;