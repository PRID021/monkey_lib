import 'dart:async';

import '../model/monkey_socket_connection.dart';
import '../service/socket_service.dart';
import '../utils/pretty_json.dart';


Future<void> main() async {
  void onMessage(dynamic encode) {
    Logger.i(encode);
  }

  dynamic onError(dynamic error, dynamic stackTrace) {
    Logger.e(error, stackTrace);
  }

  Uri host = Uri.https('echo.websocket.events', '');
  SocketService monkeySocketService = SocketService(
    socketConnection: MonkeySocketConnection(
      host: host,
      onMessage: onMessage,
      onError: onError,
    ),
  );
  monkeySocketService.config();
  await monkeySocketService.init();
  //monkeySocketService.closeService();
  monkeySocketService.sendSocketMessage("Hello server.");

  runZonedGuarded(() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      monkeySocketService.sendSocketMessage(DateTime.now().toIso8601String());
    });
  }, onError);
}
