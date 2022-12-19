import 'dart:async';
import 'package:async/async.dart';

class CancelableFutureZone {
  late CancelableOperation _myCancelZone;
  late Function fAsync;
  late dynamic posArgs;
  late Map<Symbol, dynamic>? nameArgs;
  late FutureOr<dynamic> Function()? onCancel;
  CancelableFutureZone._internal(
      {required this.fAsync, this.posArgs, this.nameArgs, this.onCancel}) {
    Future future = Function.apply(fAsync, posArgs, nameArgs);
    _myCancelZone = CancelableOperation.fromFuture(future, onCancel: onCancel);
  }
  factory CancelableFutureZone({
    required Function fAsync,
    dynamic params,
    Map<Symbol, dynamic>? nameArgs,
    FutureOr<dynamic> Function()? onCancel,
  }) {
    return CancelableFutureZone._internal(
        fAsync: fAsync,
        posArgs: params,
        nameArgs: nameArgs,
        onCancel: onCancel);
  }

  dynamic wait() {
    Future future = _myCancelZone.value;
    return future.then((value) => value);
  }

  FutureOr<dynamic> cancel() {
    return onCancel?.call();
  }
}
