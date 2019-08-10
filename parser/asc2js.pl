#!perl																																					#	edit to fit your system's settings

#
#	ASC 2 JAVASCRIPT PARSER
#	by Thomas Evensen
#	http://www.norwegianbastard.net
#	known bug:
#	if the asc file got a exponent value
#	with the exponent sign (e) before
#	the decimal, i.e. 3e-005.0, the script
#	will only write the number before the
#	"e" and the value of the vertex will
#	be wrong. If the "e" is after the decimal
#	the regexp takes care of it. (But it doesn't
#	process the exponent value, so in some
#	cases the number will be wrong)
#


	$argument = shift;																															#	get the filename from the argument

	$inFile		= "$argument.asc";																											#	define file to read
	$outFile	= "$argument.js";																												#	define file to write

	@fA;																																				#	array for face A side
	@fB;																																				#	array for face B side
	@fC;																																				#	array for face C side

	@fcR;																																				#	array for face red value
	@fcG;																																				#	array for face green value
	@fcB;																																				#	array for face blue value
	@fcA;																																				#	array for the face opacity

	@vX;																																				#	array for vertex X-coord
	@vY;																																				#	array for vertex Y-coord
	@vZ;																																				#	array for vertex Z-coord

	$color		= 1;																																	#	variable flag for if the color exists in rgb format


# READ FROM FILE


	open(_3DIN, "< $inFile") || die("can't read from file $inFile: $!");														#	open the input file

	@_3dData = <_3DIN>;																														#	put entire input file into an array with each line as one value in the array

	close(_3DIN);																																	#	close the input file


# START PROSESSING THE 3DFILE


   for($i = 0; $i < scalar(@_3dData); $i++)    {																						#	loop througheach line in the data array
    			
		if($_3dData[$i] =~ /Vertex/)	{																										#	process vertex data			

			if($_3dData[$i] =~ /Vertex list:/)	{}																							#	if the line is "Vertex List", we don't want it

			else	{																																		#	if the line i not the above, but still contains "Vertex", we want it
			
				$_ = $_3dData[$i];																												#	make the line into the magic variable _

				s/^Vertex \d*:  //;																													#	chop of the first lines that say "Vertex {num}:"

				s/ //g;																																	#	strip the line from any whitespaces

				@coords = /:([-\d.]+)/g;																										#	get the numbers and get rid of any "e"'s after the decimal

				# 3e-005.0 = 3 * 10^-5	 = 0.00003																						#	some expression examples just so i remember

				push(@vX, $coords[0]);																										#	put the X value into the vX array
				push(@vY, $coords[1]);																										#	put the Y value into the vY array
				push(@vZ, $coords[2]);																										#	put the Z value into the vZ array

			}																																				#	end the else loop

		}																																					#	end processing vertex data	
		
		if($_3dData[$i] =~ /Face/)	{																										#	process faces data

			if($_3dData[$i] =~ /Face list:/ || $_3dData[$i] =~ /Faces:/)	{}													#	if the line is "Face List", we don't want it

			else	{																																		#	if the line i not the above, but still contains "Face", we want it

			$_ = $_3dData[$i];																													#	make the line into the magic variable _

				s/^Face \d*: //;																														#	chop of the first lines that say "Face {num}:"

				@tmp = split;																														#	split the line where spaces occur and put the instances into an array

				for (@tmp) {																														#	loop through the instances of the array

					s/\w://																																#	remove the "{char}:" before the numbers
	
				}																																			# end loop

				push(@fA, @tmp[0]);																											#	put the first value of the array (A) in the fA array
				push(@fB, @tmp[1]);																											#	put the first value of the array (B) in the fB array
				push(@fC, @tmp[2]);																											#	put the first value of the array (C) in the fC array

			}																																				#	end the else loop

		}																																					#	end processing faces data

		if($_3dData[$i] =~ /Material:/)	{																									#	process faces color data

			$_color = $_3dData[$i];																											#	make the line into the magic variable _

			s/^Material*:\"//;																														#	chop of the first lines that say "Material:"

			($tmpR, $tmpG, $tmpB, $tmpA) = $_color =~ /"r(\d+)g(\d+)b(\d+)a(\d+)"/;								#	extracts the numbers from the line and put tem into tmp variables

			$tmpA = 1 - $tmpA;																													#	reverse the alpha variable

			push(@fcR, $tmpR);																												#	put the tmpR value into the @fcR array
			push(@fcG, $tmpG);																												#	put the tmpG value into the @fcG array
			push(@fcB, $tmpB);																												#	put the tmpB value into the @fcB array
			push(@fcA, $tmpA);																												#	put the tmpA value into the @fcA array

		}																																					#	end processing faces color data

    }																																						#	end main loop																				

	if($tmpR !~ /\d+/)	{	$color = 0;	}																									#	if the color vaiables contains anything else than numbers, the color check is false															


