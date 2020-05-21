import 'package:connect/constants.dart';
import 'package:connect/screens/onboarding/widget/icon_container.dart';
import 'package:flutter/material.dart';

class CommunityLightCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconContainer(
          icon: Icons.language,
          padding: kPaddingS,
        ),
        IconContainer(
          icon: Icons.lightbulb_outline,
          padding: kPaddingM,
        ),
        IconContainer(
          icon: Icons.library_books,
          padding: kPaddingS,
        ),
      ],
    );
  }
}