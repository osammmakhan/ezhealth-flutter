import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ez_health/patient/doctor_appointment.dart';

// // Social Login
// // Context Based Login
// // Forgot Password Email Functionality

// Sign In Screen
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Text(
                  isLogin ? 'Sign In' : 'Create Account',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  isLogin
                      ? 'Welcome Back, You\'ve been missed'
                      : 'Sign up to get started!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AuthWidget(
                  isLogin: isLogin,
                  onSubmit: (email, password, {String? name}) async {
                    try {
                      if (isLogin) {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                      } else {
                        // Create user with email and password
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        // Update user profile with name if provided
                        if (name != null) {
                          await userCredential.user?.updateDisplayName(name);
                        }
                      }
                      // Navigate to the Doctor/Patient/Admin Screen based on the credentials
                      // after successful auth
                      // Navigate to the main screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                const DoctorAppointmentScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(e.message ?? 'An error occurred')),
                      );
                    }
                  },
                ),
                if (isLogin) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'or connect with',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginButton(
                          'lib/assets/images/sociallogin-assets/facebook_logo.png'),
                      _socialLoginButton(
                          'lib/assets/images/sociallogin-assets/insta_logo.png'),
                      _socialLoginButton(
                          'lib/assets/images/sociallogin-assets/linkedin_logo.png'),
                      _socialLoginButton(
                          'lib/assets/images/sociallogin-assets/pinterest_logo.png'),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? "Don't have an account? "
                          : "Already have an account? ",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: toggleAuthMode,
                      child: Text(
                        isLogin ? 'Sign Up' : 'Sign In',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Remove this section if you remove Social Media Login functionality

  Widget _socialLoginButton(String assetName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          // TODO: Implement social login
        },
        child: Image.asset(assetName, width: 40, height: 40),
      ),
    );
  }
}

class AuthWidget extends StatefulWidget {
  final bool isLogin;
  final Function(String email, String password, {String? name}) onSubmit;

  const AuthWidget({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isLogin) ...[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
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
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
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
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                return 'Please enter a password';
              }
              if (!widget.isLogin && value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          if (!widget.isLogin) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 16),
          if (widget.isLogin)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _showForgotPasswordDialog(context);
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.isLogin ? 'Login' : 'Sign Up',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.onSubmit(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          name: !widget.isLogin ? _nameController.text.trim() : null,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email to reset your password:'),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Password reset email sent. Check your inbox.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }
}
