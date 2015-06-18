<script>
	var BaseComponent = require('common/basecomponent');
	var Vue = require('vue');

	var View = BaseComponent.extend({
		title: 'picupload',			
		created: function() {			
		},		
	});

	module.exports = View;

	Vue.component('view/picUpload', View);	
</script>
	
<style>		
	.input-row .icon {
		width: 50px;
		height: 50px;
		margin: 3px;
		font-size: 24px;
		line-height: 50px;
		text-align: center;
		background-color: #fff;
		border: 1px solid #ddd;
		border-radius: 25px;
	}

	.input-row.avatar-row	{
		height:150px;
		text-align: center;
	}

	.avatar-row .uploadItem {
		margin-top:35px;
		opacity: .7
	}
</style>

<template>
	<div class="input-row avatar-row {{cls}}">					
		<div class="uploadItem">
			<span class="icon icon-plus"></span>
			<p >{{title}}</p>
		</div>
	</div>
	
</template>