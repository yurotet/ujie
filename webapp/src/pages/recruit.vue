<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var nav = require('common/navigator');
	var Blazy = require('common/lazyload'); 
	
	var View = BasePage.extend({
		title: '招募令',
		methods: {
			onFooterClick:function() {
				nav.goTo('register');						
			}
		},
		created: function() {	
			setTimeout(function() {
				$('.b-lazy').css('height', $(window).height()+'px');
				$(".button-area ").css("height",$(window).height() /3+'px');

				 var bLazy = new Blazy({  
	    				success: function(ele) {
				            // Image has loaded
				            // Do your business here
				        }
				      ,error: function(ele, msg){
				            if(msg === 'missing'){
				                // Data-src is missing
				            }
				            else if(msg === 'invalid'){
				                // Data-src is invalid
				            }  
				        }
				    });
				},0);			
		}	
	});

	module.exports = View;
</script>

<style>
	html, body {
	    /* 設定body高度為100% 拉到視窗可視的大小 */
	    height: 100%;
	}

	.card {
		margin: 0;
	}

	.pic_footer{
	    /* 設定header的高度 */
	    height: 100px;
	    box-sizing: border-box;
	}
	.button-area {
	    position: absolute;
	    bottom: 0;
	    left: 0;
	    width:100%;

	  }

</style>

<template>
<div class="b-lazy" data-src="http://image.mmiyou.com/activities/jobs.jpg">
	<div class='button-area' v-on="click:onFooterClick"></div>
</div>

	
</template>