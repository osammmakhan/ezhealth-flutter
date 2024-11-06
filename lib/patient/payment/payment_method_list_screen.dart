import 'package:flutter/material.dart';
import 'package:ez_health/patient/payment/payment_details_screen.dart';
import 'package:ez_health/assets/constants/constants.dart';

class PaymentMethodListScreen extends StatelessWidget {
  final List<Map<String, String>> paymentMethods = [
    {'name': 'Visa', 'icon': 'lib/assets/images/paymentmethod-assets/visa.png'},
    {
      'name': 'MasterCard',
      'icon': 'lib/assets/images/paymentmethod-assets/mastercard.png'
    },
    {
      'name': 'American Express',
      'icon': 'lib/assets/images/paymentmethod-assets/american_ex.png'
    },
    {
      'name': 'PayPal',
      'icon': 'lib/assets/images/paymentmethod-assets/paypal.png'
    },
    {
      'name': 'Diners',
      'icon': 'lib/assets/images/paymentmethod-assets/diners.png'
    },
  ];

  PaymentMethodListScreen({super.key});

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
        title: const Text('Payment Methods',
            style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 600,
          ),
          child: ListView.builder(
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
          ),
        ),
      ),
    );
  }
}
