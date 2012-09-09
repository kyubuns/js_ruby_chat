$ ->
  if not "WebSocket" in window
    # The browser doesn't support WebSocket
    alert "WebSocket NOT supported by your Browser!"
    return

  ws = new WebSocket("ws://localhost:9998")
  ws.binaryType = 'arraybuffer'
  ws.onopen = (evt) ->
    console.debug 'connected'
    $('#chat').prepend('connected')

  ws.onmessage = (evt) ->
    received_msg = evt.data
    console.debug "receive: #{received_msg}"
    receive_obj = msgpack.unpack(new Uint8Array(received_msg))
    $('#chat').prepend("<p>#{receive_obj['aname']} : #{receive_obj['amessage']}</p>")

  $('#send').click ->
    if $('#message').val() is ''
      return
    src = {'name':$('#name').val(), 'message':$('#message').val() }
    $('#message').val("")
    console.debug "sendmessage:"
    console.debug src
    binary = msgpack.pack src
    arraybuffer = new Uint8Array binary
    ws.send arraybuffer.buffer

