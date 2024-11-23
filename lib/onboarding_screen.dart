import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ez_health/auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/assets/constants/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalPadding = screenSize.height * 0.05;

    return Scaffold(
      body: SafeArea(
        // Add SafeArea
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              children: const [
                OnBoardingPage(
                    svgImage:
                        'lib/assets/images/onboarding-assets/Doctor Checkup.svg',
                    imageLabel: 'Image 1',
                    displayText1: 'Discover\t',
                    textColor1: Colors.black,
                    displayText2: 'Experienced\nDoctors',
                    textColor2: customBlue,
                    descriptionText:
                        'Find and connect with qualified healthcare professionals, dedicated to providing you with the best medical care.'),
                OnBoardingPage(
                    svgImage:
                        'lib/assets/images/onboarding-assets/Medical Team.svg',
                    imageLabel: 'Image 2',
                    displayText1: 'Learn About\t',
                    textColor1: customBlue,
                    displayText2: 'Your\nDoctors',
                    textColor2: Colors.black,
                    descriptionText:
                        'Make informed decisions about your healthcare and access detailed profiles of our medical staff.'),
                OnBoardingPage(
                  svgImage:
                      'lib/assets/images/onboarding-assets/Calendar Guy.svg',
                  imageLabel: 'Image 3',
                  displayText1: 'Effortless\t',
                  textColor1: Colors.black,
                  displayText2: 'Appointment\nBooking',
                  textColor2: customBlue,
                  descriptionText:
                      'Book and manage your medical appointments with ease. Get real-time updates to stay on top of your schedule.',
                ),
              ],
            ),
            Positioned(
              bottom: verticalPadding, // Dynamic bottom padding
              left: 0,
              right: 0,
              child: DotIndicator(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.svgImage,
    required this.imageLabel,
    required this.displayText1,
    required this.textColor1,
    required this.displayText2,
    required this.textColor2,
    required this.descriptionText,
  });

  final String displayText1,
      displayText2,
      svgImage,
      imageLabel,
      descriptionText;
  final Color textColor1, textColor2;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.8,
                  maxHeight: screenSize.height * 0.4,
                ),
                child: SvgImage(
                  svgImage: svgImage,
                  imageLabel: imageLabel,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Heading(
                  displayText1: displayText1,
                  textColor1: textColor1,
                  displayText2: displayText2,
                  textColor2: textColor2,
                ),
                const SizedBox(height: 20),
                SubHeading(descriptionText: descriptionText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.displayText1,
    required this.textColor1,
    required this.displayText2,
    required this.textColor2,
  });

  final String displayText1;
  final Color textColor1;
  final String displayText2;
  final Color textColor2;

  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.06;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: displayText1,
            style: TextStyle(
              color: textColor1,
              fontSize: fontSize, // Dynamic font size
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: displayText2,
            style: TextStyle(
              fontSize: fontSize, // Dynamic font size
              color: textColor2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SubHeading extends StatelessWidget {
  const SubHeading({
    super.key,
    required this.descriptionText,
  });

  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Text(
        descriptionText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize, // Dynamic font size
        ),
      ),
    );
  }
}

class SvgImage extends StatelessWidget {
  const SvgImage({
    super.key,
    required this.svgImage,
    required this.imageLabel,
  });

  final String svgImage;
  final String imageLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgImage,
      semanticsLabel: imageLabel,
    );
  }
}

class DotIndicator extends StatefulWidget {
  const DotIndicator({
    super.key,
    required PageController controller,
  }) : _controller = controller;

  final PageController _controller;

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() {
      setState(() {
        _currentPage = widget._controller.page?.round() ?? 0;
      });
    });
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_currentPage != 0)
            CustomNavigationButton(
              icon: Icons.arrow_back_ios,
              isFilled: false,
              padding: const EdgeInsets.only(
                  left: 5), // Adjust this value between 4-6
              onPressed: () {
                widget._controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            )
          else
            const SizedBox(width: 48),
          SmoothPageIndicator(
            controller: widget._controller,
            count: 3,
            effect: const SlideEffect(
              activeDotColor: customBlue,
            ),
          ),
          CustomNavigationButton(
            icon: _currentPage == 2 ? Icons.check : Icons.arrow_forward_ios,
            isFilled: true,
            onPressed: _currentPage == 2
                ? _navigateToLoginPage
                : () {
                    widget._controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
          ),
        ],
      ),
    );
  }
}

class CustomNavigationButton extends StatelessWidget {
  final IconData icon;
  final bool isFilled;
  final VoidCallback? onPressed;
  final EdgeInsets? padding; // Add this parameter

  const CustomNavigationButton({
    super.key,
    required this.icon,
    required this.isFilled,
    required this.onPressed,
    this.padding, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = MediaQuery.of(context).size.width * 0.12;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(buttonSize * 0.25),
          backgroundColor: isFilled ? customBlue : Colors.white,
          side: const BorderSide(
            color: customBlue,
            width: 2,
          ),
          elevation: isFilled ? 2 : 0,
        ),
        child: Center(
          child: Padding(
            padding:
                padding ?? EdgeInsets.zero, // Apply the padding if provided
            child: Icon(
              icon,
              color: isFilled ? Colors.white : customBlue,
              size: buttonSize * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
