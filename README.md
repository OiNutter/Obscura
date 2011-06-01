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

	