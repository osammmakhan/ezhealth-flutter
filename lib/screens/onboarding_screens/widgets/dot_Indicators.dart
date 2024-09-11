import 'package:ez_health/screens/admin_screens/admin_screen.dart';
import 'package:ez_health/screens/admin_screens/sign_in.dart';
import 'package:ez_health/screens/doctor_screens/main_screen.dart';
import 'package:ez_health/screens/login_screens/sign_in_screen.dart';
import 'package:ez_health/screens/patient/doctor_appointment.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/custom_navigation_button/customNavigationButton.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ez_health/assets/constants/constants.dart';

class DotIndicator extends StatefulWidget {
  const DotIndicator({
    super.key,
    required PageController controller,
  }) : _controller = controller;

  final PageController _controller;

  @override
  _DotIndicatorState createState() => _DotIndicatorState();
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

  void _navigateToDoctorAppointmentScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AdminSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous Button (Custom Navigation Button)
          CustomNavigationButton(
            icon: Icons.arrow_back_ios,
            isFilled: _currentPage != 0,
            onPressed: _currentPage == 0
                ? null // Disable button on first page
                : () {
                    widget._controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
          ),
          // Dot Indicators
          SmoothPageIndicator(
            controller: widget._controller,
            count: 3,
            effect: const SlideEffect(
              activeDotColor: customBlue,
            ),
          ),
          // Next Button (Custom Navigation Button)
          CustomNavigationButton(
            icon: _currentPage == 2 ? Icons.check : Icons.arrow_forward_ios,
            isFilled: true, // Always filled to indicate it's active
            onPressed: _currentPage == 2
                ? _navigateToDoctorAppointmentScreen // Navigate to DoctorAppointmentScreen on last page
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
