Obscura
=======

Obscura is a small library of common image manipulation functions using canvas

Usage
-----

Obscura can be used in two different ways.  You can either use it with an `img` element already on the page, or with an image on file.

To create a new Obscura instance do the following:

	//with on page element
	var camera = new obscura('#image'[,'#target']);

	//with image on file
	var camera = new obscura('img/my-image.gif'[,'#target']);

The second argument is optional and is the id of an on page canvas element.  If this is omitted Obscura will create an internal canvas element to render to.  This is 
generally used with the save function which returns the image as a base64 encoded string.

All methods are chainable so if you want you can just call them after the constructor, however if you are using the second method, passing a file path in, you should
set the onLoad method like so:

	camera.onLoad = function(){
		camera.resize(300);
	}

Otherwise it won't work as it will try and call the methods before Obscura's internal image element has loaded the image.

Functions
---------

###Resize###

	camera.resize(300 [,keepProportions=true[,crop=false]);
	camera.resize('50%' [,keepProportions=true[,crop=false]);
	camera.resize({w:300,h:250} [,keepProportions=true[,crop=false]);
	camera.resize([300,250] [,keepProportions=true[,crop=false]);

Resizes image to given values. Values are specified either as a percentage string value e.g. `'50%'` or as a pixel value, which can be given as an integer e.g. `300` or as a string value `'300px'`. If only one value is given Obscura will 
assume you wish to resize both dimensions to that scale. There are also 2 optional parameters:

- `keepProportions` A boolean value that defines whether the image will be distorted on resizing, if set to false and not cropping, it will resize to the largest of the new dimensions, or, if the new dimensions
are equal, it will resize to whichever the largest original dimension is. Defaults to `true`.
- `crop` A boolean value that defines whether to crop the image on resize if the new proportions are different.  Defaults to `false`.

###Fit###

	camera.fit(width,height);

Similar to Resize, Fit will resize an image to fit into the area defined by the width and height values provided.  Priority is given to the largest original dimension.

###Crop###

	camera.crop(x,y,width,height);

Crops an image to the given dimensions, from the given start co-ordinates.

###Rotate###

	camera.rotate(deg[,center]);

Rotates an image by the specified amount of degrees.  Takes one optional parameter:

- `center` Defines the center of rotation.  Currently just takes a string e.g. `'top right'`.  The string can be formatted any way as long as it contains one of the valid x and y strings in it.  Valid strings are `'top'`, `'bottom'`, `'left'`, `'right'` and `'center'`. 
For the exact center you can just use center once.  I will be adding the facility to specify co-ordinates in the next version. Defaults to `'center'`.

###Flip###

	camera.flip([direction]);

Flips the image across the specified axis.  If no parameter is passed it will default to 'horizontal', other option is 'vertial'.

###Reflect###

	camera.reflect()
