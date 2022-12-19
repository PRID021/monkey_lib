import 'dart:async';

import '../utils/cancel_able_operation.dart';

Future<void> main(List<String> arguments) async {
  var myCancelOperationZone = CancelableFutureZone(
      fAsync: delay5StringWithNameAndPos,
      onCancel: myOnCancel,
      params: ["Welcome"],
      nameArgs: {#name: "Hoang"});

  myCancelOperationZone.onCancel?.call();
  await myCancelOperationZone.wait();
}

Future delay5String() async {
  await Future.delayed(Duration(seconds: 5));
  print("Future have been complete.");
  return "Future have been complete.";
}

Future delay5StringWithParams(String str) async {
  await Future.delayed(Duration(seconds: 5));
  print(str);
  return str;
}

Future delay5StringWithName({required String str}) async {
  await Future.delayed(
    Duration(seconds: 5),
  );
  print(str);
  return str;
}

Future delay5StringWithNameAndPos(String welcome,
    {required String name}) async {
  await Future.delayed(Duration(seconds: 5));
  print(welcome + " " + name);
  return welcome + " " + name;
}

FutureOr myOnCancel() {
  print("Future have been canceled.");
  return "Future have been canceled.";
}
