import 'package:flutter/material.dart';
import 'package:ez_health/patient/payment/payment_details_screen.dart';
import 'package:ez_health/assets/constants/constants.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, String>> paymentMethods = [
    {'name': 'Visa', 'icon': 'lib/assets/images/paymentmethod-assets/visa.png'},
    {'name': 'MasterCard', 'icon': 'lib/assets/images/paymentmethod-assets/mastercard.png'},
    {'name': 'American Express', 'icon': 'lib/assets/images/paymentmethod-assets/american_ex.png'},
    {'name': 'PayPal', 'icon': 'lib/assets/images/paymentmethod-assets/paypal.png'},
    {'name': 'Diners', 'icon': 'lib/assets/images/paymentmethod-assets/diners.png'},
  ];

  bool _showMethodsList = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 600,
          ),
          child: _showMethodsList 
              ? _buildPaymentMethodsList(isSmallScreen)
              : _buildEmptyState(isSmallScreen),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No Payment Found',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 15),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 40 : 60,
          ),
          child: Text(
            'You can add and edit payments during checkout',
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: isSmallScreen ? 40 : 60),
        Container(
          width: isSmallScreen ? 280 : 350,
          height: isSmallScreen ? 120 : 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                setState(() {
                  _showMethodsList = true;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: customBlue, width: 2),
                    ),
                    child: const Icon(Icons.add, color: customBlue, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add Payment Method',
                    style: TextStyle(
                      color: customBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsList(bool isSmallScreen) {
    return ListView.builder(
      itemCount: paymentMethods.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 16 : 24,
        horizontal: isSmallScreen ? 24 : 32,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentDetailsScreen(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 16 : 24,
                  horizontal: isSmallScreen ? 24 : 32,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      paymentMethods[index]['icon']!,
                      width: isSmallScreen ? 40 : 50,
                      height: isSmallScreen ? 25 : 35,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: isSmallScreen ? 16 : 24),
                    Expanded(
                      child: Text(
                        paymentMethods[index]['name']!,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: isSmallScreen ? 24 : 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}