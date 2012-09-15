import js.JQuery;
import js.Lib;
import haxe.io.Bytes;

extern class Blob {}
extern class ArrayBuffer {}

extern class Uint8Array implements ArrayAccess<Int> {
  var buffer : ArrayBuffer;
  var length : Int;
  public function new(array:Dynamic) : Void;
}

extern class WebSocket {
  static var CONNECTING : Int;
  static var OPEN : Int;
  static var CLOSING : Int;
  static var CLOSED : Int;

  var readyState(default,null) : Int;
  var bufferedAmount(default,null) : Int;

  dynamic function onopen() : Void;
  dynamic function onmessage(e:{data:ArrayBuffer}) : Void;
  dynamic function onclose() : Void;
  dynamic function onerror() : Void;

  var url(default,null) : String;
  var extensions(default,null) : String;
  var protocol(default,null) : String;
  var binaryType : String;

  function new( url : String, ?protocol : Dynamic ) : Void;
  function send( data : ArrayBuffer ) : Bool;
  function close( ?code : Int, ?reason : String ) : Void;
}

extern class Msgpack {
  static function pack(data:Dynamic):Dynamic;       //pack  ::json->array[]
  static function unpack(data:Uint8Array):Dynamic;  //unpack::array[]->json
}

class Main {
  static function main() {
    new JQuery(Lib.document).ready(function(e) {
      var ws = new WebSocket("ws://localhost:9998");
      ws.binaryType = "arraybuffer";

      ws.onopen = function() {
        new JQuery("#chat").append("<p>onopen</p>");
      }

      ws.onclose = function() {
        new JQuery("#chat").append("<p>onclose</p>");
      }

      ws.onmessage = function(e:{data:ArrayBuffer}) {
        var uint8array = new Uint8Array(e.data);
        var pack:Dynamic = Msgpack.unpack(uint8array);
        var name:String = pack.aname;
        var msg:String = pack.amessage;
        new JQuery("#chat").append("<p>" + name + " : " + msg + "</p>");
      }

      new JQuery("#send").click(function(){
        var name:String = new JQuery("#name").val();
        var msg:String = new JQuery("#message").val();

        var hash:Dynamic = {"name":name, "message":msg};
        var pack:Dynamic = Msgpack.pack(hash);
        var uint8array = new Uint8Array(pack);

        ws.send(uint8array.buffer);
      });
    });
  }
}
