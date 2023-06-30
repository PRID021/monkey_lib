import 'app_exception.dart';

abstract class Command<T> {
  Future<T> execute();
}

typedef BizzoneCommandCallback<T, K> = Future<T?> Function(K? data);

class BizzoneCommand<T, K> implements Command {
  final BizzoneCommandCallback<T, K> callback;
  final dynamic data;
  final Function(T? result)? onSuccess;
  final Function? onStart;
  final Function? onDone;
  final Function(AppException exception)? onError;
  BizzoneCommand({
    required this.callback,
    this.data,
    this.onSuccess,
    this.onError,
    this.onStart,
    this.onDone,
  });
  @override
  Future<T?> execute() async {
    dynamic result;
    try {
      if (onStart != null) {
        await onStart?.call();
      }
      result = await callback(data);
      if (onSuccess != null) {
        onSuccess?.call(result);
      }
    } on AppException catch (e) {
      if (onError != null) {
        await onError?.call(e);
      }
    } finally {
      if (onDone != null) {
        await onDone?.call();
      }
    }

    return result;
  }
}
