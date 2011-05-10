#set up global object
root = exports ? this
		
obscura = (img,target) ->
	
	#load element
	@canvas = document.querySelector(target)
	@context = @canvas.getContext('2d')
	@image = document.querySelector(img)
	
	#load image
	@load =(x=0,y=0,w=@image.width,h=@image.height)=>
		@canvas.width = w
		@canvas.height = h
		@context.drawImage(@image,x,y,w,h)
		
	@resize = (scale,keepProportions=true) =>
		
		@load()
		
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
		
		#if keepProportions force stop image distorting
		if keepProportions
			if scale.w > scale.h or (scale.w==scale.h and @canvas.height > @canvas.width)
				scale.h = (scale.w/@canvas.width)*@canvas.height
			else if scale.h>scale.w or (scale.h==scale.w and @canvas.width > @canvas.height)
				scale.w = (scale.h/@canvas.height)*@canvas.width
			
		@context.clearRect(0,0,@canvas.width,@canvas.height)
		@load(0,0,scale.w,scale.h)
			
	return this
root.obscura = obscura