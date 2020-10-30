part of strings;

const int _ASCII_END = 0x7f;

const int _ASCII_START = 0x0;

const int _C0_END = 0x1f;

const int _C0_START = 0x00;

const int _UNICODE_END = 0x10ffff;

const int _DIGIT = 0x1;

const int _LOWER = 0x2;

const int _UNDERSCORE = 0x4;

const int _UPPER = 0x8;

const int _ALPHA = _LOWER | _UPPER;

const int _ALPHA_NUM = _ALPHA | _DIGIT;

final List<int> _ascii = <int>[
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  8,
  0,
  0,
  0,
  0,
  4,
  0,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  0,
  0,
  0,
  0,
  0
];

/// Returns a string in the form "UpperCamelCase" or "lowerCamelCase".
///
/// Example:
///      print(camelize("dart_vm"));
///      => DartVm
String camelize(String string, [bool lower = false]) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  string = string.toLowerCase();
  var capitlize = true;
  var position = 0;
  var remove = false;
  var sb = StringBuffer();
  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    var flag = 0;
    if (runes.length == 1) {
      var c = runes.first;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
      }
    }

    if (capitlize && flag & _ALPHA != 0) {
      if (lower && position == 0) {
        sb.write(s);
      } else {
        sb.write(s.toUpperCase());
      }

      capitlize = false;
      remove = true;
      position++;
    } else {
      if (flag & _UNDERSCORE != 0) {
        if (!remove) {
          sb.write(s);
          remove = true;
        }

        capitlize = true;
      } else {
        if (flag & _ALPHA_NUM != 0) {
          capitlize = false;
          remove = true;
        } else {
          capitlize = true;
          remove = false;
          position = 0;
        }

        sb.write(s);
      }
    }
  }

  return sb.toString();
}

/// Returns a string with capitalized first character.
///
/// Example:
///     print(capitalize("dart"));
///     => Dart
String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

/// Returns an escaped string.
///
/// Example:
///     print(escape("Hello 'world' \n"));
///     => Hello \'world\' \n
String escape(String string, [String Function(int charCode) encode]) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  encode ??= toUnicode;
  final sb = StringBuffer();
  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      if (c >= _C0_START && c <= _C0_END) {
        switch (c) {
          case 9:
            sb.write('\\t');
            break;
          case 10:
            sb.write('\\n');
            break;
          case 13:
            sb.write('\\r');
            break;
          default:
            sb.write(encode(c));
        }
      } else if (c >= _ASCII_START && c <= _ASCII_END) {
        switch (c) {
          case 34:
            sb.write('\\\"');
            break;
          case 36:
            sb.write('\\\$');
            break;
          case 39:
            sb.write("\\\'");
            break;
          case 92:
            sb.write('\\\\');
            break;
          default:
            sb.write(s);
        }
      } else if (_isPrintable(c)) {
        sb.write(s);
      } else {
        sb.write(encode(c));
      }
    } else {
      // Experimental: Assuming that all clusters does not need to be escaped
      sb.write(s);
    }
  }

  return sb.toString();
}

/// Returns true if the string does not contain upper case letters; otherwise
/// false;
///
/// Example:
///     print(isLowerCase("camelCase"));
///     => false
///
///     print(isLowerCase("dart"));
///     => true
///
///     print(isLowerCase(""));
///     => false
bool isLowerCase(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return true;
  }

  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    if (runes.length == 1) {
      var c = runes.first;
      var flag = 0;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
      }

      if (c <= _ASCII_END) {
        if (flag & _UPPER != 0) {
          return false;
        }
      } else {
        if (s == s.toUpperCase()) {
          return false;
        }
      }
    }
  }

  return true;
}

/// Returns true if the string does not contain lower case letters; otherwise
/// false;
///
/// Example:
///     print(isUpperCase("CamelCase"));
///     => false
///
///     print(isUpperCase("DART"));
///     => true
///
///     print(isUpperCase(""));
///     => false
bool isUpperCase(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return true;
  }

  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    if (runes.length == 1) {
      var c = runes.first;
      var flag = 0;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
      }

      if (c <= _ASCII_END) {
        if (flag & _LOWER != 0) {
          return false;
        }
      } else {
        if (s == s.toLowerCase()) {
          return false;
        }
      }
    }
  }

  return true;
}

/// Returns the joined elements of the list if the list is not null; otherwise
/// null.
///
/// Example:
///     print(join(null));
///     => null
///
///     print(join([1, 2]));
///     => 12
String join(List list, [String separator = '']) {
  if (list == null) {
    return null;
  }

  return list.join(separator);
}

