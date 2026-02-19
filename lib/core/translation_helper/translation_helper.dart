import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslationHelper {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Widget mixedText(
    String englishText, {
    TextStyle? style,
    TextAlign? textAlign,
    String to = 'gu',
  }) {
    return FutureBuilder<Translation>(
      future: _translator.translate(englishText, to: to),
      builder: (context, snapshot) {
        // While loading OR error → show English only
        if (!snapshot.hasData) {
          return Text(englishText, style: style, textAlign: textAlign);
        }

        return Text(
          '$englishText (${snapshot.data!.text})',
          style: style,
          textAlign: textAlign,
        );
      },
    );
  }
}
