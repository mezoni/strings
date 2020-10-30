import 'package:strings/strings.dart';
import 'package:test/test.dart' hide escape;

void main() {
  test('Strings', () {
    _prepare();
    testCamelize();
    testCapitalize();
    testEscape();
    testIsLowerCase();
    testIsUpperCase();
    testJoin();
    testReverse();
    testStartsWithLowerCase();
    testStartsWithUpperCase();
    testToPrintable();
    testUnderscore();
    testToUnicode();
  });
}

void testCamelize() {
  var subject = 'camelize';
  //
  var length = _underscoreCamelize.length;
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelize[i + 0][1];
    var expected = _underscoreCamelize[i + 0][0];
    var actual = camelize(source);
    expect(actual, expected, reason: subject);
  }
  //
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelizeLower[i + 0][1];
    var expected = _underscoreCamelizeLower[i + 0][0];
    var actual = camelize(source, true);
    expect(actual, expected, reason: subject);
  }
}

void testCapitalize() {
  var subject = 'capitalize';
  //
  var actual = capitalize('dart core');
  expect(actual, 'Dart core', reason: subject);
  //
  actual = capitalize('x');
  expect(actual, 'X', reason: subject);
  //
  actual = capitalize(' x');
  expect(actual, ' x', reason: subject);
}

void testEscape() {
  var subject = 'escape';
  //
  var actual = escape(String.fromCharCode(0));
  expect(actual, r'\u0000', reason: subject);
  actual = escape('\t');
  expect(actual, r'\t', reason: subject);
  actual = escape('\n');
  expect(actual, r'\n', reason: subject);
  actual = escape('\r');
  expect(actual, r'\r', reason: subject);
  actual = escape('\"');
  expect(actual, r'\"', reason: subject);
  actual = escape('\$');
  expect(actual, r'\$', reason: subject);
  actual = escape("\'");
  expect(actual, r"\'", reason: subject);
  actual = escape('\\');
  expect(actual, r'\\', reason: subject);
  actual = escape(String.fromCharCode(31));
  expect(actual, r'\u001f', reason: subject);
  actual = escape('hello');
  expect(actual, r'hello', reason: subject);
  actual = escape('Привет');
  expect(actual, r'Привет', reason: subject);
  actual = escape(String.fromCharCode(0x80));
  expect(actual, r'\u0080', reason: subject);
  actual = escape(String.fromCharCode(0x9f));
  expect(actual, r'\u009f', reason: subject);
  actual = escape(String.fromCharCode(0xa0));
  expect(actual, String.fromCharCode(0xa0), reason: subject);
  actual = escape(String.fromCharCode(0xa1));
  expect(actual, r'¡', reason: subject);
  actual = escape(r'C:\Windows');
  expect(actual, r'C:\\Windows', reason: subject);
  actual = escape(r'\u0001');
  expect(actual, r'\\u0001', reason: subject);
  // invalid characters
  actual = escape(String.fromCharCode(0xb5e));
  expect(actual, r'\u0b5e', reason: subject);
  actual = escape(String.fromCharCode(0x10ffff));
  expect(actual, r'\u10ffff', reason: subject);
  // Emoji
  actual = toPrintable('Keycap: 0 Emoji 0️⃣.');
  expect(actual, r'Keycap: 0 Emoji 0️⃣.', reason: subject);
}

void testIsLowerCase() {
  var subject = 'isLowerCase';
  //
  var actual = isLowerCase('');
  expect(actual, true, reason: subject);
  //
  actual = isLowerCase('lower_case1');
  expect(actual, true, reason: subject);
  //
  actual = isLowerCase('UPPER_CASE2');
  expect(actual, false, reason: subject);
  //
  actual = isLowerCase('Привет');
  expect(actual, false, reason: subject);
  //
  actual = isLowerCase('пока');
  expect(actual, true, reason: subject);
}

void testIsUpperCase() {
  var subject = 'isUpperCase';
  //
  var actual = isUpperCase('');
  expect(actual, true, reason: subject);
  //
  actual = isUpperCase('lower_case1');
  expect(actual, false, reason: subject);
  //
  actual = isUpperCase('UPPER_CASE2');
  expect(actual, true, reason: subject);
  //
  actual = isUpperCase('Привет');
  expect(actual, false, reason: subject);
  //
  actual = isUpperCase('ПОКА');
  expect(actual, true, reason: subject);
}

void testJoin() {
  var subject = 'join';
  //
  var actual = join(null);
  expect(actual, null, reason: subject);
  //
  actual = join([1, 2]);
  expect(actual, '12', reason: subject);
  //
  actual = join([1, 2], ', ');
  expect(actual, '1, 2', reason: subject);
}

void testReverse() {
  var subject = 'reverse';
  //
  var actual = reverse('hello');
  expect(actual, 'olleh', reason: subject);
}

