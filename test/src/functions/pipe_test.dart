@t.Timeout(Duration(seconds: 600))
import 'package:test/test.dart' as t;
import 'package:dcli/dcli.dart';

import '../util/test_file_system.dart';
import '../util/test_utils.dart';

void main() {
  t.group('Piping with ForEach ', () {
    final lines = <String?>[];

    TestFileSystem().withinZone((fs) {
      t.test('For Each on string', () {
        final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
        createLineFile(linesFile, 10);

        'tail -n 100 $linesFile'.forEach(lines.add);
        t.expect(lines.length, t.equals(10));
      });

      t.test('forEach Single Pipe', () {
        final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
        createLineFile(linesFile, 10);

        lines.clear();
        ('tail -n 100 $linesFile' | 'head -n 5').forEach(lines.add);

        t.expect(lines.length, t.equals(5));
      });

      t.test('forEach Double Pipe', () {
        final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
        createLineFile(linesFile, 10);

        lines.clear();
        ('tail $linesFile' | 'head -n 5' | 'tail -n 2').forEach(lines.add);
        t.expect(lines.length, t.equals(2));
      });

      t.test('forEach Triple Pipe', () {
        final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
        createLineFile(linesFile, 10);

        lines.clear();
        ('tail $linesFile' | 'head -n 5' | 'head -n 3' | 'tail -n 2')
            .forEach(lines.add);
        t.expect(lines.length, t.equals(2));
      });
    });

    t.group('Piping with run ', () {
      final lines = <String>[];
      TestFileSystem().withinZone((fs) {
        t.test('run on string', () {
          final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
          createLineFile(linesFile, 10);

          'tail -n 100 $linesFile'.run;
          //t.expect(lines.length, t.equals(10));
        });

        t.test('run Single Pipe', () {
          final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
          createLineFile(linesFile, 10);

          lines.clear();
          ('tail -n 100 $linesFile' | 'head -n 5').run;

          //t.expect(lines.length, t.equals(5));
        });

        t.test('run Double Pipe', () {
          final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
          createLineFile(linesFile, 10);

          lines.clear();
          ('tail $linesFile' | 'head -n 5' | 'tail -n 2').run;
          //t.expect(lines.length, t.equals(2));
        });

        t.test('run Triple Pipe', () {
          final linesFile = join(fs.fsRoot, TestFileSystem.testLinesFile);
          createLineFile(linesFile, 10);

          lines.clear();
          ('tail $linesFile' | 'head -n 5' | 'head -n 3' | 'tail -n 2').run;
          //t.expect(lines.length, t.equals(2));
        });
      });
    });
  });
}