/// Returns a string with reversed order of characters.
///
/// Example:
///     print(reverse("hello"));
///     => olleh
String reverse(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.length < 2) {
    return string;
  }

  final characters = Characters(string);
  return characters.toList().reversed.join();
}

/// Returns true if the string starts with the lower case character; otherwise
/// false;
///
/// Example:
///     print(startsWithLowerCase("camelCase"));
///     => true
///
///     print(startsWithLowerCase(""));
///     => false
bool startsWithLowerCase(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return false;
  }

  final characters = Characters(string);
  final s = characters.first;
  final runes = s.runes;
  if (runes.length == 1) {
    var c = runes.first;
    var flag = 0;
    if (c <= _ASCII_END) {
      flag = _ascii[c];
    }

    if (c <= _ASCII_END) {
      if (flag & _LOWER != 0) {
        return true;
      }
    } else {
      if (s == s.toLowerCase()) {
        return true;
      }
    }
  }

  return false;
}

/// Returns true if the string starts with the upper case character; otherwise
/// false;
///
/// Example:
///     print(startsWithUpperCase("Dart"));
///     => true
///
///     print(startsWithUpperCase(""));
///     => false
bool startsWithUpperCase(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return false;
  }

  final characters = Characters(string);
  final s = characters.first;
  final runes = s.runes;
  if (runes.length == 1) {
    var c = runes.first;
    var flag = 0;
    if (c <= _ASCII_END) {
      flag = _ascii[c];
    }

    if (c <= _ASCII_END) {
      if (flag & _UPPER != 0) {
        return true;
      }
    } else {
      if (s == s.toUpperCase()) {
        return true;
      }
    }
  }

  return false;
}

/// Returns an unescaped printable string.
///
/// Example:
///     print(toPrintable("Hello 'world' \n"));
///     => Hello 'world' \n
String toPrintable(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  final sb = StringBuffer();
  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      if (c >= _C0_START && c <= _C0_END) {
        switch (c) {
          case 9:
            sb.write('\\t');
            break;
          case 10:
            sb.write('\\n');
            break;
          case 13:
            sb.write('\\r');
            break;
          default:
            sb.write(toUnicode(c));
        }
      } else if (_isPrintable(c)) {
        sb.write(s);
      } else {
        sb.write(toUnicode(c));
      }
    } else {
      // Experimental: Assuming that all clusters can be printed
      sb.write(s);
    }
  }

  return sb.toString();
}

/// Returns an Unicode representation of the character code.
///
/// Example:
///     print(toUnicode(48));
///     => \u0030
String toUnicode(int charCode) {
  if (charCode == null) {
    throw ArgumentError.notNull('charCode');
  }

  if (charCode < 0 || charCode > _UNICODE_END) {
    throw RangeError.range(charCode, 0, _UNICODE_END, 'charCode');
  }

  var hex = charCode.toRadixString(16);
  var length = hex.length;
  if (length < 4) {
    hex = hex.padLeft(4, '0');
  }

  return '\\u$hex';
}

/// Returns an underscored string.
///
/// Example:
///     print(underscore("DartVM DartCore"));
///     => dart_vm dart_core
String underscore(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  var sb = StringBuffer();
  var separate = false;
  final characters = Characters(string);
  for (final s in characters) {
    final runes = s.runes;
    var flag = 0;
    if (runes.length == 1) {
      var c = runes.first;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
      }
    }

    if (separate && flag & _UPPER != 0) {
      sb.write('_');
      sb.write(s.toLowerCase());
      separate = true;
    } else {
      if (flag & _ALPHA_NUM != 0) {
        separate = true;
      } else if (flag & _UNDERSCORE != 0 && separate) {
        separate = true;
      } else {
        separate = false;
      }

      sb.write(s.toLowerCase());
    }
  }

  return sb.toString();
}

// TODO: Optimize via table
// TODO: Improve list of printable characters
bool _isPrintable(int character) {
  switch (unicode.generalCategories[character]) {
    case unicode.CONTROL:
    case unicode.FORMAT:
    case unicode.LINE_SEPARATOR:
    case unicode.NOT_ASSIGNED:
    case unicode.PARAGRAPH_SEPARATOR:
    case unicode.PRIVATE_USE:
    case unicode.SURROGATE:
      return false;
    default:
      return true;
  }
}
