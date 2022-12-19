import 'package:ansicolor/ansicolor.dart';
import 'dart:convert';

final prefixRightHandPointing = String.fromCharCode(0x1F449);
final thunder = String.fromCharCode(0x26A1);
final warningSign = String.fromCharCode(0x1F44A);
final infoSign = String.fromCharCode(0x1F449);
const infoPrefix = "__[INFO]__: ";
const warnPrefix = "__[WARNING]__: ";
const errorPrefix = "__[ERROR]__: ";
const favorCharacter = " ¯(ツ)/¯ ";

class Logger {
  static final JsonDecoder _decoder = JsonDecoder();
  static final JsonEncoder _encoder = JsonEncoder.withIndent('  ');
  static final AnsiPen _greenPen = AnsiPen()..rgb(r: 0, g: 255, b: 0);
  static final AnsiPen _redPen = AnsiPen()..rgb(r: 255, g: 0, b: 0);
  static final AnsiPen _yellowPen = AnsiPen()..rgb(r: 255, g: 255, b: 0);

  static i(String input) {
    try {
      ansiColorDisabled = false;
      var object = _decoder.convert(input);
      var prettyString = _encoder.convert(object);
      prettyString.split('\n').forEach(
            (element) => print(
              _greenPen(infoPrefix) + favorCharacter + "  " + (element),
            ),
          );
    } on Exception {
      print(
        _greenPen(infoPrefix) + favorCharacter + "  " + (input),
      );
    }
  }

  static w(String input) {
    try {
      ansiColorDisabled = false;
      var object = _decoder.convert(input);
      var prettyString = _encoder.convert(object);
      prettyString.split('\n').forEach(
            (element) => print(
              _yellowPen(warnPrefix) + warningSign + "  " + (element),
            ),
          );
    } on Exception {
      print(
        _yellowPen(warnPrefix) + warningSign + "  " + (input),
      );
    }
  }

  static e(dynamic exception, dynamic stackTrace) {
    ansiColorDisabled = false;
    print(_redPen(errorPrefix) + thunder + "  " + _redPen(exception.toString()) + "\n" + "$stackTrace");
  }
}
