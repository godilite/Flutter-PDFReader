import 'package:connect/screens/onboarding/widget/text_column.dart';
import 'package:flutter/material.dart';

class EducationTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Scan Documents',
      text: 'Converts your scanned images to PDF.',
    );
  }
}