var uuid = 1;

module.exports = {
	uuid:function(prefix){
		return (prefix||"") + (+new Date()).toString( 32 ) + (uuid++).toString( 32 );
	}	
}