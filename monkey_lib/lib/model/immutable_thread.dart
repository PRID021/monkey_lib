import 'package:meta/meta.dart';

class Message {
  final String message;
  const Message(this.message);
}

/// This class using to create an list that can't modifies from the client code.
/// It receive a [List] of type [T] as argument and produce an uneditable list as result.
@immutable
class ImmutableList<T> {
  late final List<T> dataStore;

  ImmutableList._internal(List<T> data) {
    dataStore = List.unmodifiable(data);
  }

  factory ImmutableList(List<T> data) => ImmutableList._internal(List.unmodifiable(data));

  ImmutableList add(T item) {
    List<T> mutableList = dataStore.toList();
    mutableList.add(item);
    return ImmutableList(mutableList);
  }

  ImmutableList remove(T item) {
    List<T> mutableList = dataStore.toList();
    mutableList.remove(item);
    return ImmutableList(mutableList);
  }
}
