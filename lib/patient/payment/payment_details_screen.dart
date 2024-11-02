import 'package:flutter/material.dart';
import 'package:ez_health/patient/confirmation/confirmation_screen.dart';
import 'package:ez_health/assets/constants/constants.dart';

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

  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  String _cardHolderName = '';

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

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Preview
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2F97), Color(0xFF0165FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'lib/assets/images/paymentmethod-assets/chip.png',
                          height: 40,
                          width: 40,
                        ),
                        Image.asset(
                          'lib/assets/images/paymentmethod-assets/mastercard_logo.png',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                    Text(
                      _cardNumber.isEmpty ? '**** **** **** ****' : _cardNumber,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 24, letterSpacing: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CARD HOLDER',
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 12)),
                            Text(
                              _cardHolderName.isEmpty
                                  ? 'Your Name'
                                  : _cardHolderName.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('EXPIRES',
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 12)),
                            Text(
                              _expiryDate.isEmpty ? 'MM/YY' : _expiryDate,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Card Number Field
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                maxLength: 19,
                onChanged: (value) {
                  setState(() {
                    _cardNumber = _formatCardNumber(value);
                    _cardNumberController.value = TextEditingValue(
                      text: _cardNumber,
                      selection:
                          TextSelection.collapsed(offset: _cardNumber.length),
                    );
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter card number'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                          labelText: 'MM/YY', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      onChanged: (value) => setState(() => _expiryDate = value),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                          labelText: 'CVV', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      onChanged: (value) => setState(() => _cvv = value),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Card Holder Name',
                    border: OutlineInputBorder()),
                onChanged: (value) => setState(() => _cardHolderName = value),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter card holder name'
                    : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConfirmationScreen()),
                      );
                    }
                  },
                  child: const Text('Pay & Confirm',
                      style: TextStyle(fontSize: 18, color: customLightBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
