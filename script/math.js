

function Vector(x,y,z)	 {

	this.x = x;
	this.y = y;
	this.z = z;
}

function V_dotproduct(v1,v2)	{

	var result = (v1.x  * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
	return result;

}

function V_crossproduct(v1,v2)	{

	var tmp = new Vector((v1.y * v2.z) - (v2.y * v1.z), (v1.z * v2.x) - (v2.z * v1.x), (v1.x * v2.y) - (v2.x * v1.y));
	return tmp;

}


function V_normalize()	{

	var length = Math.sqrt((this.x * this.x) + (this.y * this.y) + (this.z *this.z));

	this.x /= length;
	this.y /= length;
	this.z /= length;

}


Vector.dotProd = V_crossproduct;
Vector.crossProd = V_crossproduct;

Vector.prototype.normalize = V_normalize;