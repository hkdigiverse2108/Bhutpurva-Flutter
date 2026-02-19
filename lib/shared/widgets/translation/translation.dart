import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/app_constants.dart';
import 'package:translator/translator.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final translator = GoogleTranslator();

  TranslatedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Translation>(
      future: translator.translate(text, to: lg),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 16, width: 16, child: Text('...'));
        }

        if (snapshot.hasError) {
          return Text(text); // fallback to original text
        }

        if (!snapshot.hasData) {
          return Text(text);
        }

        return Text(snapshot.data!.text);
      },
    );
  }
}
