import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:monkey_lib/service/service.dart';

import '../model/socket_connection.dart';
import '../utils/uuid.dart';

class SocketService<T, K> extends IService {
  final SocketConnection socketConnection;
  late final Map<String, Completer<K>> _requests;

  SocketService._internal({required this.socketConnection}) {
    _requests = {};
  }
  factory SocketService({required SocketConnection socketConnection}) {
    return SocketService._internal(socketConnection: socketConnection);
  }

  @nonVirtual
  Future<K> sendSocketMessage(T data) {
    final completer = Completer<K>();
    final requestId = UniIdentical.v1;
    final request = {
      'id': requestId,
      'data': data,
    };
    _requests[requestId] = completer;
    socketConnection.send(jsonEncode(request));
    return completer.future;
  }

  void onSocketMessage(String encode) {
    final decodedJson = jsonDecode(encode);
    final requestId = decodedJson['id'];
    final data = decodedJson['data'];

    if (_requests.containsKey(requestId)) {
      _requests[requestId]?.complete(data);
      _requests.remove(requestId);
    }
  }

  Future init() async {
    return socketConnection.connect();
  }

  @override
  Future config() async {
    super.baseConfig();
    return Future.value();
  }

  void closeService() {
    socketConnection.close();
  }
}
