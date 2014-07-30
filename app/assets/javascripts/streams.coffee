class LiveChat
  constructor: (@stream, @id) ->
    @element = $("##{@stream}")
    @stream_id = @id
    @templates =
      message: $('#message_tpl').html();
      
  # Append the message to the chat element
  write: (data) ->
    @element.append Mustache.render @templates.message, data
  
  # Connect to the chat socket
  subscribe: ->
    Danthes.subscribe "/stream/#{@stream_id}", (data, channel) =>
      @write data
      @scroll()
    
  scroll: ->
    @element.scrollTop @element.prop "scrollHeight"

APP.streams = 
  init: () ->
    # Empty
  show: () ->
    chat = new LiveChat "chat", gon.stream_id
    chat.scroll()
    chat.subscribe()
    
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
        