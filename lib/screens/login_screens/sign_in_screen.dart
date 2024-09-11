import 'package:ez_health/screens/login_screens/widgets/sign_in_widget.dart';
import 'package:flutter/material.dart';

class PatientSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInWidget(
      userType: 'Patient',
      onUserTypeChange: (newUserType) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => DoctorSignInPage()),
        );
      },
    );
  }
}

class DoctorSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInWidget(
      userType: 'Doctor',
      onUserTypeChange: (newUserType) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PatientSignInPage()),
        );
      },
    );
  }
}
