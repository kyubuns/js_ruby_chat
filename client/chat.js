// Generated by CoffeeScript 1.3.3
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  $(function() {
    var ws, _ref;
    if (_ref = !"WebSocket", __indexOf.call(window, _ref) >= 0) {
      alert("WebSocket NOT supported by your Browser!");
      return;
    }
    ws = new WebSocket("ws://localhost:9998");
    ws.binaryType = 'arraybuffer';
    ws.onopen = function(evt) {
      console.debug('connected');
      return $('#chat').prepend('connected');
    };
    ws.onmessage = function(evt) {
      var receive_obj, received_msg;
      received_msg = evt.data;
      console.debug("receive: " + received_msg);
      receive_obj = msgpack.unpack(new Uint8Array(received_msg));
      return $('#chat').prepend("<p>" + receive_obj['aname'] + " : " + receive_obj['amessage'] + "</p>");
    };
    return $('#send').click(function() {
      var arraybuffer, binary, src;
      if ($('#message').val() === '') {
        return;
      }
      src = {
        'name': $('#name').val(),
        'message': $('#message').val()
      };
      $('#message').val("");
      console.debug("sendmessage:");
      console.debug(src);
      binary = msgpack.pack(src);
      arraybuffer = new Uint8Array(binary);
      return ws.send(arraybuffer.buffer);
    });
  });

}).call(this);
