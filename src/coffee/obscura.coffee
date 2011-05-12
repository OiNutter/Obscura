#set up global object
root = exports ? this
		
obscura = (img,target) ->
	
	#load element
	@target = document.querySelector(target)
	@canvas = document.createElement('canvas')
	@context = @canvas.getContext('2d')
	@image = document.querySelector(img)
	@dimensions = 
			w:@image.width
			h:@image.height
			
	@imageDimensions = @dimensions
	
	@canvas.width = @canvas.height = if @dimensions.w>@dimensions.h then @dimensions.w*2 else @dimensions.h*2
	###
	load image
	###
	@load =(x=0,y=0,w=@image.width,h=@image.height,cw,ch,image)=>
		@context.globalCompositeOperation = "copy";
		image = image ? @canvas
		@context.drawImage(image,0,0,@imageDimensions.w,@imageDimensions.h,x,y,w,h)
		@imageDimensions = {w,h}
		@render()
		return @
	
	###
	render edited image to target
	###
	@render = =>
		@target.width = @dimensions.w
		@target.height = @dimensions.h
		@target.getContext('2d').drawImage(@canvas,0,0)
		return @
	
	###
	resizes an image
	###	
	@resize = (scale,keepProportions=true,crop=false) =>
		@context.restore()
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
		scale.w = if typeof scale.w is 'string' and scale.w.match(/%/) then @dimensions.w * (parseFloat(scale.w)/100) else parseFloat(scale.w) 
		scale.h = if typeof scale.h is 'string' and scale.h.match(/%/) then @dimensions.h * (parseFloat(scale.h)/100) else parseFloat(scale.h)
		
		currentDimensions = @dimensions
		@dimensions = scale
		
		newScale = scale
		#if keepProportions force stop image distorting
		if keepProportions
			if scale.w > scale.h or (scale.w is scale.h and currentDimensions.w > currentDimensions.h)
				newScale.w = scale.w
				newScale.h = (scale.w/currentDimensions.w)*currentDimensions.h
			else if scale.h>scale.w or (scale.h is scale.w and currentDimensions.h > currentDimensions.w)
				newScale.w = (scale.h/currentDimensions.h)*currentDimensions.w
				newScale.h = scale.h
				
			@dimensions = newScale unless crop
				
		
		
		@load(0,0,newScale.w,newScale.h)
		@context.save()
		return @
	
	###
	Crops an image
	###
	@crop = (x,y,w,h) =>
		@context.restore()
		size = @dimensions
		@dimensions = {w,h}
		@context.drawImage(@canvas,x,y,w,h,0,0,w,h)
		@imageDimensions = {w,h}
		@render()
		@context.save()
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
	
	###
	Rotates an image
	###
	@rotate = (angle,center='center') =>
		@context.restore();
		{w,h}=@dimensions
		if angle is 90 or angle is 120
			{cw,ch} = {h,w}
		else if angle isnt 180 or angle isnt 360 	
			cw = w*Math.cos(angle * Math.PI/180) + h*Math.sin(angle * Math.PI/180)
			ch = h*Math.cos(angle * Math.PI/180) + w*Math.sin(angle * Math.PI/180)
			
		@context.globalCompositeOperation = "copy";
				
		if typeof center isnt 'object'
			if center.match(/(top)/)
				y = 0
				y2 = (ch-h)/2
			else if center.match(/(bottom)/)
				y = ch
				y2 = ch - (ch-h)/2
			else if center.match(/(center)/)
				y = ch/2
				y2 = h/2
				
			if center.match(/(left)/)
				x = 0
				x2 = (cw-w)/2
			else if center.match(/(middle)/)
				x = cw
				x2 = cw - (cw-w)/2
			else if center.match(/(center)/)
				x = cw/2
				x2 = w/2

		@dimensions.w = cw
		@dimensions.h = ch
		@context.translate(x,y)
		@context.rotate(angle * Math.PI/180)
		@context.drawImage(@canvas,0,0,w,h,-x2,-y2,w,h)
		#@context.save()
		@context.restore()
		@render()
		return @
		
	###
	Flips an image
	###
	@flip = (direction='horizontal')=>
		@context.restore()
		if direction is 'horizontal'
			@context.translate(@dimensions.w, 0);
			@context.scale(-1,1) 
		else 
			@context.translate(0,@dimensions.h);
			@context.scale(1,-1)
		
		@context.drawImage(@canvas,0,0)
		@context.save()
		@render()
		return @
	
	#initial load of image
	@load(0,0,@image.width,@image.height,@image.width,@image.height,@image);
		
	return this
root.obscura = obscura