(function() {
  var obscura, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = typeof exports != "undefined" && exports !== null ? exports : this;
  obscura = function(img, target) {
    this.canvas = document.querySelector(target);
    this.context = this.canvas.getContext('2d');
    this.image = document.querySelector(img);
    this.load = __bind(function(x, y, w, h) {
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
      this.canvas.width = w;
      this.canvas.height = h;
      return this.context.drawImage(this.image, x, y, w, h);
    }, this);
    this.resize = __bind(function(scale, keepProportions) {
      if (keepProportions == null) {
        keepProportions = true;
      }
      this.load();
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
      this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
      return this.load(0, 0, scale.w, scale.h);
    }, this);
    return this;
  };
  root.obscura = obscura;
}).call(this);
