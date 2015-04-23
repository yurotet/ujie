var config = require('config');
var util = require('common/util');

module.exports = {
	config: function(cb) {
		var nonceStr = util.uuid();
		var timestamp = +new Date();
		var url = location.href.split('#')[0];

		$.ajax({
			type: 'GET',
			url: '/service/token/sign_jsapi/',
			data: {
				timestamp: timestamp,
				noncestr: nonceStr,
				url: url
			},
			dataType: 'json',
			success: function(data) {
				wx.config({
					debug: true,
					appId: config.wxAppId,
					timestamp: timestamp,
					nonceStr: nonceStr,
					signature: data.signature,
					jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']
				});
			}
		});
	}
};