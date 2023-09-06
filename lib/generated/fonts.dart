import 'package:flutter/material.dart';

class Fonts {
  Fonts._();

  static const String familyPeyda = "Peyda";
  static const String familyRoboto = "Roboto";
  static const String familyRobotoMono = "RobotoMono";
  static const String familyColorEmoji = "NotoColorEmoji";

  static TextStyle? getTextStyle(
    TextDirection direction,
    TextStyle? textStyle, {
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    if (direction == TextDirection.ltr) {
      return textStyle?.copyWith(
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFamily: familyRoboto,
        fontFamilyFallback: <String>[
          familyColorEmoji,
          familyPeyda,
          familyRobotoMono
        ],
      );
    } else {
      return textStyle?.copyWith(
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFamily: familyPeyda,
        fontFamilyFallback: <String>[
          familyColorEmoji,
          familyRoboto,
          familyRobotoMono
        ],
      );
    }
  }

  static TextStyle? getCodeStyle(
    TextStyle? textStyle, {
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return textStyle?.copyWith(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: familyRobotoMono,
      fontFamilyFallback: <String>[familyColorEmoji, familyPeyda, familyRoboto],
    );
  }

  static TextStyle? getEmojiStyle(
    TextStyle? textStyle, {
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return textStyle?.copyWith(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: familyColorEmoji,
      fontFamilyFallback: <String>[familyPeyda, familyRoboto, familyRobotoMono],
    );
  }
}
