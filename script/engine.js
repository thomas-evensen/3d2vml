
var d = document;
var p = parent;

var shade = new Array();

	for(var i=vX.length-1;i>=0;i--)	{
		vX[i]		*= p.m;
		vY[i]		*= p.m;
		vZ[i]		*= 1000;
	}


	var dummy =	{
		poly			:	d.createElement('v:polyline'),
		fill	 			:	d.createElement('v:fill')
	}



function Polygon(x1,y1,z1,x2,y2,z2,x3,y3,z3,fCR,fCG,fCB,fCA,el)	{

	this.el = dummy.poly.cloneNode(true);
	this.fill = dummy.fill.cloneNode(true);
	this.el.style.position = "relative";
	this.el.style.zIndex = z1;

	this.el.points = (x1)+","+(y1)+","+(x2)+","+(y2)+","+(x3)+","+(y3) +","+(x1)+","+(y1);

	this.v1 = new Vector(x1,y1,z1);
	this.v2 = new Vector(x2,y2,z2);
	this.v3 = new Vector(x3,y3,z3);

	this.el.filled = p.doFill;

	if(p.doFill)	 {

		if(!p.doShade)	{Lshade = 1;}

		else	{

			var Lshade = 0;

			for(var x =0; x<=theLight.length-1;x++)	{

				shade[x] = this.doLight(x);
				Lshade += shade[x];

			}

		}

		if(!p.doOwnFill)	{
			
			var r		=	Math.round(fCR*Lshade);	if(r>255) r=255;
			var g	=	Math.round(fCG*Lshade);	if(g>255) g=255;
			var b	=	Math.round(fCB*Lshade);	if(b>255) b=255;

		}

		else	{

		var r		=	Math.round(p.R*Lshade);	if(r>255) r=255;
		var g	=	Math.round(p.G*Lshade);	if(g>255) g=255;
		var b	=	Math.round(p.B*Lshade);	if(b>255) b=255;

		}

		this.el.fillcolor = "rgb("+r+","+g+","+b+")";

	}

	this.el.stroked = p.doStroke;
	
	if(p.doStroke)	this.el.strokecolor = "rgb("+p.sR+","+p.sG+","+p.sB+")";

	mainGroup.appendChild(this.el);	

	if(p.doAlpha)	{

	if(!p.doOwnAlpha)	this.fill.opacity = fCA;	else	this.fill.opacity = p.A;
	
	this.el.appendChild(this.fill);

	}

}



function Object3D()	{

	this.p = new Array;

	var startTime = new Date().valueOf();

	for(var i=fA.length-1;i>=0;i--)	{

		this.p[i] = new Polygon(vX[fA[i]],vY[fA[i]],vZ[fA[i]],vX[fB[i]],vY[fB[i]],vZ[fB[i]],vX[fC[i]],vY[fC[i]],vZ[fC[i]],fcR[i],fcG[i],fcB[i],fcA[i],i);

		window.status = "Faces left: "+i;

	}

	var endTime = new Date().valueOf();

	window.status = "Model: "+ p.model + " |  Faces: " + fA.length + " | Vertices: " + vX.length + " | Drawn in: "+ (endTime-startTime)/1000 + " | Lights: "+ theLight.length;

}



function init()	{

	d.body.style.backgroundColor = "rgb("+p.bR+","+p.bG+","+p.bB+")";

	if(!p.firstTime)	{ 

		if(p.doShade)	createLights();

		test = new Object3D();

	}

}

window.onload = init;