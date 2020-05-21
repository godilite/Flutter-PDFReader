import 'package:connect/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityDarkCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: kPaddingL),
          child: Icon(
            CupertinoIcons.pen,
            color: kWhite,
            size: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: kPaddingL),
          child: Icon(
            CupertinoIcons.book,
            color: kWhite,
            size: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: kPaddingL),
          child: Icon(
            Icons.share,
            color: kWhite,
            size: 32.0,
          ),
        ),
      ],
    );
  }
}