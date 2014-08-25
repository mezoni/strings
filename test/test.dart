import "package:strings/strings.dart";
import "package:unittest/unittest.dart";

void main() {
  _prepare();
  testCamelize();
  testCapitalize();
  testEscape();
  testJoin();
  testPrintable();
  testReverse();
  testUnderscore();
  testUnicode();
}

void testCamelize() {
  var subject = "camelize";
  //
  var length = _underscoreCamelize.length;
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelize[i + 0][1];
    var expected = _underscoreCamelize[i + 0][0];
    var actual = Strings.camelize(source);
    expect(actual, expected, reason: subject);
  }
  //
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelizeLower[i + 0][1];
    var expected = _underscoreCamelizeLower[i + 0][0];
    var actual = Strings.camelize(source, true);
    expect(actual, expected, reason: subject);
  }
}

void testCapitalize() {
  var subject = "capitalize";
  //
  var actual = Strings.capitalize("dart core");
  expect(actual, "Dart core", reason: subject);
  //
  actual = Strings.capitalize("x");
  expect(actual, "X", reason: subject);
  //
  actual = Strings.capitalize(" x");
  expect(actual, " x", reason: subject);
}

void testEscape() {
  var subject = "escape";
  //
  var actual = Strings.escape(new String.fromCharCode(0));
  expect(actual, r"\u0000", reason: subject);
  actual = Strings.escape("\t");
  expect(actual, r"\t", reason: subject);
  actual = Strings.escape("\n");
  expect(actual, r"\n", reason: subject);
  actual = Strings.escape("\r");
  expect(actual, r"\r", reason: subject);
  actual = Strings.escape("\"");
  expect(actual, r'\"', reason: subject);
  actual = Strings.escape("\$");
  expect(actual, r"\$", reason: subject);
  actual = Strings.escape("\'");
  expect(actual, r"\'", reason: subject);
  actual = Strings.escape("\\");
  expect(actual, r"\\", reason: subject);
  actual = Strings.escape(new String.fromCharCode(31));
  expect(actual, r"\u001f", reason: subject);
  actual = Strings.escape("hello");
  expect(actual, r"hello", reason: subject);
  actual = Strings.escape("Привет");
  expect(actual, r"Привет", reason: subject);
  actual = Strings.escape(new String.fromCharCode(0x80));
  expect(actual, r"\u0080", reason: subject);
  actual = Strings.escape(new String.fromCharCode(0x9f));
  expect(actual, r"\u009f", reason: subject);
  actual = Strings.escape(new String.fromCharCode(0xa0));
  expect(actual, new String.fromCharCode(0xa0), reason: subject);
  actual = Strings.escape(new String.fromCharCode(0xa1));
  expect(actual, r"¡", reason: subject);
  actual = Strings.escape(r"C:\Windows");
  expect(actual, r"C:\\Windows", reason: subject);
  actual = Strings.escape(r"\u0001");
  expect(actual, r"\\u0001", reason: subject);
}

void testJoin() {
  var subject = "join";
  //
  var actual = Strings.join(null);
  expect(actual, null, reason: subject);
  //
  actual = Strings.join([1, 2]);
  expect(actual, "12", reason: subject);
  //
  actual = Strings.join([1, 2], ", ");
  expect(actual, "1, 2", reason: subject);
}

void testPrintable() {
  var subject = "printable";
  //
  var actual = Strings.printable(new String.fromCharCode(0));
  expect(actual, r"\u0000", reason: subject);
  actual = Strings.printable("\t");
  expect(actual, r"\t", reason: subject);
  actual = Strings.printable("\n");
  expect(actual, r"\n", reason: subject);
  actual = Strings.printable("\r");
  expect(actual, r"\r", reason: subject);
  actual = Strings.printable("\"");
  expect(actual, r'"', reason: subject);
  actual = Strings.printable("\$");
  expect(actual, r"$", reason: subject);
  actual = Strings.printable("\'");
  expect(actual, r"'", reason: subject);
  actual = Strings.printable("\\");
  expect(actual, r"\", reason: subject);
  actual = Strings.printable(new String.fromCharCode(31));
  expect(actual, r"\u001f", reason: subject);
  actual = Strings.printable("hello");
  expect(actual, r"hello", reason: subject);
  actual = Strings.printable("Привет");
  expect(actual, r"Привет", reason: subject);
  actual = Strings.printable(new String.fromCharCode(0x80));
  expect(actual, r"\u0080", reason: subject);
  actual = Strings.printable(new String.fromCharCode(0x9f));
  expect(actual, r"\u009f", reason: subject);
  actual = Strings.printable(new String.fromCharCode(0xa0));
  expect(actual, new String.fromCharCode(0xa0), reason: subject);
  actual = Strings.printable(new String.fromCharCode(0xa1));
  expect(actual, r"¡", reason: subject);
  actual = Strings.printable(r"C:\Windows");
  expect(actual, r"C:\Windows", reason: subject);
  actual = Strings.printable(r"\u0001");
  expect(actual, r"\u0001", reason: subject);
}

void testReverse() {
  var subject = "reverse";
  //
  var actual = Strings.reverse("hello");
  expect(actual, "olleh", reason: subject);
}

void testUnderscore() {
  var subject = "underscore";
  //
  var length = _underscoreCamelize.length;
  for (var i = 0; i < length; i += 2) {
    var source = _underscoreCamelize[i + 0][0];
    var expected = _underscoreCamelize[i + 0][1];
    var actual = Strings.underscore(source);
    expect(actual, expected, reason: subject);
  }
}

void testUnicode() {
  var subject = "unicode";
  //
  var actual = Strings.unicode(32);
  expect(actual, "\\u0020", reason: subject);
  //
  actual = Strings.unicode(127);
  expect(actual, "\\u007f", reason: subject);
}

List<List<String>> _underscoreCamelize = <List<String>>[];
List<List<String>> _underscoreCamelizeLower = <List<String>>[];

void _prepare() {
  _underscoreCamelize.add(["DartVm DartCore", "dart_vm dart_core"]);
  _underscoreCamelizeLower.add(["dartVm dartCore", "dart_vm dart_core"]);
  _underscoreCamelize.add([" Dart VM DartCore X", " dart v_m dart_core x"]);
  _underscoreCamelizeLower.add([" dart vM dartCore x", " dart v_m dart_core x"]
      );
  _underscoreCamelize.add([" Dart VM Dart1Core X", " dart v_m dart1_core x"]);
  _underscoreCamelizeLower.add([" dart vM dart1Core x",
      " dart v_m dart1_core x"]);
  _underscoreCamelize.add([" Dart_Core ", " dart__core "]);
  _underscoreCamelizeLower.add([" dart_Core ", " dart__core "]);
  _underscoreCamelize.add([" DartVM ", " dart_v_m "]);
  _underscoreCamelizeLower.add([" dartVM ", " dart_v_m "]);
  _underscoreCamelize.add([" _DartVM ", " _dart_v_m "]);
  _underscoreCamelizeLower.add([" _dartVM ", " _dart_v_m "]);
  _underscoreCamelize.add(["_DartVM ", "_dart_v_m "]);
  _underscoreCamelizeLower.add(["_dartVM ", "_dart_v_m "]);
}
