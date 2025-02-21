@Timeout(Duration(seconds: 600))
import 'package:dcli/dcli.dart' hide equals;
import 'package:dcli/src/script/dart_sdk.dart';
import 'package:dcli/src/util/progress.dart';
import 'package:path/path.dart' hide equals;
import 'package:test/test.dart';

import '../util/test_file_system.dart';

void main() {
  test('Detect Dart SDK', () {
    print('Dart pathToDartExe: ${DartSdk().pathToDartExe}');
    print('Dart pathToDartToNativeExe: ${DartSdk().pathToDartToNativeExe}');
    print('Dart pathToPubExe: ${DartSdk().pathToPubExe}');
    print('Dart Version: ${DartSdk().version}');
    print('Dart Major: ${DartSdk().versionMajor}');
    print('Dart Minor: ${DartSdk().versionMinor}');

    which('dart').paths.forEach((line) => print('which: $line'));
  }, skip: false);

  test('Install Dart Sdk', () {
    TestFileSystem().withinZone((fs) {
      final defaultPath = join(fs.uniquePath, 'dart-sdk');
      final installPath = DartSdk().installFromArchive(defaultPath);
      setPathToDartSdk(installPath);
      print('installed To $installPath');
      expect(
          DartSdk().pathToDartExe != null && exists(DartSdk().pathToDartExe!),
          equals(true));
    });
  }, skip: true);

  test('Parse sdk version', () {
    final output = '${DartSdk().pathToDartExe} --version'.firstLine;

    expect(output, contains('Dart'));

    final version = DartSdk().version;

    expect(output, contains(version));

    expect(version, isNot(equals(null)));
  });

  test('Run dart pub', () {
    final progress = DartSdk()
        .runPub(args: ['publish', '--help'], progress: Progress.capture());
    final line = progress.lines;
    expect(line.isNotEmpty, equals(true));
    expect(line[0], equals('Publish the current package to pub.dartlang.org.'));
  });

  test('Run dart pub', () {
    final progress = DartSdk()
        .runPub(args: ['publish', '--help'], progress: Progress.devNull());
    print(progress.runtimeType);
    // final line = progress.lines;
    // expect(line.isNotEmpty, equals(true));
    // expect(line[0]
    // , equals('Publish the current package to pub.dartlang.org.'));
  });

  test('Run dart script', () {
    final projectRoot = DartProject.fromPath('.').pathToProjectRoot;
    final hellow = join(projectRoot, 'test', 'test_script', 'general', 'bin',
        'hello_world.dart');
    DartSdk().run(args: [hellow]);
    print('done 1');
  });
}
