import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ez_health/auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/assets/constants/constants.dart';

// TODO: Add a splash screen that shows the app logo before the onboarding screen
// TODO: Fix the back arrow alignment
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper'),
              OnBoardingPage(
                  svgImage:
                      'lib/assets/images/onboarding-assets/Medical Team.svg',
                  imageLabel: 'Image 2',
                  displayText1: 'Learn About\t',
                  textColor1: customBlue,
                  displayText2: 'Your\nDoctors',
                  textColor2: Colors.black,
                  descriptionText:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper'),
              OnBoardingPage(
                svgImage:
                    'lib/assets/images/onboarding-assets/Calendar Guy.svg',
                imageLabel: 'Image 3',
                displayText1: 'Effortless\t',
                textColor1: Colors.black,
                displayText2: 'Appointment\nBooking',
                textColor2: customBlue,
                descriptionText:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper',
              ),
            ],
          ),
          DotIndicator(controller: _controller),
        ],
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: SvgImage(
            svgImage: svgImage,
            imageLabel: imageLabel,
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
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: displayText1,
            style: TextStyle(
              color: textColor1,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: displayText2,
            style: TextStyle(
              fontSize: 26,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        descriptionText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
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
        builder: (context) => const HomeScreen(),
        // builder: (context) => const AuthScreen(),
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

  const CustomNavigationButton({
    super.key,
    required this.icon,
    required this.isFilled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: isFilled ? customBlue : Colors.white,
        side: const BorderSide(
          color: customBlue,
          width: 2,
        ),
        elevation: isFilled ? 2 : 0,
      ),
      child: Center(
        child: Icon(
          icon,
          color: isFilled ? Colors.white : customBlue,
          size: 24,
        ),
      ),
    );
  }
}
