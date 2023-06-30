import 'package:uuid/uuid.dart';

abstract class UniIdentical {
  static const uuid = Uuid();
  static get v1 => uuid.v1();
}
