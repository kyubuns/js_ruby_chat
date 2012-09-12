# coding: utf-8

require 'bundler/setup'
require 'em-websocket'

# TODO: pull request to upstream!!!1111
module EventMachine::WebSocket
  class Connection
    def send_binary(data)
      if @handler
        @handler.send_frame(:binary, data)
      else
        raise WebSocketError, "Cannot send binary before onopen callback"
      end
    end
  end
end

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
