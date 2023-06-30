import 'dart:async';
import 'dart:io';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../utils/pretty_json.dart';
import '../utils/type_def.dart';
import 'socket_connection.dart';

/// [MonkeySocketConnection] class using for initialize socket connection to  server.
/// This using [host] to configuration path and port for connection.
/// The constructor take 2 optional function callback parameters [onMessage] and [onError]
/// to response when client receive message from socket server.

class MonkeySocketConnection extends SocketConnection {
  ///[host] variable take a instance of [Uri] class to establish connection to server.
  final Uri host;
  late final WebSocketChannel _socketChannel;

  MonkeySocketConnection._internal({SocketCallBack? onMessage, SocketErrorCallBack? onError, required this.host}) {
    super.onMessage = onMessage;
    super.onError = onError;
  }

  factory MonkeySocketConnection({SocketCallBack? onMessage, SocketErrorCallBack? onError, required Uri host}) {
    return MonkeySocketConnection._internal(onMessage: onMessage, onError: onError, host: host);
  }

  @override
  Future connect() async {
    final client = HttpClient();
    client.connectionTimeout = (Duration(milliseconds: 2000));
    final request = await client.openUrl('GET', host);
    request.headers
      ..set('Connection', 'Upgrade')
      ..set('Upgrade', 'websocket')
      ..set('Sec-WebSocket-Key', 'x3JJHMbDL1EzLkh9GBhXDw==')
      ..set('Sec-WebSocket-Version', '13');
    final response = await request.close();
    final socket = await response.detachSocket();
    final innerChannel = StreamChannel<List<int>>(socket, socket);
    _socketChannel = WebSocketChannel(
      innerChannel,
      serverSide: false,
    );
    var n = 0;
    runZonedGuarded(
      () {
        _socketChannel.stream.listen((message) {
          if (n == 0) {
            Logger.i("echo message from monkey wss: $message");
          } else {
            onMessage?.call(message);
          }
          n++;
        }, onError: (error) {
          onError?.call(error, error);
        });
      },
      Logger.e,
    );
  }

  @override
  send(String decode) {
    _socketChannel.sink.add(decode);
  }

  @override
  Future close() async {
    return _socketChannel.sink.close(status.goingAway);
  }
}
