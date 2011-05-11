#set up global object
root = exports ? this
		
obscura = (img,target) ->
	
	#load element
	@canvas = document.querySelector(target)
	@context = @canvas.getContext('2d')
	@image = document.querySelector(img)
	
	###
	load image
	###
	@load =(x=0,y=0,w=@image.width,h=@image.height,cw,ch)=>
		@context.clearRect(0,0,@canvas.width,@canvas.height)
		@canvas.width = cw ? w
		@canvas.height = ch ? h
		@context.drawImage(@image,x,y,w,h)
		return @
		
	###
	resizes an image
	###	
	@resize = (scale,keepProportions=true,crop=false) =>
			
		#check type of scale and convert it to an object if not already
		if Object.prototype.toString.call(scale) is '[object Array]'
			scale = 
				w: scale[0]
				h:scale[1]
		else if typeof scale isnt 'object'
			scale = 
				w:scale
				h:scale
				
		#convert percentages to actual values
		scale.w = if typeof scale.w is 'string' and scale.w.match(/%/) then @canvas.width * (parseFloat(scale.w)/100) else parseFloat(scale.w) 
		scale.h = if typeof scale.h is 'string' and scale.h.match(/%/) then @canvas.height * (parseFloat(scale.h)/100) else parseFloat(scale.h)
		
		cw = scale.w
		ch = scale.h
		
		newScale = scale
		console.log(@canvas.width)
		console.log(@canvas.height)
		#if keepProportions force stop image distorting
		if keepProportions
			if scale.w > scale.h or (scale.w is scale.h and @canvas.width > @canvas.height)
				newScale.w = scale.w
				newScale.h = (scale.w/@canvas.width)*@canvas.height
			else if scale.h>scale.w or (scale.h is scale.w and @canvas.height > @canvas.width)
				newScale.w = (scale.h/@canvas.height)*@canvas.width
				newScale.h = scale.h
				
			if not crop
				cw = newScale.w
				ch = newScale.h
							
		@load(0,0,newScale.w,newScale.h,cw,ch)
		return @
	
	###
	Crops an image
	###
	@crop = (x,y,w,h) =>
		@load(-x,-y,@canvas.width,@canvas.height,w,h)
		return @
		
	###
	Resizes an image to fit completely into a given space
	###
	@fit = (w,h) =>
		return @ if w>@canvas.width and h>@canvas.height
						
		if w<h or @canvas.width > @canvas.height or (w is h and @canvas.height > @canvas.width)
			h = (w/@canvas.width)*@canvas.height
		else if h<w or @canvas.height>@canvas.width or (h is w and @canvas.width > @canvas.height)
			w = (h/@canvas.height)*@canvas.width;
		
		@load(0,0,w,h)
		return @
			
	#initial load of image
	@load();
	
	###
	Rotates an image
	###
	@rotate = (angle,center='center') =>
		w = @canvas.width
		h = @canvas.height
		if angle is 90 or angle is 120
			cw = h
			ch = w
		else if angle is 180 or angle is 360
			cw = w
			ch = h
		else 	
			cw = w*Math.cos(angle * Math.PI/180) + h*Math.sin(angle * Math.PI/180)
			ch = h*Math.cos(angle * Math.PI/180) + w*Math.sin(angle * Math.PI/180)
			
		@context.clearRect(0,0,@canvas.width,@canvas.height)
		@canvas.width = cw
		@canvas.height = ch
		
		if typeof center isnt 'object'
			if center.match(/(top)/)
				y = 0
				y2 = (ch-h)/2
			else if center.match(/(bottom)/)
				y = @canvas.height
				y2 = @canvas.height - (ch-h)/2
			else if center.match(/(center)/)
				y = @canvas.height/2
				y2 = h/2
				
			if center.match(/(left)/)
				x = 0
				x2 = (cw-w)/2
			else if center.match(/(middle)/)
				x = @canvas.width
				x2 = @canvas.height - (cw-w)/2
			else if center.match(/(center)/)
				x = @canvas.width/2
				x2 = w/2
		
		@context.translate(x,y)
		@context.rotate(angle * Math.PI/180)
	
		@context.drawImage(@image,-x2,-y2,w,h)
		
		
		return @
		
	###
	Flips an image
	###
	@flip = (direction='horizontal')=>
		if direction is 'horizontal'
			@context.translate(@canvas.width, 0);
			@context.scale(-1,1) 
		else 
			@context.translate(0,@canvas.height);
			@context.scale(1,-1)
		
		@context.drawImage(@image,0,0,@canvas.width,@canvas.height)
		
		return @
				
	return this
root.obscura = obscura