# WRITING TO FILE


	open(_3DOUT, "> $outFile") || die("can't write to file &outFile: $!");													#	write to file. make new if file doesn't exist, overwrite if it does
	
	for($i = 0; $i < scalar(@vX); $i++)    {																								#	loop through the length of the vertex Array

		if($i == scalar(@vX)-1)	{$sep = "";} else {$sep = ", ";}																#	if end of array, variable sep = "", else variable sep = ", "

		$vXdata .= "$vX[$i]$sep";																											#	fill vXdata variable with data from the vX array
		$vYdata .= "$vY[$i]$sep";																											#	fill vYdata variable with data from the vY array
		$vZdata .= "$vZ[$i]$sep";																											#	fill vZdata variable with data from the vZ array

	}																																						#	end loop

    for($i = 0; $i < scalar(@fA); $i++)    {																								#	loop through the length of the face Array

		if($i == scalar(@fA)-1)	{$sep = "";} else {$sep = ", ";}																#	if end of array, variable sep = "", else variable sep = ", "

		$fAdata .= "$fA[$i]$sep";																											#	fill fAdata variable with data from the fA array
		$fBdata .= "$fB[$i]$sep";																												#	fill fBdata variable with data from the fB array
		$fCdata .= "$fC[$i]$sep";																												#	fill fCdata variable with data from the fC array

		if($color==0)	 	{	$fcRdata .= "255$sep";	 }	else	{	$fcRdata .= "$fcR[$i]$sep";		}			# if colorcheck = false then fill fcRdata with 255 else fill it with data from the fcR array
		if($color==0)	 	{	$fcGdata .= "255$sep";	 }	else	{	$fcGdata .= "$fcG[$i]$sep";	}			# if colorcheck = false then fill fcGdata with 255 else fill it with data from the fcG array
		if($color==0)	 	{	$fcBdata .= "255$sep";	 }	else	{	$fcBdata .= "$fcB[$i]$sep";		}			# if colorcheck = false then fill fcBdata with 255 else fill it with data from the fcB array
		if($color==0)	 	{	$fcAdata .= "1$sep";		 }	else	{	$fcAdata .= "$fcA[$i]$sep";	}			# if colorcheck = false then fill fcAdata with 1 else fill it with data from the fcA array

	}


# BEGIN WRITING THE JS FILE


	print _3DOUT "/************************************\n";																			#
	print _3DOUT "**       ASC 2 JS converter     **\n";																			#
	print _3DOUT "**      by Thomas Evensen     **\n";																			#	write header
	print _3DOUT "**      output for use in vml     **\n";																			#
	print _3DOUT "************************************/\n\n";																		#

	print _3DOUT "var vX = new Array($vXdata);\n\n";																		#	make javascript array and fill it with vXdata
	print _3DOUT "var vY = new Array($vYdata);\n\n";																		#	make javascript array and fill it with vYdata
	print _3DOUT "var vZ = new Array($vZdata);\n\n";																		#	make javascript array and fill it with vZdata

	print _3DOUT "var fA = new Array($fAdata);\n\n";																		#	make javascript array and fill it with fAdata
	print _3DOUT "var fB = new Array($fBdata);\n\n";																		#	make javascript array and fill it with fBdata
	print _3DOUT "var fC = new Array($fCdata);\n\n";																		#	make javascript array and fill it with fCdata

	print _3DOUT "var fcR = new Array($fcRdata);\n\n";																	#	make javascript array and fill it with fcRdata
	print _3DOUT "var fcG = new Array($fcGdata);\n\n";																	#	make javascript array and fill it with fcGdata
	print _3DOUT "var fcB = new Array($fcBdata);\n\n";																	#	make javascript array and fill it with fcBdata
	print _3DOUT "var fcA = new Array($fcAdata);\n\n";																	#	make javascript array and fill it with fcAdata

	close(_3DOUT);																																#	close the new file
