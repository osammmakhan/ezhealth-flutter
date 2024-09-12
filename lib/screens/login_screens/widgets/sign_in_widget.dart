import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWidget extends StatefulWidget {
  final String userType;
  final Function(String) onUserTypeChange;

  const SignInWidget({
    super.key,
    required this.userType,
    required this.onUserTypeChange,
  });

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                  // style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.userType == 'Patient'
                      ? 'Welcome Back, You\'ve been missed'
                      : 'Welcome Back Doctor, Patient are waiting for You!',
                  // style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember password'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password functionality
                      },
                      child: const Text('Forget password'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Login Button
                HorizontalBtn(
                  text: 'Login',
                  onPressed: signIn,
                ),
                const SizedBox(height: 16),
                const Text(
                  'or connect with',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton(
                        'lib/screens/login_screens/assets/images/facebook_logo.png'),
                    _socialButton(
                        'lib/screens/login_screens/assets/images/pinterest_logo.png'),
                    _socialButton(
                        'lib/screens/login_screens/assets/images/insta_logo.png'),
                    _socialButton(
                        'lib/screens/login_screens/assets/images/linkedIn_Logo.png'),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    widget.onUserTypeChange(
                      widget.userType == 'Patient' ? 'Doctor' : 'Patient',
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16),
                      children: [
                        const TextSpan(
                          text: 'Login as ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: widget.userType == 'Patient'
                              ? 'Doctor'
                              : 'Patient',
                          style: const TextStyle(color: customBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetName) {
    return InkWell(
      onTap: () {
        // TODO: Implement social sign-in
      },
      child: Image.asset(assetName, width: 40, height: 40),
    );
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // TODO: Navigate to the appropriate screen based on user type
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }
  }
}
