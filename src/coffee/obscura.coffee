#set up global object
root = exports ? this
		
obscura = (img,target=null) ->

	###
	internal variables
	###
	fileRegExp = /\.((jp(e)?g)|(png)|(gif))$/i
	@onLoad = =>
		return true
		
	###
	Set up local variables with image data from source
	###
	@setUpImageData = =>
		@dimensions = 
				w:@image.width
				h:@image.height
		@imageDimensions = @dimensions
		@canvas.width = @canvas.height = if @dimensions.w>@dimensions.h then @dimensions.w*2 else @dimensions.h*2
		
		#initial load of image
		@load(0,0,@image.width,@image.height,@image);
		
	###
	load image
	###
	@load =(x=0,y=0,w=@image.width,h=@image.height,image=@target)=>
		@context.globalCompositeOperation = "copy"
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
		@target.getContext('2d').globalCompositeOperation = "copy"
		@target.getContext('2d').drawImage(@canvas,0,0)
		@context.clearRect(0,0,@canvas.width,@canvas.height)
		return @
	
	###
	Convert image to base64 encoded string for saving to server
	###
	@save = => 
		return @target.toDataURL()
		
	###
	resizes an image
	###	
	@resize = (scale,keepProportions=true,crop=false) =>
		@context.save()
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
						
		@context.drawImage(@target,0,0,newScale.w,newScale.h)
		@render()
		@imageDimensions = @dimensions
		@context.restore()
		return @
	
	###
	Crops an image
	###
	@crop = (x,y,w,h) =>
		@context.save()
		size = @dimensions
		@dimensions = {w,h}
		@context.drawImage(@target,x,y,w,h,0,0,w,h)
		@imageDimensions = {w,h}
		@render()
		@context.restore()
		return @
		
	###
	Resizes an image to fit completely into a given space
	###
	@fit = (w,h) =>
		@context.save()
		return @ if w>@canvas.width and h>@canvas.height
						
		if w<h or @imageDimensions.w > @imageDimensions.h or (w is h and @imageDimensions.h > @imageDimensions.w)
			h = (w/@imageDimensions.w)*@imageDimensions.h
		else if h<w or @imageDimensions.h>@imageDimensions.w or (h is w and @imageDimensions.w > @imageDimensions.h)
			w = (h/@imageDimensions.h)*@imageDimensions.w;
		
		@dimensions = {w,h}
		@context.drawImage(@target,0,0,w,h)
		@imageDimensions = @dimensions
		@render()
		@context.restore()
		return @
	
	###
	Rotates an image
	###
	@rotate = (angle,center='center') =>
		@context.restore();
		@context.save();
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
		@context.clearRect(0,0,@canvas.width,@canvas.height)
		@context.drawImage(@target,0,0,w,h,-x2,-y2,w,h)
		
		@imageDimensions = @dimensions
		@context.restore()
		@render()
		return @
		
	###
	Flips an image
	###
	@flip = (direction='horizontal')=>
		@context.save()
		if direction is 'horizontal'
			@context.translate(@dimensions.w, 0);
			@context.scale(-1,1) 
		else 
			@context.translate(0,@dimensions.h);
			@context.scale(1,-1)
		
		@context.drawImage(@target,0,0)
		@context.restore()
		@render()
		return @
		
	###
	Reflection
	###
	@reflect = (alphaStart=0.5,gap=0,reflectionAmount=0.25,direction = 'vertical')=>
    @context.save()
    gradientCanvas = document.createElement('canvas')
    gradientCanvas.width = @imageDimensions.w
    gradientCanvas.height = @imageDimensions.h
    
    gradientContext = gradientCanvas.getContext('2d')
    
    @context.globalCompositeOperation = 'source-over'
    
    startPos = 
      x:0
      y:0
    
    targetPos =
      x:0
      y:0
      
    {w,h} = @imageDimensions
    @context.drawImage(@target,0,0)
    if direction is 'vertical'
      h = @imageDimensions.h * reflectionAmount
      @dimensions.h = @imageDimensions.h + gap + h
      gradientContext.translate(0,h)
      gradientContext.scale(1,-1)
      @context.translate(0,h)
      @context.scale(1,-1)
      targetPos.y = @dimensions.h
      startPos.y = @imageDimensions.h-h
      
    gradientImageData = gradientContext.getImageData(0, 0, w, h);
    
    gradientContext.drawImage(@target,startPos.x,startPos.y,w,h,0,0,w,h)
    
    imageData = @context.getImageData(0,0,w,h)
    reflectionImageData = gradientContext.getImageData(0,0,w,h)
    opacity=1
    
    col = 1
    row = 1;
    alphaStep = (255*alphaStart)/h
    until row > h
      until col > w
        alpha = reflectionImageData.data[((row*(w*4)) + (col*4)) + 3]
        alpha = Math.min(alpha,((h-(row-1))*alphaStep))
        reflectionImageData.data[((row*(w*4)) + (col*4)) + 3] = alpha
        col++
      col=1
      row++
      
    @context.putImageData(reflectionImageData, 0,@imageDimensions.h)
    
    @imageDimensions = @dimensions
    
    
    @render()
    @context.restore()
    return @
		
	#load element
	@target = if target isnt null then document.querySelector(target) else document.createElement('canvas')
	@canvas = document.createElement('canvas')
	@context = @canvas.getContext('2d')
	
	if img.match(fileRegExp)
		@image = new Image()
		@image.onload = =>
			@setUpImageData()
			@onLoad()
		@image.src = img
	else
		@image = document.querySelector(img)
		@setUpImageData()
	
	return this
				
root.obscura = obscura