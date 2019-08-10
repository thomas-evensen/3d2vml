
var theLight = new Array();



function doLight(L)	{

	var e1 = new Vector((this.v2.x-this.v1.x), (this.v2.y-this.v1.y), (this.v2.z-this.v1.z))
	var e2 = new Vector((this.v3.x-this.v1.x), (this.v3.y-this.v1.y), (this.v3.z-this.v1.z))

	var polNormal = Vector.crossProd(e1,e2);

	polNormal.normalize();

	var light = new Vector((this.v1.x - theLight[L].x), (this.v1.y-theLight[L].y), (this.v1.z-theLight[L].z));

	light.normalize();

	var shade = V_dotproduct(polNormal, light);	

	if(shade<0) shade = 0;

	if(theLight[L].i)	shade *= theLight[L].i;

	return shade;

}

Polygon.prototype.doLight = doLight;



function Light(x,y,z,i)	{

		this.x	= x;
		this.y	= y;
		this.z	= z;
		if(i)	this.i		= i;

}



function createLights()	{

	for(var i = 0; i<=p.Lx.length-1; i++)	{

		theLight[i] = new Light(p.Lx[i], p.Ly[i], p.Lz[i], p.Li[i]);

	}

}