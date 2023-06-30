import 'dart:core';
bool isAsync(Function func) {
  if (func is Future Function()) return true;
  if (func is Future Function(Never)) return true;
  if (func is Future Function(Never, Never)) return true;
  if (func is Future Function(Never, Never, Never)) return true;
  if (func is Future Function(Never, Never, Never,Never)) return true;
  if (func is Future Function(Never, Never, Never,Never,Never)) return true;
  // Repeat as long as you want to.
  return false;
}