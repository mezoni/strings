part of strings;

class Strings {
  static const int _ASCII_END = 0x7f;

  static const int _ASCII_START = 0x0;

  static const int _C0_END = 0x1f;

  static const int _C0_START = 0x00;

  static const int _C1_END = 0x9f;

  static const int _C1_START = 0x80;

  static const int _CONTROL_PICTURES_END = 0x243f;

  static const int _CONTROL_PICTURES_START = 0x2400;

  static const int _UNICODE_END = 0x10ffff;

  static const int _DIGIT = 0x1;

  static const int _LOWER = 0x2;

  static const int _UNDERSCORE = 0x4;

  static const int _UPPER = 0x8;

  static const int _ALPHA = _LOWER | _UPPER;

  static const int _ALPHA_NUM = _ALPHA | _DIGIT;

  static const int _VALID = _ALPHA_NUM | _UNDERSCORE;

  static final _ascii = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8,
      8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 4, 0, 2,
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0,
      0, 0, 0];

  /**
   * Returns a string in the form "UpperCamelCase" or "lowerCamelCase".
   *
   * Example:
   *      print(Strings.camelize("dart_vm"));
   *      => DartVm
   */
  static String camelize(String string, [bool lower = false]) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length == 0) {
      return string;
    }

    string = string.toLowerCase();
    var capitlize = true;
    var length = string.length;
    var position = 0;
    var remove = false;
    var sb = new StringBuffer();
    for (var i = 0; i < length; i++) {
      var s = string[i];
      var c = s.codeUnitAt(0);
      var flag = 0;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
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

  /**
   * Returns a string with capitalized first character.
   *
   * Example:
   *     print(Strings.capitalize("dart"));
   *     => Dart
   */
  static String capitalize(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length == 0) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  /**
   * Returns an escaped string.
   *
   * Example:
   *     print(Strings.escape("Hello 'world' \n"));
   *     => Hello \'world\' \n
   */
  static String escape(String string, [String encode(int charCode)]) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length == 0) {
      return string;
    }

    if (encode == null) {
      encode = unicode;
    }

    var length = string.length;
    var sb = new StringBuffer();
    for (var i = 0; i < length; i++) {
      var c = string.codeUnitAt(i);
      if (c >= _C0_START && c <= _C0_END) {
        switch (c) {
          case 9:
            sb.write("\\t");
            break;
          case 10:
            sb.write("\\n");
            break;
          case 13:
            sb.write("\\r");
            break;
          default:
            sb.write(encode(c));
        }

      } else if (c >= _ASCII_START && c <= _ASCII_END) {
        switch (c) {
          case 34:
            sb.write("\\\"");
            break;
          case 36:
            sb.write("\\\$");
            break;
          case 39:
            sb.write("\\\'");
            break;
          case 92:
            sb.write("\\\\");
            break;
          default:
            sb.write(string[i]);
        }

      } else if (c >= _C1_START && c <= _C1_END) {
        sb.write(encode(c));
      } else if (c >= _CONTROL_PICTURES_START && c <= _CONTROL_PICTURES_END) {
        sb.write(encode(c));
      } else {
        sb.write(string[i]);
      }
    }

    return sb.toString();
  }

  /**
   * Returns the joined elements of the list if the list is not null; otherwise
   * null.
   *
   * Example:
   *     print(Strings.join(null));
   *     => null
   *
   *     print(Strings.join([1, 2]));
   *     => 12
   */
  static String join(List list, [String separator = ""]) {
    if (list == null) {
      return null;
    }

    return list.join(separator);
  }

  /**
   * Returns a string with reversed order of characters.
   *
   * Example:
   *     print(Strings.reverse("hello"));
   *     => olleh
   */
  static String reverse(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length < 2) {
      return string;
    }

    return new String.fromCharCodes(string.codeUnits.reversed);
  }

  /**
   * Returns an unescaped printable string.
   *
   * Example:
   *     print(Strings.printable("Hello 'world' \n"));
   *     => Hello 'world' \n
   */
  static String printable(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length == 0) {
      return string;
    }

    var length = string.length;
    var sb = new StringBuffer();
    for (var i = 0; i < length; i++) {
      var c = string.codeUnitAt(i);
      if (c >= _C0_START && c <= _C0_END) {
        switch (c) {
          case 9:
            sb.write("\\t");
            break;
          case 10:
            sb.write("\\n");
            break;
          case 13:
            sb.write("\\r");
            break;
          default:
            sb.write(unicode(c));
        }

      } else if (c >= _C1_START && c <= _C1_END) {
        sb.write(unicode(c));
      } else if (c >= _CONTROL_PICTURES_START && c <= _CONTROL_PICTURES_END) {
        sb.write(unicode(c));
      } else {
        sb.write(string[i]);
      }
    }

    return sb.toString();
  }

  /**
   * Returns an underscored string.
   *
   * Example:
   *     print(Strings.underscore("DartVM DartCore"));
   *     => dart_vm dart_core
   */
  static String underscore(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }

    if (string.length == 0) {
      return string;
    }

    var length = string.length;
    var sb = new StringBuffer();
    var separate = false;
    for (var i = 0; i < length; i++) {
      var s = string[i];
      var c = s.codeUnitAt(0);
      var flag = 0;
      if (c <= _ASCII_END) {
        flag = _ascii[c];
      }

      if (separate && flag & _UPPER != 0) {
        sb.write("_");
        sb.write(s);
        separate = true;
      } else {
        if (flag & _ALPHA_NUM != 0) {
          separate = true;
        } else if (flag & _UNDERSCORE != 0 && separate) {
          separate = true;
        } else {
          separate = false;
        }

        sb.write(s);
      }
    }

    return sb.toString().toLowerCase();
  }

  /**
   * Returns an Unicode representation of the character code.
   *
   * Example:
   *     print(Strings.unicode(48));
   *     => \u0030
   */
  static String unicode(int charCode) {
    if (charCode == null || charCode < 0 || charCode > _UNICODE_END) {
      throw new ArgumentError('charCode: $charCode');
    }

    var hex = charCode.toRadixString(16);
    var length = hex.length;
    if (length < 4) {
      hex = hex.padLeft(4, "0");
    }

    return '\\u$hex';
  }

}
