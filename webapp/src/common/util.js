var uuid = 1;

module.exports = {
	uuid:function(prefix){
		return (prefix||"") + (+new Date()).toString( 32 ) + (uuid++).toString( 32 );
	},
	isArray: Array.isArray || function(obj) {
		return toString.call(obj) === '[object Array]';
	},
	flatten: function (input, shallow, strict, output) {
		   output = output || [];
		    var idx = output.length;
		    for (var i = 0, length = input.length; i < length; i++) {
		      var value = input[i];
		      if ( this.isArray(value)) {
		        //flatten current level of array or arguments object
		        if (shallow) {
		          var j = 0, len = value.length;
		          while (j < len) output[idx++] = value[j++];
		        } else {
		         this.flatten(value, shallow, strict, output);
		          idx = output.length;
		        }
		      } else if (!strict) {
		        output[idx++] = value;
		      }
		    }
		    return output;
	  }
}