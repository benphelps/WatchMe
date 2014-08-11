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
      #when 'go_live'
      when 'go_dark'
        @handleViewers {viewers: 'Offline'}
      when 'viewers'
        @handleViewers data
      when 'debug'
        @debug data
        
  handleUpdate: (data) ->
    $('#stream_name').html(data.stream.name);
    $('#stream_desc').html(data.stream.desc);
    $('#stream_body').html(data.stream.markdown);
    
  handleLive: (data) ->
    $.get "/#{@stream_name}/player", (data) ->
      $('#player').html data
  
  handleViewers: (data) ->
    $('#viewers').text data.viewers

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
    data.myself = 'myself' if gon.user.username == data.username
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
    
class LastFm
  constructor: (user_id) ->
    @user_id = user_id
    @playing = { }
    @main =   $('#lastfm')
    @song = $('#lastfm_song')
    @artist = $('#lastfm_artist')
    @img = $('#lastfm_img')
    @amazon = $('#amazonref')
    @amazon.click =>
      window.open @amazon.data('link')
    @spotify = $('#spotifyopen')
    @spotify.click =>
      if @spotify.data('link').length > 1
        window.open @spotify.data('link')
    @song.click =>
      if @song.data('link').length > 1
        window.open 'http://musicbrainz.org/track/' +  @song.data('link') 
    @artist.click =>
      if @artist.data('link').length > 1
        window.open 'http://musicbrainz.org/artist/' +  @artist.data('link') 

  subscribe: ->
    @fetch()
    setInterval @fetch, 5000

  fetch: () =>
    $.get "lastfm/#{@user_id}", (data) =>
      if @playing.name != data.name
        @playing = data
        @update()

  update: ->
    if @playing.playing
      if @main.is(':hidden')
        @main.show()
      if @playing.amazon and @amazon.is(':hidden')
        @amazon.show()
      if @playing.amazon == false
        @amazon.hide()
      if @playing.spotify and @spotify.is(':hidden')
        @spotify.show()
      if @playing.spotify == false
        @spotify.hide()
      if @playing.image.length > 1
        @img.html ''
        @img.css 'background-image', "url('#{@playing.image}')"
      else
        @img.css 'background-image', 'none'
        @img.html '<span class="white glyphicon glyphicon-music"></span>'
      @song.data 'link', @playing.mbid.track
      @artist.data 'link', @playing.mbid.artist
      @song.html @playing.name
      @artist.html @playing.artist
      @amazon.data 'link', @playing.amazon
      @spotify.data 'link', @playing.spotify
    else
      @main.hide()
    

APP.streams = 
  init: () ->
    # Empty
  _form: () ->
    $('#pagedown-textarea').pagedownBootstrap()
    
  show: () ->
    
    # Connect to the websocket and setup chat
    watchme = new Watchme
    
    lastfm = new LastFm gon.streamer
    lastfm.subscribe()
    
    RestInPlaceEditor.forms["markdown"] =
        activateForm : ->
          value = $.trim(@elementHTML())
          @$element.html("""<form action="javascript:void(0)" style="display:inline;">
<textarea id="pagedown-textarea" class="form-control rest-in-place-#{@attributeName}" rows="10" placeholder="#{@placeholder}"></textarea>
<input class="btn-right btn btn-sm btn-primary" type="submit" value="Save Changes">
</form>""")
          @$element.find('textarea').val(value)
          @$element.find('textarea')[0].select()
          @$element.find("textarea").keyup (e) =>
            @abort() if e.keyCode == 27
          @$element.find("input[type=submit]").click => @update()
        getValue : ->
          @$element.find("textarea").val()
    $('#stream_body').bind 'activate.rest-in-place', (event) ->
      # Nothing
    $('#stream_body').bind 'ready.rest-in-place', (event, json) ->
      $('#pagedown-textarea').val($('#stream_markdown').val())
      $('#pagedown-textarea').pagedownBootstrap()
    $('#stream_body').bind 'success.rest-in-place', (event, json) ->
      $('#stream_markdown').val(json.markdown)
      $el = $(this);
      $el.html(json.body)
      console.log json
      
    
    $('#name_color').colorselector
      callback: (value, color, title) ->
        console.log value
        $.post '/settings/color',
          color: value
          (data) ->
            $('.myself').css 'color', "##{value}"
    
    $('.settings').on 'click', (event) ->
        event.preventDefault()
        $('#settings_panel').toggle()
    
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