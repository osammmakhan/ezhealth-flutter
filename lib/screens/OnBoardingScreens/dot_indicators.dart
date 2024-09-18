import 'package:ez_health/auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ez_health/assets/constants/constants.dart';

// import '../patient/doctor_appointment.dart';

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
        // builder: (context) => DoctorAppointmentScreen(),
        builder: (context) => const AuthScreen(),
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
          CustomNavigationButton(
            icon: Icons.arrow_back_ios,
            isFilled: _currentPage != 0,
            onPressed: _currentPage == 0
                ? null
                : () {
                    widget._controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
          ),
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
                ? _navigateToDoctorAppointmentScreen
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
      child: Icon(
        icon,
        color: isFilled ? Colors.white : customBlue,
      ),
    );
  }
}
