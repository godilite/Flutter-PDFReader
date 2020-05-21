import 'package:connect/constants.dart';
import 'package:flutter/material.dart';

class WorkDarkCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.print,
              color: kWhite,
              size: 32.0,
            ),
          ],
        ),
        const SizedBox(height: kSpaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.send,
              color: kWhite,
              size: 32.0,
            ),
            Icon(
              Icons.settings_input_antenna,
              color: kWhite,
              size: 32.0,
            ),
            Icon(
              Icons.wallpaper,
              color: kWhite,
              size: 32.0,
            ),
          ],
        ),
      ],
    );
  }
}
