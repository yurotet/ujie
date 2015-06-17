<script>
	var BaseComponent = require('common/basecomponent');
	var Vue = require('vue');


	var View = BaseComponent.extend({
		title: 'regSteps',	
		data:  function(){
			return {
				step:1
			};
		},

		created:function(){
			
		}				
	});

	module.exports = View;

	Vue.component('view/regSteps', View);	
</script>
	
<style>	
	ul.breadcrumb {	
	  display: inline-block;
	  list-style: none;
	  margin:0px;
	}
	ul.breadcrumb li {
	  float: right;
	  padding: 5px;
	  background-color: #ffffff;
	  -webkit-border-radius: 50px;
	  -moz-border-radius: 50px;
	  -ms-border-radius: 50px;
	  -o-border-radius: 50px;
	  border-radius: 50px;
	  position: relative;
	  margin-left: -50px;
	  -webkit-transition: all 0.2s;
	  -moz-transition: all 0.2s;
	  -o-transition: all 0.2s;
	  transition: all 0.2s;
	  margin-top: 3px;
	}
	ul.breadcrumb li a {
	  overflow: hidden;
	  -webkit-border-radius: 50px;
	  -moz-border-radius: 50px;
	  -ms-border-radius: 50px;
	  -o-border-radius: 50px;
	  border-radius: 50px;
	  -webkit-transition: all 0.2s;
	  -moz-transition: all 0.2s;
	  -o-transition: all 0.2s;
	  transition: all 0.2s;
	  text-decoration: none;
	  height: 50px;
	  color: #509378;
	  background-color: #65ba99;
	  text-align: center;
	  min-width: 50px;
	  display: block;
	  line-height: 50px;
	  padding-left: 52px;
	  padding-right: 33.33333px;
	  width: 50px;
	}
	ul.breadcrumb li a .icon {
		font-size: 14px;
	  	display: inline-block;
	}
	ul.breadcrumb li a .text {
		font-size: 14px;
		  display: none;
		  opacity: 0;
	}
	
	ul.breadcrumb li:last-child a {
	  padding: 0;
	}
	
	.stepsContainer {
		text-align: center;
	}
</style>

<template>
<div class="stepsContainer index{{step}}" >
	<ul class="breadcrumb">
	  <li class="step1"> 
	    <a>
	      <span class="icon icon-check"></span>
	      <span class="text">提交审核</span>
	    </a>
	  </li>
	  <li class="step3">
	    <a>
	      <span class="icon icon-pages"></span>
	      <span class="text">上传照片</span>
	    </a>
	  </li>	  
	  <li class="step4">
	    <a>
	      <span class="icon icon-list"></span>
	       <span class="text">填写资料</span>
	    </a>
	  </li>
	</ul>	
</div>
	
</template>