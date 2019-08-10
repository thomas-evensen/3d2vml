
var models				= new Array("torus.js", "test.js", "boy.js", "heart.js", "crist.js");
var mul						= new Array(2, 450, 15, 100, 300);

var model					= models[0];
var firstTime			= true;
var m						= 2;
var doShade			= true;
var doStroke			= false;
var doFill					= true;
var doOwnFill			= false;
var doAlpha				= true;
var doOwnAlpha		= false;
var sR						= 0;
var sG						= 255;
var sB						= 0;
var bR						= 200;
var bG						= 200;
var bB						= 200;
var R						= 255;
var G						= 255;
var B						= 255;
var A						= 0.5;
var Lx						= new Array(-1000000, 100000, -100000000);
var Ly						= new Array(-1000000, -50000, -15000000);
var Lz						= new Array(-500000, 10000, -1000000);
var Li						= new Array(0, 0.5, 0.1);