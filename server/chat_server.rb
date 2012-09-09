# coding: utf-8

require_relative './em-websocket/lib/em-websocket.rb'
require 'msgpack'

connections = {}

p "waiting..."

EventMachine::WebSocket.start(:host => "localhost", :port => 9998) do |ws|
  ws.onopen {
    connections[ws] = ws
    p "someone comes."
    p "#{connections.length} people are connecting."
  }

  ws.onclose {
    connections.delete ws
    p "someone leaves."
    p "#{connections.length} people are connecting."
  }

  ws.onmessage { |msg|
    p "onmessage"

    # 受信処理
    receive_obj = MessagePack.unpack(msg)
    name = receive_obj['name']
    message = receive_obj['message']
    p name + ':' + message

    # 送信処理
    src = {'aname'=>name, 'amessage'=>message}  #データ読んで組み替えしてみたかっただけ。
    binary = MessagePack.pack(src)
    connections.each { |key, con| con.send_binary binary }
  }
end
