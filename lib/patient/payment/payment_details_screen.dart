import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/providers/payment_provider.dart';
import 'package:ez_health/assets/constants/horizontal_button.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:ez_health/patient/appointment_request_success_screen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String input) {
    input = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    // Remove spaces and check if it's exactly 16 digits
    final cleanNumber = value.replaceAll(' ', '');
    if (cleanNumber.length != 16) {
      return 'Card number must be 16 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'Card number can only contain numbers';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    // Check format MM/YY
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Use MM/YY format';
    }
    // Validate expiry date is not in the past
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Card has expired';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card holder name';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Payment Details',
              style: TextStyle(color: Colors.white)),
          backgroundColor: customBlue,
          elevation: 0,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 600,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: isSmallScreen ? 200 : 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1E2F97), Color(0xFF0165FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                        'lib/assets/images/paymentmethod-assets/chip.png',
                                        height: 40,
                                        width: 40),
                                    Image.asset(
                                        'lib/assets/images/paymentmethod-assets/mastercard_logo.png',
                                        height: 40,
                                        width: 40),
                                  ],
                                ),
                                Text(
                                  paymentProvider.cardNumber.isEmpty
                                      ? '**** **** **** ****'
                                      : paymentProvider.cardNumber,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      letterSpacing: 2),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('CARD HOLDER',
                                            style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12)),
                                        Text(
                                          paymentProvider.cardHolderName.isEmpty
                                              ? 'Your Name'
                                              : paymentProvider.cardHolderName
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('EXPIRES',
                                            style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12)),
                                        Text(
                                          paymentProvider.expiryDate.isEmpty
                                              ? 'MM/YY'
                                              : paymentProvider.expiryDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 30 : 40),
                          TextFormField(
                            controller: _cardNumberController,
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.credit_card),
                              contentPadding:
                                  EdgeInsets.all(isSmallScreen ? 16 : 20),
                            ),
                            style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                            keyboardType: TextInputType.number,
                            maxLength: 19,
                            onChanged: (value) {
                              final formatted = _formatCardNumber(value);
                              paymentProvider.setCardNumber(formatted);
                              _cardNumberController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            },
                            validator: _validateCardNumber,
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 30),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _expiryController,
                                  decoration: InputDecoration(
                                    labelText: 'MM/YY',
                                    border: const OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.all(isSmallScreen ? 16 : 20),
                                  ),
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18),
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  onChanged: (value) {
                                    // Auto-format MM/YY
                                    if (value.length == 2 &&
                                        !value.contains('/')) {
                                      value = '$value/';
                                      _expiryController.value =
                                          TextEditingValue(
                                        text: value,
                                        selection: TextSelection.collapsed(
                                            offset: value.length),
                                      );
                                    }
                                    paymentProvider.setExpiryDate(value);
                                  },
                                  validator: _validateExpiryDate,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 20 : 30),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  decoration: InputDecoration(
                                    labelText: 'CVV',
                                    border: const OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.all(isSmallScreen ? 16 : 20),
                                  ),
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18),
                                  keyboardType: TextInputType.number,
                                  maxLength: 3,
                                  onChanged: paymentProvider.setCVV,
                                  validator: _validateCVV,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 30),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Card Holder Name',
                              border: const OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.all(isSmallScreen ? 16 : 20),
                            ),
                            style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            onChanged: paymentProvider.setCardHolderName,
                            validator: _validateCardHolderName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Consumer<AppointmentProvider>(
                    builder: (context, provider, child) {
                      return HorizontalBtn(
                        text: provider.isLoading
                            ? 'Processing...'
                            : 'Pay & Confirm',
                        enabled: !provider.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final paymentProvider =
                                  Provider.of<PaymentProvider>(context,
                                      listen: false);

                              // Process payment first
                              await provider.processPayment(
                                cardNumber: paymentProvider.cardNumber,
                                expiryDate: paymentProvider.expiryDate,
                                cvv: paymentProvider.cvv,
                                cardHolderName: paymentProvider.cardHolderName,
                              );

                              // Create pending appointment request
                              await provider.createAppointment();

                              if (!context.mounted) return;

                              // Navigate to success screen
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AppointmentRequestSuccessScreen(),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              if (!context.mounted) return;

                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );

                              // Still navigate to success screen if appointment was created
                              if (provider.appointmentId.isNotEmpty) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AppointmentRequestSuccessScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