void testStartsWithLowerCase() {
  var subject = 'startsWithLowerCase';
  //
  var actual = startsWithLowerCase('');
  expect(actual, false, reason: subject);
  //
  actual = startsWithLowerCase('a');
  expect(actual, true, reason: subject);
  //
  actual = startsWithLowerCase('A');
  expect(actual, false, reason: subject);
  //
  actual = startsWithLowerCase('Привет');
  expect(actual, false, reason: subject);
  //
  actual = startsWithLowerCase('пока');
  expect(actual, true, reason: subject);
  //
  actual = startsWithLowerCase('1');
  expect(actual, false, reason: subject);
}

void testStartsWithUpperCase() {
  var subject = 'startsWithUpperCase';
  //
  var actual = startsWithUpperCase('');
  expect(actual, false, reason: subject);
  //
  actual = startsWithUpperCase('a');
  expect(actual, false, reason: subject);
  //
  actual = startsWithUpperCase('A');
  expect(actual, true, reason: subject);
  //
  actual = startsWithUpperCase('Привет');
  expect(actual, true, reason: subject);
  //
  actual = startsWithUpperCase('пока');
  expect(actual, false, reason: subject);
  //
  actual = startsWithUpperCase('1');
  expect(actual, false, reason: subject);
}

void testToPrintable() {
  var subject = 'toPrintable';
  //
  var actual = toPrintable(String.fromCharCode(0));
  expect(actual, r'\u0000', reason: subject);
  actual = toPrintable('\t');
  expect(actual, r'\t', reason: subject);
  actual = toPrintable('\n');
  expect(actual, r'\n', reason: subject);
  actual = toPrintable('\r');
  expect(actual, r'\r', reason: subject);
  actual = toPrintable('\"');
  expect(actual, r'"', reason: subject);
  actual = toPrintable('\$');
  expect(actual, r'$', reason: subject);
  actual = toPrintable("\'");
  expect(actual, r"'", reason: subject);
  actual = toPrintable('\\');
  expect(actual, r'\', reason: subject);
  actual = toPrintable(String.fromCharCode(31));
  expect(actual, r'\u001f', reason: subject);
  actual = toPrintable('hello');
  expect(actual, r'hello', reason: subject);
  actual = toPrintable('Привет');
  expect(actual, r'Привет', reason: subject);
  actual = toPrintable(String.fromCharCode(0x80));
  expect(actual, r'\u0080', reason: subject);
  actual = toPrintable(String.fromCharCode(0x9f));
  expect(actual, r'\u009f', reason: subject);
  actual = toPrintable(String.fromCharCode(0xa0));
  expect(actual, String.fromCharCode(0xa0), reason: subject);
  actual = toPrintable(String.fromCharCode(0xa1));
  expect(actual, r'¡', reason: subject);
  actual = toPrintable(r'C:\Windows');
  expect(actual, r'C:\Windows', reason: subject);
  actual = toPrintable(r'\u0001');
  expect(actual, r'\u0001', reason: subject);
  // invalid characters
  actual = escape(String.fromCharCode(0xb5e));
  expect(actual, r'\u0b5e', reason: subject);
  actual = escape(String.fromCharCode(0x10ffff));
  expect(actual, r'\u10ffff', reason: subject);
  // Emoji
  actual = toPrintable('Keycap: 0 Emoji 0️⃣.');
  expect(actual, r'Keycap: 0 Emoji 0️⃣.', reason: subject);
}

void testToUnicode() {
  var subject = 'toUnicode';
  //
  var actual = toUnicode(32);
  expect(actual, '\\u0020', reason: subject);
  //
  actual = toUnicode(127);
  expect(actual, '\\u007f', reason: subject);
}

void testUnderscore() {
  var subject = 'underscore';
  //
  var length = _underscoreCamelize.length;
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelize[i + 0][0];
    var expected = _underscoreCamelize[i + 0][1];
    var actual = underscore(source);
    expect(actual, expected, reason: subject);
  }
}

List<List<String>> _underscoreCamelize = <List<String>>[];
List<List<String>> _underscoreCamelizeLower = <List<String>>[];

void _prepare() {
  _underscoreCamelize.add(['DartVm DartCore', 'dart_vm dart_core']);
  _underscoreCamelizeLower.add(['dartVm dartCore', 'dart_vm dart_core']);
  _underscoreCamelize.add([' Dart VM DartCore X', ' dart v_m dart_core x']);
  _underscoreCamelizeLower
      .add([' dart vM dartCore x', ' dart v_m dart_core x']);
  _underscoreCamelize.add([' Dart VM Dart1Core X', ' dart v_m dart1_core x']);
  _underscoreCamelizeLower
      .add([' dart vM dart1Core x', ' dart v_m dart1_core x']);
  _underscoreCamelize.add([' Dart_Core ', ' dart__core ']);
  _underscoreCamelizeLower.add([' dart_Core ', ' dart__core ']);
  _underscoreCamelize.add([' DartVM ', ' dart_v_m ']);
  _underscoreCamelizeLower.add([' dartVM ', ' dart_v_m ']);
  _underscoreCamelize.add([' _DartVM ', ' _dart_v_m ']);
  _underscoreCamelizeLower.add([' _dartVM ', ' _dart_v_m ']);
  _underscoreCamelize.add(['_DartVM ', '_dart_v_m ']);
  _underscoreCamelizeLower.add(['_dartVM ', '_dart_v_m ']);
}
