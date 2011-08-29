Obscura
=======

Obscura is a small library of common image manipulation functions using canvas

Usage
-----

First include the obscura.js file on your page

	<script type="text/javascript" src="path/to/obscura.js"></script>

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

[View Demos](http://oinutter.co.uk/obscura/examples/)

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

[View Demo](http://oinutter.co.uk/obscura/examples/#resize)

###Fit###

	camera.fit(width,height);

Similar to Resize, Fit will resize an image to fit into the area defined by the width and height values provided.  Priority is given to the largest original dimension.

[View Demo](http://oinutter.co.uk/obscura/examples/#fit)

###Crop###

	camera.crop(x,y,width,height);

Crops an image to the given dimensions, from the given start co-ordinates.

[View Demo](http://oinutter.co.uk/obscura/examples/#crop)

###Rotate###

	camera.rotate(deg[,center]);

Rotates an image by the specified amount of degrees.  Takes one optional parameter:

- `center` Defines the center of rotation.  Currently just takes a string e.g. `'top right'`.  The string can be formatted any way as long as it contains one of the valid x and y strings in it.  Valid strings are `'top'`, `'bottom'`, `'left'`, `'right'` and `'center'`. 
For the exact center you can just use center once.  I will be adding the facility to specify co-ordinates in the next version. Defaults to `'center'`.

[View Demo](http://oinutter.co.uk/obscura/examples/#rotate)

###Flip###

	camera.flip([direction]);

Flips the image across the specified axis.  If no parameter is passed it will default to `'horizontal'`, other option is `'vertical'`.

[View Demo](http://oinutter.co.uk/obscura/examples/#flip)

###Reflect###

	camera.reflect([alphaStart[,gap[,reflectionAmount]]]);
	
Adds a reflection to the image. Takes 3 optional parameters:

- `alphaStart` Specifies the initial transparency percentage that the reflection will fade from. Defaults to `0.5`.
- `gap` Defines the distance between the bottom of the image and the start of the reflection. Defaults to `0`.
- `reflectionAmount` Defines the size of the reflection as a percentage of the original image. Defaults to `0.25`.

[View Demo](http://oinutter.co.uk/obscura/examples/#reflect)

###setUpImageData###

	camera.setUpImageData();

Internally used method that sets internal variables and calls the initial load of the image.

###Load###

	camera.load([x[,y[,w[,h,[,image]]]]]]]);

Internal method used to load the image source onto the internal canvas object for manipulation.  Takes 5 optional parameters.

- `x` Specifies the initial x coordinate to load from on the original image.  Defaults to `0`.
- `y` Specifies the initial y coordinate to load from on the original image.  Defaults to `0`.
- `w` Specifies the width of the slice to take from the inital image.  Defaults to the original image width.
- `h` Specifies the height of the slice to take from the inital image.  Defaults to the original image height.
- `image` Defines the source image to load from.  Defaults to the internal target canvas object.

###Render###

	camera.render();

Internal method that renders the updated image to the target canvas.  All manipulation methods call this before returning.  Generally shouldn't need to be called manually.

###Save###

	camera.save();

Returns the manipulated image as a base64 encoded data url string.  Can be used to load the image into an image element, or to save the image to file in conjunction with the server side solution of your choice.

###onLoad###

	camera.onLoad = function(){
							console.log('loaded');
						};

Allows you to specify a callback to be called once the source image is loaded.  Used when passing a file name to the constructor method instead of an image element.

Properties
----------

Obscura uses a number of interal properties that can be accessed to give you information about the image.

- `target` The target canvas that Obscura will render to.  If not an on page element Obscura will create an internal object to use.
- `canvas` Obscura's internal canvas object that the manipulations are performed on.
- `context` The 2d context of Obscura's internal canvas object.
- `imageDimensions` The current dimensions of the image.  Is an object in the form `{w:width,h:height}`
- `dimensions` The new dimensions of the image.  Generally the same as `imageDimensions` but will be changed during the manipulation process.
