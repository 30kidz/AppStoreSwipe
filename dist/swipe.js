var Swipe;

Swipe = (function() {
  function Swipe(container, options) {
    var _ref;
    this.container = container;
    if (this.container == null) {
      return;
    }
    this.el = this.container.children[0];
    this.slides = this.el.children;
    this.len = this.slides.length;
    this.options = options || {};
    this.speed = this.options.speed || 300;
    this.number = this.options.number || 3.5;
    _ref = [0, 0], this.moveX = _ref[0], this.currentX = _ref[1];
    this.setup();
    if (this.el.addEventListener) {
      this.el.addEventListener('touchstart', this, false);
      this.el.addEventListener('touchmove', this, false);
      this.el.addEventListener('touchend', this, false);
      window.addEventListener('resize', this, false);
    }
  }

  Swipe.prototype.setup = function() {
    var index;
    this.width = this.container.getBoundingClientRect().width / this.number | 0;
    this.endX = (this.len - this.number) * this.width;
    this.el.style.width = (this.len * this.width) + 'px';
    index = this.slides.length;
    while (index--) {
      this.slides[index].style.width = "" + this.width + "px";
    }
    return this.positions = this.getPositions();
  };

  Swipe.prototype.getPositions = function() {
    var lastIndex, positions, _i, _results;
    lastIndex = this.len - (this.number | 0);
    positions = (function() {
      _results = [];
      for (var _i = 0; 0 <= lastIndex ? _i <= lastIndex : _i >= lastIndex; 0 <= lastIndex ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this).map((function(_this) {
      return function(i) {
        return i * -_this.width;
      };
    })(this));
    positions[lastIndex] = -this.endX;
    return positions;
  };

  Swipe.prototype.getPosition = function(val) {
    var diffs, index, min;
    diffs = this.positions.map(function(e) {
      return Math.abs(val - e);
    });
    min = Math.min.apply({}, diffs);
    index = diffs.indexOf(min);
    return this.positions[index];
  };

  Swipe.prototype.slide = function(x, duration) {
    var style;
    style = this.el.style;
    style.webkitTransitionDuration = style.transitionDuration = duration + 'ms';
    return style.webkitTransform = "translate3d(" + x + "px,0,0)";
  };

  Swipe.prototype.handleEvent = function(e) {
    switch (e.type) {
      case 'touchstart':
        return this.onTouchStart(e);
      case 'touchmove':
        return this.onTouchMove(e);
      case 'touchend':
        return this.onTouchEnd(e);
      case 'resize':
        return this.setup();
    }
  };

  Swipe.prototype.onTouchStart = function(e) {
    this.start = {
      pageX: e.touches[0].pageX,
      pageY: e.touches[0].pageY,
      time: +(new Date)
    };
    this.isScrolling = void 0;
    this.deltaX = 0;
    this.el.style.webkitTransitionDuration = 0;
    return this.moved = false;
  };

  Swipe.prototype.onTouchMove = function(e) {
    this.deltaX = e.touches[0].pageX - this.start.pageX;
    if (typeof this.isScrolling === 'undefined') {
      this.isScrolling = !!(this.isScrolling || Math.abs(this.deltaX) < Math.abs(e.touches[0].pageY - this.start.pageY));
    }
    if (!this.isScrolling) {
      e.preventDefault();
      this.pastFront = this.moveX > 0 && this.deltaX > 0;
      this.pastBack = this.moveX < -this.endX && this.deltaX < 0;
      this.moveX = this.deltaX + this.currentX;
      if (this.pastFront || this.pastBack) {
        this.moveX = this.moveX - (this.moveX + (this.pastFront ? 0 : this.endX)) * .8;
      }
      this.el.style.webkitTransform = "translate3d(" + this.moveX + "px,0,0)";
      return this.moved = true;
    }
  };

  Swipe.prototype.onTouchEnd = function(e) {
    var isValidSlide;
    isValidSlide = +(new Date) - this.start.time < 250 && Math.abs(this.deltaX) > 40;
    this.currentX = this.getPosition(this.moveX + (isValidSlide && this.moved ? this.deltaX * 1.5 : 0));
    return this.slide(this.currentX, this.speed);
  };

  return Swipe;

})();

new Swipe(document.getElementById('swipe-large'), {
  number: 1.8
});

new Swipe(document.getElementById('swipe-small'));
