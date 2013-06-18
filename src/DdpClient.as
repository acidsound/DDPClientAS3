package {

import com.worlize.websocket.WebSocket;
import com.worlize.websocket.WebSocketEvent;

import flash.display.Sprite;

public class DdpClient extends Sprite {
  private var ws:WebSocket;
  private var connected:Boolean=false;
  private var nextId:uint = 0;
  public function DdpClient() {
    ws = new WebSocket("ws://localhost:3000/websocket", "*");
    ws.addEventListener(WebSocketEvent.OPEN, openWebSocketHandler);
    ws.connect();
  }

  private function openWebSocketHandler(event:WebSocketEvent):void {
    trace("connected");
    ws.addEventListener(WebSocketEvent.MESSAGE, messageWebSocketHandler);
    ws.sendUTF(JSON.stringify({
      msg: "connect",
      version: "pre1",
      support: ["pre1"]
    }));
  }

  private function messageWebSocketHandler(event:WebSocketEvent):void {
    var message:Object = JSON.parse(event.message.utf8Data);
    trace("msg:"+message.msg + " // "+event.message.utf8Data);
    if (message.msg === "connected") {
      connected = true;
      trace("subscribe to post collection");
      ws.sendUTF(JSON.stringify({
        msg: 'sub',
        id: (++nextId).toString(),
        name: 'posts'
      }));
    }
  }
}
}
