$ ->
  if not "WebSocket" in window
    alert "WebSocket NOT supported by your Browser!"
    return

  ws = new WebSocket "ws://localhost:9998"
  ws.binaryType = 'arraybuffer'

  ws.onopen = (evt) ->
    $('#chat').prepend 'connected'

  ws.onclose = (evt) ->
    $('#chat').prepend 'clooooooooooooooooooooooose'

  ws.onmessage = (evt) ->
    received_msg = evt.data
    receive_obj = msgpack.unpack new Uint8Array received_msg
    $('#chat').prepend "<p>#{receive_obj['aname']} : #{receive_obj['amessage']}</p>"

  $('#send').click ->
    # なんかメッセージかけよ！
    return if $('#message').val() is ''

    binary = msgpack.pack {'name':$('#name').val(), 'message':$('#message').val() }
    arraybuffer = new Uint8Array binary
    ws.send arraybuffer.buffer

    $('#message').val ""
