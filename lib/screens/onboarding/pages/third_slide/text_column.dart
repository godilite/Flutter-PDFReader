import 'package:connect/screens/onboarding/widget/text_column.dart';
import 'package:flutter/material.dart';

class WorkTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Fast Printing',
      text:
          'Send PDFs from your phone to the printer.',
    );
  }
}
