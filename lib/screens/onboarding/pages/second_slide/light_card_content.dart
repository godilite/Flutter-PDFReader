import 'package:connect/constants.dart';
import 'package:connect/screens/onboarding/widget/icon_container.dart';
import 'package:flutter/material.dart';

class EducationLightCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconContainer(
          icon: Icons.brush,
          padding: kPaddingS,
        ),
        IconContainer(
          icon: Icons.camera_alt,
          padding: kPaddingM,
        ),
        IconContainer(
          icon: Icons.print,
          padding: kPaddingS,
        ),
      ],
    );
  }
}