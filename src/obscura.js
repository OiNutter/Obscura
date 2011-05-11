(function() {
  var obscura, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  obscura = function(img, target) {
    this.canvas = document.querySelector(target);
    this.context = this.canvas.getContext('2d');
    this.image = document.querySelector(img);
    /*
    	load image
    	*/
    this.load = __bind(function(x, y, w, h, cw, ch) {
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
      this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.canvas.width = cw != null ? cw : w;
      this.canvas.height = ch != null ? ch : h;
      this.context.drawImage(this.image, x, y, w, h);
      return this;
    }, this);
    /*
    	resizes an image
    	*/
    this.resize = __bind(function(scale, keepProportions) {
      if (keepProportions == null) {
        keepProportions = true;
      }
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
      scale.w = typeof scale.w === 'string' && scale.w.match(/%/) ? this.canvas.width * (parseFloat(scale.w) / 100) : parseFloat(scale.w);
      scale.h = typeof scale.h === 'string' && scale.h.match(/%/) ? this.canvas.height * (parseFloat(scale.h) / 100) : parseFloat(scale.h);
      if (keepProportions) {
        if (scale.w > scale.h || (scale.w === scale.h && this.canvas.height > this.canvas.width)) {
          scale.h = (scale.w / this.canvas.width) * this.canvas.height;
        } else if (scale.h > scale.w || (scale.h === scale.w && this.canvas.width > this.canvas.height)) {
          scale.w = (scale.h / this.canvas.height) * this.canvas.width;
        }
      }
      this.load(0, 0, scale.w, scale.h);
      return this;
    }, this);
    /*
    	Crops an image
    	*/
    this.crop = __bind(function(x, y, w, h) {
      this.load(-x, -y, this.canvas.width, this.canvas.height, w, h);
      return this;
    }, this);
    /*
    	Resizes an image to fit completely into a given space
    	*/
    this.fit = __bind(function(w, h) {
      if (w > this.canvas.width && h > this.canvas.height) {
        return this;
      }
      if (w < h || this.canvas.width > this.canvas.height || (w === h && this.canvas.height > this.canvas.width)) {
        h = (w / this.canvas.width) * this.canvas.height;
      } else if (h < w || this.canvas.height > this.canvas.width || (h === w && this.canvas.width > this.canvas.height)) {
        w = (h / this.canvas.height) * this.canvas.width;
      }
      this.load(0, 0, w, h);
      return this;
    }, this);
    this.load();
    /*
    	Rotates an image
    	*/
    this.rotate = __bind(function(angle, center) {
      var ch, cw, h, w, x, x2, y, y2;
      if (center == null) {
        center = 'center';
      }
      w = this.canvas.width;
      h = this.canvas.height;
      if (angle === 90 || angle === 120) {
        cw = h;
        ch = w;
      } else if (angle === 180 || angle === 360) {
        cw = w;
        ch = h;
      } else {
        cw = w * Math.cos(angle * Math.PI / 180) + h * Math.sin(angle * Math.PI / 180);
        ch = h * Math.cos(angle * Math.PI / 180) + w * Math.sin(angle * Math.PI / 180);
      }
      console.log(cw);
      console.log(ch);
      this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.canvas.width = cw;
      this.canvas.height = ch;
      if (typeof center !== 'object') {
        if (center.match(/(top)/)) {
          y = 0;
          y2 = (ch - h) / 2;
        } else if (center.match(/(bottom)/)) {
          y = this.canvas.height;
          y2 = this.canvas.height - (ch - h) / 2;
        } else if (center.match(/(center)/)) {
          y = this.canvas.height / 2;
          y2 = h / 2;
        }
        if (center.match(/(left)/)) {
          x = 0;
          x2 = (cw - w) / 2;
        } else if (center.match(/(middle)/)) {
          x = this.canvas.width;
          x2 = this.canvas.height - (cw - w) / 2;
        } else if (center.match(/(center)/)) {
          x = this.canvas.width / 2;
          x2 = w / 2;
        }
      }
      this.context.translate(x, y);
      this.context.rotate(angle * Math.PI / 180);
      this.context.drawImage(this.image, -x2, -y2, w, h);
      return this;
    }, this);
    return this;
  };
  root.obscura = obscura;
}).call(this);
