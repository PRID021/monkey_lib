import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ascii.decoder)
      .transform(const LineSplitter())
      .map((line) => '${Zone.current[#filename]}: $line')
      .toList();
}

Future splitLines(filename) {
  return runZoned(() {
    return splitLinesStream( File(filename).openRead());
  }, zoneValues: {#filename: filename});
}

main() {
  Future.forEach(
      ['assets/foo.txt', 'assets/bar.txt'],
      (file) => splitLines(file).then((lines) {
            lines.forEach(print);
          }));
}
