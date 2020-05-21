import 'package:connect/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          var screenHeight = MediaQuery.of(context).size.height;
          return Onboarding(
            screenHeight: screenHeight,
          );
        },
      ),
    );
  }
}

