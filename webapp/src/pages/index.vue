<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: 'index',
		data: function() {
			return {
				count: 0
			};
		},
		methods: {
			clickHandler: function() {
				this.startPage('/list');							
			},
			dbltap: function() {
				alert('rotate');
			}
		},
		created: function() {
			console.log('index created');
			setInterval(function() {
				this.count++;
			}.bind(this), 500);
		},
		ready: function() {
			console.log('index ready');
		},
		attached: function() {
			console.log('index attached');
		},
		detached: function() {
			console.log('index detached');
		}
	});

	module.exports = View;
</script>

<style>
	.red {
		color: #f00;
	}
	.dbtap {
		width: 100px;
		height: 100px;
		background-color: blue;
	}
</style>

<template>
	<ul class="table-view">
      <li class="table-view-cell">
        <a class="push-right" href="http://goratchet.com">
          <strong>Ratchet documentation</strong>
        </a>
      </li>
      <li class="table-view-cell">
        <a class="push-right" href="https://github.com/twbs/ratchet/">
          <strong>Ratchet on Github</strong>
        </a>
      </li>
      <li class="table-view-cell">
        <a class="push-right" href="https://groups.google.com/forum/#!forum/goratchet">
          <strong>Ratchet Google group</strong>
        </a>
      </li>
      <li class="table-view-cell">
        <a class="push-right" href="https://twitter.com/goratchet">
          <strong>Ratchet on Twitter</strong>
        </a>
      </li>
    </ul>
</template>