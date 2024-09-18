import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';

class PaymentMethodListScreen extends StatelessWidget {
  final List<Map<String, String>> paymentMethods = [
    {'name': 'Visa', 'icon': 'lib/assets/images/payment_method/visa.png'},
    {
      'name': 'MasterCard',
      'icon': 'lib/assets/images/payment_method/mastercard.png'
    },
    {
      'name': 'American Express',
      'icon': 'lib/assets/images/payment_method/american_ex.png'
    },
    {'name': 'PayPal', 'icon': 'lib/assets/images/payment_method/paypal.png'},
    {'name': 'Diners', 'icon': 'lib/assets/images/payment_method/diners.png'},
  ];

  PaymentMethodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          itemCount: paymentMethods.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    print(
                        'Add ${paymentMethods[index]['name']} payment method');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Row(
                      children: [
                        Image.asset(
                          paymentMethods[index]['icon']!,
                          width: 40,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            paymentMethods[index]['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
