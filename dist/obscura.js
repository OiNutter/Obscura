(function() {
  var obscura, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  obscura = function(img, target) {
    var fileRegExp;
    if (target == null) {
      target = null;
    }
    /*
    	internal variables
    	*/
    fileRegExp = /\.((jp(e)?g)|(png)|(gif))$/i;
    this.onLoad = __bind(function() {
      return true;
    }, this);
    /*
    	Set up local variables with image data from source
    	*/
    this.setUpImageData = __bind(function() {
      this.dimensions = {
        w: this.image.width,
        h: this.image.height
      };
      this.imageDimensions = this.dimensions;
      this.canvas.width = this.canvas.height = this.dimensions.w > this.dimensions.h ? this.dimensions.w * 2 : this.dimensions.h * 2;
      return this.load(0, 0, this.image.width, this.image.height, this.image);
    }, this);
    /*
    	load image
    	*/
    this.load = __bind(function(x, y, w, h, image) {
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      if (w == null) {
        w = this.image.width;
      }
      if (h == null) {
        h = this.image.height;
      }
      if (image == null) {
        image = this.target;
      }
      this.context.globalCompositeOperation = "copy";
      this.context.drawImage(image, 0, 0, this.imageDimensions.w, this.imageDimensions.h, x, y, w, h);
      this.imageDimensions = {
        w: w,
        h: h
      };
      this.render();
      return this;
    }, this);
    /*
    	render edited image to target
    	*/
    this.render = __bind(function() {
      this.target.width = this.dimensions.w;
      this.target.height = this.dimensions.h;
      this.target.getContext('2d').globalCompositeOperation = "copy";
      this.target.getContext('2d').drawImage(this.canvas, 0, 0);
      this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
      return this;
    }, this);
    /*
    	Convert image to base64 encoded string for saving to server
    	*/
    this.save = __bind(function() {
      return this.target.toDataURL();
    }, this);
    /*
    	resizes an image
    	*/
    this.resize = __bind(function(scale, keepProportions, crop) {
      var currentDimensions, newScale;
      if (keepProportions == null) {
        keepProportions = true;
      }
      if (crop == null) {
        crop = false;
      }
      this.context.save();
      if (Object.prototype.toString.call(scale) === '[object Array]') {
        scale = {
          w: scale[0],
          h: scale[1]
        };
      } else if (typeof scale !== 'object') {
        scale = {
          w: scale,
          h: scale
        };
      }
      scale.w = typeof scale.w === 'string' && scale.w.match(/%/) ? this.dimensions.w * (parseFloat(scale.w) / 100) : parseFloat(scale.w);
      scale.h = typeof scale.h === 'string' && scale.h.match(/%/) ? this.dimensions.h * (parseFloat(scale.h) / 100) : parseFloat(scale.h);
      currentDimensions = this.dimensions;
      this.dimensions = scale;
      newScale = scale;
      if (keepProportions) {
        if (scale.w > scale.h || (scale.w === scale.h && currentDimensions.w > currentDimensions.h)) {
          newScale.w = scale.w;
          newScale.h = (scale.w / currentDimensions.w) * currentDimensions.h;
        } else if (scale.h > scale.w || (scale.h === scale.w && currentDimensions.h > currentDimensions.w)) {
          newScale.w = (scale.h / currentDimensions.h) * currentDimensions.w;
          newScale.h = scale.h;
        }
        if (!crop) {
          this.dimensions = newScale;
        }
      }
      this.context.drawImage(this.target, 0, 0, newScale.w, newScale.h);
      this.render();
      this.imageDimensions = this.dimensions;
      this.context.restore();
      return this;
    }, this);
    /*
    	Crops an image
    	*/
    this.crop = __bind(function(x, y, w, h) {
      var size;
      this.context.save();
      size = this.dimensions;
      this.dimensions = {
        w: w,
        h: h
      };
      this.context.drawImage(this.target, x, y, w, h, 0, 0, w, h);
      this.imageDimensions = {
        w: w,
        h: h
      };
      this.render();
      this.context.restore();
      return this;
    }, this);
    /*
    	Resizes an image to fit completely into a given space
    	*/
    this.fit = __bind(function(w, h) {
      this.context.save();
      if (w > this.canvas.width && h > this.canvas.height) {
        return this;
      }
      if (w < h || this.imageDimensions.w > this.imageDimensions.h || (w === h && this.imageDimensions.h > this.imageDimensions.w)) {
        h = (w / this.imageDimensions.w) * this.imageDimensions.h;
      } else if (h < w || this.imageDimensions.h > this.imageDimensions.w || (h === w && this.imageDimensions.w > this.imageDimensions.h)) {
        w = (h / this.imageDimensions.h) * this.imageDimensions.w;
      }
      this.dimensions = {
        w: w,
        h: h
      };
      this.context.drawImage(this.target, 0, 0, w, h);
      this.imageDimensions = this.dimensions;
      this.render();
      this.context.restore();
      return this;
    }, this);
    /*
    	Rotates an image
    	*/
    this.rotate = __bind(function(angle, center) {
      var ch, cw, h, w, x, x2, y, y2, _ref, _ref2;
      if (center == null) {
        center = 'center';
      }
      this.context.restore();
      this.context.save();
      _ref = this.dimensions, w = _ref.w, h = _ref.h;
      if (angle === 90 || angle === 120) {
        _ref2 = {
          h: h,
          w: w
        }, cw = _ref2.cw, ch = _ref2.ch;
      } else if (angle !== 180 || angle !== 360) {
        cw = w * Math.cos(angle * Math.PI / 180) + h * Math.sin(angle * Math.PI / 180);
        ch = h * Math.cos(angle * Math.PI / 180) + w * Math.sin(angle * Math.PI / 180);
      }
      this.context.globalCompositeOperation = "copy";
      if (typeof center !== 'object') {
        if (center.match(/(top)/)) {
          y = 0;
          y2 = (ch - h) / 2;
        } else if (center.match(/(bottom)/)) {
          y = ch;
          y2 = ch - (ch - h) / 2;
        } else if (center.match(/(center)/)) {
          y = ch / 2;
          y2 = h / 2;
        }
        if (center.match(/(left)/)) {
          x = 0;
          x2 = (cw - w) / 2;
        } else if (center.match(/(middle)/)) {
          x = cw;
          x2 = cw - (cw - w) / 2;
        } else if (center.match(/(center)/)) {
          x = cw / 2;
          x2 = w / 2;
        }
      }
      this.dimensions.w = cw;
      this.dimensions.h = ch;
      this.context.translate(x, y);
      this.context.rotate(angle * Math.PI / 180);
      this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.context.drawImage(this.target, 0, 0, w, h, -x2, -y2, w, h);
      this.imageDimensions = this.dimensions;
      this.context.restore();
      this.render();
      return this;
    }, this);
    /*
    	Flips an image
    	*/
    this.flip = __bind(function(direction) {
      if (direction == null) {
        direction = 'horizontal';
      }
      this.context.save();
      if (direction === 'horizontal') {
        this.context.translate(this.dimensions.w, 0);
        this.context.scale(-1, 1);
      } else {
        this.context.translate(0, this.dimensions.h);
        this.context.scale(1, -1);
      }
      this.context.drawImage(this.target, 0, 0);
      this.context.restore();
      this.render();
      return this;
    }, this);
    /*
    	Reflection
    	*/
    this.reflect = __bind(function(alphaStart, gap, reflectionAmount, direction) {
      var alpha, alphaStep, col, gradientCanvas, gradientContext, gradientImageData, h, imageData, opacity, reflectionImageData, row, startPos, targetPos, w, _ref;
      if (alphaStart == null) {
        alphaStart = 0.5;
      }
      if (gap == null) {
        gap = 0;
      }
      if (reflectionAmount == null) {
        reflectionAmount = 0.25;
      }
      if (direction == null) {
        direction = 'vertical';
      }
      this.context.save();
      gradientCanvas = document.createElement('canvas');
      gradientCanvas.width = this.imageDimensions.w;
      gradientCanvas.height = this.imageDimensions.h;
      gradientContext = gradientCanvas.getContext('2d');
      this.context.globalCompositeOperation = 'source-over';
      startPos = {
        x: 0,
        y: 0
      };
      targetPos = {
        x: 0,
        y: 0
      };
      _ref = this.imageDimensions, w = _ref.w, h = _ref.h;
      this.context.drawImage(this.target, 0, 0);
      if (direction === 'vertical') {
        h = this.imageDimensions.h * reflectionAmount;
        this.dimensions.h = this.imageDimensions.h + gap + h;
        gradientContext.translate(0, h);
        gradientContext.scale(1, -1);
        this.context.translate(0, h);
        this.context.scale(1, -1);
        targetPos.y = this.dimensions.h;
        startPos.y = this.imageDimensions.h - h;
      }
      gradientImageData = gradientContext.getImageData(0, 0, w, h);
      gradientContext.drawImage(this.target, startPos.x, startPos.y, w, h, 0, 0, w, h);
      imageData = this.context.getImageData(0, 0, w, h);
      reflectionImageData = gradientContext.getImageData(0, 0, w, h);
      opacity = 1;
      col = 1;
      row = 1;
      alphaStep = (255 * alphaStart) / h;
      while (!(row > h)) {
        while (!(col > w)) {
          alpha = reflectionImageData.data[((row * (w * 4)) + (col * 4)) + 3];
          alpha = Math.min(alpha, (h - (row - 1)) * alphaStep);
          reflectionImageData.data[((row * (w * 4)) + (col * 4)) + 3] = alpha;
          col++;
        }
        col = 1;
        row++;
      }
      this.context.putImageData(reflectionImageData, 0, this.imageDimensions.h);
      this.imageDimensions = this.dimensions;
      this.render();
      this.context.restore();
      return this;
    }, this);
    this.target = target !== null ? document.querySelector(target) : document.createElement('canvas');
    this.canvas = document.createElement('canvas');
    this.context = this.canvas.getContext('2d');
    if (img.match(fileRegExp)) {
      this.image = new Image();
      this.image.onload = __bind(function() {
        this.setUpImageData();
        return this.onLoad();
      }, this);
      this.image.src = img;
    } else {
      this.image = document.querySelector(img);
      this.setUpImageData();
    }
    return this;
  };
  root.obscura = obscura;
}).call(this);
