import 'dart:math';
import 'package:connect/constants.dart';
import 'package:connect/screens/homepage.dart';
import 'package:connect/screens/login/login.dart';
import 'package:connect/screens/onboarding/pages/first_slide/dark_card_content.dart';
import 'package:connect/screens/onboarding/pages/first_slide/light_card_content.dart';
import 'package:connect/screens/onboarding/pages/first_slide/text_column.dart';
import 'package:connect/screens/onboarding/pages/page.dart';
import 'package:connect/screens/onboarding/pages/second_slide/dark_card_content.dart';
import 'package:connect/screens/onboarding/pages/second_slide/light_card_content.dart';
import 'package:connect/screens/onboarding/pages/second_slide/text_column.dart';
import 'package:connect/screens/onboarding/pages/third_slide/dark_card_content.dart';
import 'package:connect/screens/onboarding/pages/third_slide/light_card_content.dart';
import 'package:connect/screens/onboarding/pages/third_slide/text_column.dart';
import 'package:connect/screens/onboarding/widget/header.dart';
import 'package:connect/screens/onboarding/widget/next_button.dart';
import 'package:connect/screens/onboarding/widget/onboarding_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/onboarding/widget/ripple.dart';
class Onboarding extends StatefulWidget {
 final double screenHeight;
 const Onboarding({
    @required this.screenHeight,
  }) : assert(screenHeight != null);
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  AnimationController _cardsAnimationController;
  AnimationController _pageIndicatorAnimationController;
    AnimationController _rippleAnimationController;
  Animation<Offset> _slideAnimationLightCard;
  Animation<Offset> _slideAnimationDarkCard;
  Animation<double> _pageIndicatorAnimation;
  int _currentPage = 1;
  Animation<double> _rippleAnimation;
  bool get isFirstPage => _currentPage == 1;

@override
  void initState() {
    super.initState();
    _cardsAnimationController = AnimationController(
      vsync: this,
      duration: kCardAnimationDuration,
    );
     _pageIndicatorAnimationController = AnimationController(
      vsync: this,
      duration: kButtonAnimationDuration,
    );

     _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.screenHeight,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.easeIn,
    )); 

    _setPageIndicatorAnimation();
    _setCardsSlideOutAnimation();

  }

  @override
  void dispose() {
    _cardsAnimationController.dispose();
    _pageIndicatorAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }
  void _setPageIndicatorAnimation({bool isClockwiseAnimation = true}) {
    var multiplicator = isClockwiseAnimation ? 2 : -2;

    setState(() {
      _pageIndicatorAnimation = Tween(
        begin: 0.0,
        end: multiplicator * pi,
      ).animate(
        CurvedAnimation(
          parent: _pageIndicatorAnimationController,
          curve: Curves.easeIn,
        ),
      );
      _pageIndicatorAnimationController.reset();
    });
  }
  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return OnboardingPage(
          number: 1,
          lightCardChild: CommunityLightCardContent(),
          darkCardChild: CommunityDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: CommunityTextColumn(),
        );
      case 2:
        return OnboardingPage(
          number: 2,
          lightCardChild: EducationLightCardContent(),
          darkCardChild: EducationDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: EducationTextColumn(),
        );
      case 3:
        return OnboardingPage(
          number: 3,
          lightCardChild: WorkLightCardContent(),
          darkCardChild: WorkDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: WorkTextColumn(),
        );
      default:
        throw Exception("Page with number '$_currentPage' does not exist.");
    }
  }

  void _setCardsSlideInAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset(3.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset(1.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setCardsSlideOutAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-3.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setNextPage(int nextPageNumber) {
    setState(() {
      _currentPage = nextPageNumber;
    });
  }

  Future<void> _nextPage() async {
    switch (_currentPage) {
      case 1:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(2);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
          _setCardsSlideOutAnimation();
          _setPageIndicatorAnimation(isClockwiseAnimation: false);
        }
        break;
      case 2:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(3);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
        }
        break;
      case 3:
        if (_pageIndicatorAnimation.status == AnimationStatus.completed) {
         await _goToLogin();
        }
        break;
    }
  }

  Future<void> _goToLogin() async {
    await _rippleAnimationController.forward();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomePage(
         // screenHeight: widget.screenHeight,
        ),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingL),
              child: Column(
                children: <Widget>[
                  Header(
                    onSkip: () async => await _goToLogin(),
                  ),
                  Expanded(
                    child: _getPage(),
                  ),
                  AnimatedBuilder(
                    animation: _pageIndicatorAnimation,
                    child: NextPageButton(
                      onPressed: () async => await _nextPage(),
                    ),
                    builder: (_, Widget child) {
                      return OnboardingPageIndicator(
                        angle: _pageIndicatorAnimation.value,
                        currentPage: _currentPage,
                        child: child,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (_, Widget child) {
              return Ripple(
                radius: _rippleAnimation.value,
              );
            },
          ),
        ],
      ),
    );
  }
}