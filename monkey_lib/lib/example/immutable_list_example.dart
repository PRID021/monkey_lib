import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';

import '../model/immutable_thread.dart';

Function foo = (int a, int b, int c, {required int d, required int e}) {
  print("{$a} {$b} {$c} {$d} {$e}");
};

const fileNames = [
  'sources/file1.txt',
  'sources/file2.txt',
  'sources/file3.txt',
];

void main(List<String> arguments) {
  // Function.apply(foo, [1, 2, 3], {#d: 4, #e: 5});
  // doSomething();
  // print("after doSomething");

  // ImmutableThread<Message>
  List<Message> stores = [
    Message("Hello"),
    Message("World"),
    Message("!"),
  ];
  ImmutableList messageThread = ImmutableList<Message>(stores);
  List<Message> messages = messageThread.dataStore as List<Message>;
  // print(messages.length);
  // Message firstMessage = messages.first;
  // // firstMessage.message = "Hello World!";

  // print(firstMessage.message);
  Message newMessage = Message("Hello World!");
  // messages.add(newMessage);

  var newMessageThread = messageThread.add(newMessage);
  for (var item in newMessageThread.dataStore) {
    stdout.writeln(item.message + " ");
  }
  print("---------------------- Old Thread ----------------------");
  for (var item in messageThread.dataStore) {
    stdout.writeln(item.message + " ");
  }

  print("---------------------- After newMessageThread remove----------------------");
  for (var item in messageThread.remove(newMessage).dataStore) {
    stdout.writeln(item.message + " ");
  }
}

Future doSomething() async {
  await for (final stringData in _sendAndReceive(fileNames)) {
    print(stringData);
  }
}

Stream<String> _sendAndReceive(List<String> fileNames) async* {
  final p = ReceivePort();
  await Isolate.spawn(_readFile, p.sendPort);
  final events = StreamQueue<dynamic>(p);
  SendPort sendPort = await events.next;
  for (var fileName in fileNames) {
    sendPort.send(fileName);
    final String message = await events.next;
    yield message;
    await Future.delayed(Duration(seconds: 1));
  }
  sendPort.send(null);
  await events.cancel();
}

Future<void> _readFile(SendPort p) async {
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);
  await for (final fileName in commandPort) {
    if (fileName == null) break;
    final file = File(fileName);
    final data = await file.readAsString();
    p.send(data);
  }
  Isolate.exit();
}
