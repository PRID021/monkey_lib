import 'package:meta/meta.dart';

import '../utils/async_utils.dart';

abstract class IService {
  late final bool _isNeedWait;
  bool get isNeedWait => _isNeedWait;
  dynamic config();

  @mustCallSuper
  dynamic baseConfig() {
    _isNeedWait = isAsync(config);
  }
}
