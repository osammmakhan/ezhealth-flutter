import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';

class AppointmentRequestSuccessScreen extends StatelessWidget {
  const AppointmentRequestSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 600,
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isSmallScreen ? 100 : 120,
                    height: isSmallScreen ? 100 : 120,
                    decoration: BoxDecoration(
                      color: customLightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: customBlue,
                      size: isSmallScreen ? 60 : 72,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 32 : 48),
                  Text(
                    'Request Submitted Successfully!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Text(
                    'Your appointment request has been submitted and is awaiting confirmation from our staff. You will receive a notification once your appointment has been confirmed.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 48 : 64),
                  HorizontalBtn(
                    text: 'Return to Home',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 