
import '../utils/type_def.dart';

abstract class SocketConnection {
  Future connect();
  close();
  send(String decode);
  SocketCallBack? onMessage;
  SocketErrorCallBack? onError;
}
