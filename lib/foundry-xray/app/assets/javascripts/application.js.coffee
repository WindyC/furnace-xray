#= require vendor/d3.v3
#= require vendor/dagre
#= require vendor/jquery
#= require vendor/ui.jquery
#= require vendor/sugar-1.3.8
#= require vendor/stacktrace-0.4
#= require vendor/chosen.jquery
#= require_tree ./lib
#= require_self

$ ->
  svg    = $('svg')
  slider = $('#timeline .slider')
  functions = $('#functions select')
  window.index = 0

  # Resize SVG canvas
  resize = -> svg.height $('html').height() - $('#toolbar').outerHeight()
  resize() && $(window).bind 'resize', resize

  # Fill functions selector
  window.data.each (f, i) -> functions.append "<option value='#{i}'>#{f.name}</option>"
  functions.chosen()
  functions.change ->
    window.index = functions.val()
    draw()

  # Setup slider
  slider.slider
    min: 0
    change: -> $('#timeline input').val $(@).slider('value')
    slide: -> $('#timeline input').val $(@).slider('value')

  # Draw routine
  draw = ->
    try
      $('#timeline').show()

      data = window.data[window.index.toNumber()]

      slider.slider
        max: data.events.length-1
        value: data.events.length-1

      $('#timeline #steps').text data.events.length-1

      window.drawer?.clear()
      window.input = new Input data
      window.input.rebuild()
      window.drawer = new Drawer(new Graph(input))

      $('#title').removeClass('error').html window.input.function.title()
    catch error
      console.log error
      $('#timeline').hide()
      $('#title').addClass('error').text 'Unable to build graph: problem dumped to console'

  # Start with firts function
  draw()