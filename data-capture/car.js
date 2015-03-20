var request = require('request');
var process = require('process');

//
// 在这边处理最终的结果
// 抓取结果格式如下
//  e.g {'bmw':['1 serises','3 series']}
//
var handleResult = function(result) {
	console.log("result handler not implemented!");
}

var requestT = function (url, fn){
	request(url, function(err, response, body) {
		if (!err && response.statusCode == 200) {
			fn(body);   			
   		} else {
   			err && console.log(err);
   			response && console.log('[response code]'+response.statusCode);
   			throw "request failed for " + url;
   		}
	})
}

var captrueMakers = function(url, fn) {		
	requestT(url, function(body){		
		// 把含有maker名字的html拿出来
		var p1 = new RegExp(/<option value="">Any make<\/option>.*?<option value="----.*?<\/option>(.*?)<\/select>/);
		var optionsCnt = p1.exec(body.replace(/[\r\t\n]/g,''))[1];

		// 把每一个maker的option选项html拿出来
		var markerOptions = optionsCnt.match(/<option.*?<\/option>/g);

		// 把maker的名字拿出来
		var names =  [];
		markerOptions.forEach(function(option){
			var name = /value="([^"]+)">/.exec(option)[1];
			names.push(name);
		})

		fn(names);
	});
}

var captureModels = function(url, maker, fn) {
	requestT(url, function(body){
		var modelObj = JSON.parse(body);
		var models = [];		
		modelObj['Facets'].forEach(function(facet){			
			models.push(facet['Name']);
		})

		fn(models);
	});
}

function run() {		
	var result = {};
			
	captrueMakers('http://www.carsales.com.au', function(makerList) {										
		makerList.forEach(function(maker) {					
			process.nextTick(function(){
				captureModels('http://www.carsales.com.au/aspects/Model?SearchParameter={%22vehicle%22:{%22values%22:[{%22key%22:%22Make%22,%22value%22:%22'+maker+'%22}]}}&Parent=Make%3D'+maker+'&cpw=1&_='+(new Date()).getTime(), 
								maker, function(models) {										
					result[maker]=models;
					if (Object.keys(result).length == makerList.length) {
						handleResult(result);
					}
				});
			});			
		});		
	});			
}

run();


