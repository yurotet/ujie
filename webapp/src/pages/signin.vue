<script>
  var BasePage = require('common/basepage');
  var Vue = require('vue');
  var nav = require('common/navigator');

  var View = BasePage.extend({
    title: '登录',
    data: function() {
      return {
        count: 0
      };
    },
    methods: {
      onSubmit: function() {
      		nav.goTo('paper');
      },
      onRegClick:function(){
      		nav.goTo('newUser');
      },
      onForgetPwdClick:function(){
		nav.goTo('')
      }

    },
    created: function() {
    	this.showLoading();
      console.log('indfddex created');
    },
    ready: function() {
      console.log('indexdfd ready');
    },  
  });

  module.exports = View;
</script>

<style>
	h3{
		text-align: center;		
	}
	
	#regSec {
		text-align: center;		
	}

	#forgetPwd {
		margin-right: 15px;
	}
</style>

<template>
	<header class="miu-header">
		<img src="http://static.miyouu.com/m/images/logo.png" width="105" height="44">
	</header>
	  <section class="driver-reg">
		  <form class="input-group">
			    <div class="input-row">				      
				      <input type="text" placeholder="请输入用户名/邮箱/手机号" v-model="username">
			    </div>
			    <div class="input-row">				      
				      <input type="password" placeholder="请输入密码" v-model="password">
			    </div>
		    </form>
	  
		    <button class="miu-subBtn btn btn-positive btn-block" v-on="click: onSubmit">登录</button>
		    
		     <div id="regSec">     
		    	<a id="forgetPwd" v-on="click: onForgetPwdClick">忘记密码?</a>
		   	<a id="regLink" v-on="click:onRegClick">注册新用户</a>
		   </div>   
	  </section>
</template>