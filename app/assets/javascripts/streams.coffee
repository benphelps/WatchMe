class Watchme
  
  constructor: ->
    @stream_id = gon.stream_id or false
    @stream_name = gon.stream_name or false
    @chat = new Chat 'chat'
    @player = new Player
    @connect()
  
  connect: ->
    @debug 'Connecting'
    Danthes.subscribe "/stream/#{@stream_id}", (data, channel) =>
      @handle data

  handle: (data) ->
    switch data.type
      when 'message'
        @chat.handle data
      when 'ad'
        @player.handleAd data
      when 'info_update'
        @handleUpdate data
      when 'go_live'
        @handleLive data
      when 'debug'
        @debug data
        
  handleUpdate: (data) ->
    $('#stream_name').html(data.stream.name);
    $('#stream_desc').html(data.stream.desc);
    
  handleLive: (data) ->
    $.get "/#{@stream_name}/player", (data) ->
      $('#player').html data

  debug: (data) ->
    console.log data

# Handle Chat
class Chat
  
  constructor: (id) ->
    @element = $("##{id}")
    @templates = []
    @loadTemplate 'message'
    @scroll()
    
  handle: (data) ->
    @write data

  loadTemplate: (name) ->
    @templates[name] = $("##{name}_tpl").html()
    Mustache.parse @templates[name]
  
  write: (data) ->
    @element.append Mustache.render @templates.message, data
    @scroll()
    
  scroll: ->
    @element.scrollTop @element.prop "scrollHeight"


# Handle Ads
class Player
  
  handleAd: (data) ->
    if data.url and document.player
      @playAd data.url

  playAd: (url) ->
    if document.player.getVolume() <= 0
      document.player.setVolume 0.25
    document.player.displayLiniarAd url


APP.streams = 
  init: () ->
    # Empty

  show: () ->
    
    # Connect to the websocket and setup chat
    watchme = new Watchme
    
    # Handle form submits
    $('form#new_message').keypress (event) ->
      if $('#message_message').val() == "" and event.which == 13
        false
      else
        if event.which == 13
          message = $(this).serialize()
          $.ajax(
            type: "POST"
            url: $(this).attr('action')
            data: message
            dataType: "HTML"
          ).success (data) ->
            $('#message_message').val ""
          false