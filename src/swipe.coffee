class Swipe
  constructor: (@container, options) ->
    return if !@container?
    @el = @container.children[0]
    @slides = @el.children
    @len = @slides.length
    @options = options or {}
    @speed = @options.speed or 300
    @number = @options.number or 3.5
    [@moveX, @currentX] = [0, 0]
    @setup()
    if @el.addEventListener
      @el.addEventListener('touchstart', @, false)
      @el.addEventListener('touchmove', @, false)
      @el.addEventListener('touchend', @, false)
      window.addEventListener('resize', @, false)

  setup: ->
    @width = @container.getBoundingClientRect().width / @number | 0
    @endX = (@len - @number) * @width
    @el.style.width = (@len * @width) + 'px'
    index = @slides.length
    @slides[index].style.width = "#{@width}px" while index--
    @positions = @getPositions()

  getPositions: ->
    lastIndex = @len - (@number | 0)
    positions = [0..lastIndex].map (i) => i * -@width
    positions[lastIndex] = -@endX
    positions

  getPosition: (val) ->
    diffs = @positions.map (e) -> Math.abs(val - e)
    min = Math.min.apply {}, diffs
    index = diffs.indexOf min
    @positions[index]

  slide: (x, duration) ->
    style = @el.style
    style.webkitTransitionDuration = style.transitionDuration = duration + 'ms'
    style.webkitTransform = "translate3d(#{x}px,0,0)"

  handleEvent: (e) ->
    switch e.type
      when 'touchstart' then @onTouchStart(e)
      when 'touchmove'  then @onTouchMove(e)
      when 'touchend'  then @onTouchEnd(e)
      when 'resize' then @setup()

  onTouchStart: (e) ->
    @start = 
      pageX: e.touches[0].pageX
      pageY: e.touches[0].pageY
      time: +new Date
    @isScrolling = undefined
    @deltaX = 0
    @el.style.webkitTransitionDuration = 0
    @moved = false

  onTouchMove: (e) ->
    @deltaX = e.touches[0].pageX - @start.pageX
    @isScrolling = !!( @isScrolling || Math.abs(@deltaX) < Math.abs(e.touches[0].pageY - @start.pageY) ) if typeof @isScrolling is 'undefined'
    if !@isScrolling
      e.preventDefault()
      @pastFront = @moveX > 0 && @deltaX > 0
      @pastBack = @moveX < -@endX && @deltaX < 0
      @moveX = @deltaX + @currentX
      @moveX = @moveX - (@moveX + (if @pastFront then 0 else @endX)) * .8 if @pastFront or @pastBack
      @el.style.webkitTransform = "translate3d(#{@moveX}px,0,0)"
      @moved = true

  onTouchEnd: (e) ->
    isValidSlide = +new Date - @start.time < 250 && Math.abs(@deltaX) > 40
    @currentX = @getPosition(@moveX + if isValidSlide && @moved then @deltaX * 1.5 else 0)
    @slide @currentX, @speed

new Swipe document.getElementById('swipe-large'),
  number: 1.8

new Swipe document.getElementById('swipe-small')
