My task was to draw 3dobjects into a web browser using VML.

THIS ONLY WORKS IN INTERNET EXPLORER ON PC (only tested on ie6)

This has been done with the following:

	* A perl script that parses .asc files (native ascii output for 3dStudioMax) and write a new .js file
	  with arrays containing vertex points (x,y,z), face list (a,b,c), colors (r,g,b) and alpha (a).

	* A "rendering engine" in javascript that write the polygons (faces) of the model  and then 
	  appends the polygon to the document using VML.

The parser supports:

	* The .asc fileformat.
	* Supplied in both .pl and .exe format. Takes the argument of the filename without the file extension
	  (i.e. asc2js.exe 3dobject / asc2js.pl 3dobject).

The parser has one "bug". If one or more of the vertex numbers are an exponent value (3e-005.0 or 2.5434e-700)
the parsed value can be wrong.The parser is written to remove the (e) and everything after it. So in some cases you'll
get a too high value. If this happens you'll have to change the value manually ([num before (e)] * 10^[num after (e)]).


The "renderering engine" supports:

	* .js files supplied by the parser
	* coloring of the model either by the colors of the original file or by manually setting a color in the config frame (RGB).
	* wireframe with manually chosed color in the config frame (RGB).
	* opacity either by the opacity of the original file or by manually setting the opacity in the config frame (FLOAT, 1=solid).
	* Flatshading.
	* Dynamically adding/removing of lightpoints from the config frame.
	* Manually configurable lightintensity (FLOAT, 0=default intensity, LOW FLOAT=darker)
	* Infinite nubers of lightpoints.

The "rendering engine" is RENDERONCE. Meaning no dynamic changes other that width/heigth can be done to the model without 
rendering the model once more. Real-time animation with rotation and shading is impossible due to the slowness of VML/Javascript. 
The lightcoordinates is messed up as a result of combining two different coordinaton systems. VML works within the 
"logical coordination space" and is defined by points, while the model and all calculations are done by pixels. The mix of this two 
systems made the lightcoordinates a "trial-and-error" function.

With more time i would probably been able to solve the conversion betveen points and pixels in this system and also implemented a 
rotation system. (No real-time, but on render basis. Provide angles to rotate in x,y,z and the rendering rotate the model. Had a beta 
on it, but the z-sorting was no winner).

One hump in the road was the inabillity to set individual z-index on each vertex of the polygon. Since VML only allows one z-index
to each shape, the z-sorting will in some cases be inaccurate. And it also made the rotation attemt more difficult. 

The model is also alway rendered from the top viewpoint. This because most 3dprograms export the model with the coordinated 
from a top viewpoint.

To put your own model in do something like this:

	* Make a low-poly model in a 3dprogram (over 5000 faces takes loooooong time to render)  and export as .asc. I used Lightwave,
	  and since it has no native .asc export I used the program "Deep Exploration" ( http://www.righthemisphere.com ) to convert 
	  the files to .asc.

	* Parse it by using the command asc2js [filename] (without the file extension (.asc))

	* Open settings.js and place your model in the models array and a multiplication value in the mul array (the multiplication value
	  is a "trial-and-error" process)

	* Open index.html and choose your model from the model dropdown box.

	* Choose your settings and press "RENDER". If nothing is wrong, the statusbar will count down the faces and the model will be
  	  drawn. If the model is too big or small, change the multiply value below the dropdown and render again.

	* If drawn correctly, you can play with the lights and other settings.

I've supplied 4 models. All already implementes in the settings. So index.html is the way to go.

The whole prosess goes something like this:

	* The parser takes the .asc file and put the content in memory. It then loops through the content and uses regExps to chop out
	   the information needed (more information supplied as comments in the asc2.js.pl file). 

	* When rendered, the "rendering engine" combines the vertices into faces using the info in the arrays made by the parser.
	  The vertices are combined to form a polygon and are given individual vectors and then the doLight() function calculate the 
	  shade of the color of the polygon for each lightpoint and then adding the shades together. The shade is then multiplied by
	  the RGB color of the polygon. Finaly stroke and opacity (if choosed) is added. The script then adds the polygon to the
	  screen by drawing it in VML.

	* This is then looped and done over for each polygon defined by the face list supplied by the parser.


Walkthrough of the configuration options:

RENDER SETTINGS

	* "Model": Chooses the model to render

	* "Multiply vertices by": Smaller number = smaller model.

	* "Apply lights": Turns lights on/off. The model is black without.

	* "Lightpoints": Add/remove ligthpoints. Lx, Ly, Lz = x,y,z coordinates. Li = intensity (FLOAT, 0=default intensity, LOW
 	   FLOAT=darker).

	* "Do stroke": Turn stroke (wireframe) on/off. If on, choose color in RGB format below.

	* "Do fill": Turn fill on/off.

	* "Do own fillcolor": Discharge the original color and choose your own RGB color below

	* "Do opacity": Turn opacity on/off.

	* "Do own fillcolor": Discharge the original opacity value and choose you own below (FLOAT, 1=solid).

	* "RENDER": Renders the model.


DYNAMIC SETTINGS 

	* "Width": Change the width of the model.

	* "Height": Change the height of the model.

	* "Bgcolor": Change the bgcolor of the render page.

	* "UPDATE": Update the dynamic settings.



CONCLUSION:

I'm happy with the result. VML had many limitations, and I soon realized that real-time rotations would not work. It is however possible
if the model of ultra-low polygon. With no more than 100 vertices I belive both rotations and real-time shading is possible. Maybe :)
The most fun to do was the flatshading, since I've got no prior experience with vector maths. But when I've tried enough and got some help
I actually understood most of it.

Fun to do something completly useless, but with high geekfactor.