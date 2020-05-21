import 'package:connect/constants.dart';
import 'package:connect/screens/homepage.dart';
import 'package:connect/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp( MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open PDF',
      theme: ThemeData(
        accentColor: kBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
           return LunchScreen();
        },
      ),
    );
  }
}

class LunchScreen extends StatefulWidget {
  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _firstLunch = false;

  Future<void> _checkLunch() async {
    final SharedPreferences prefs = await _prefs;
    final bool firstLunch = prefs.getBool('first') ?? true;
    if (firstLunch) {
      prefs.setBool("first", false);    
    }

    setState(() {
      _firstLunch = firstLunch;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLunch();
  }

  @override
  Widget build(BuildContext context) {
   var screenHeight = MediaQuery.of(context).size.height;
    return _firstLunch ? Onboarding(
            screenHeight: screenHeight,
   ): HomePage();
  }
}