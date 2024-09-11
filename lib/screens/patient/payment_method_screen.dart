import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'payment_method_list_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment Methods', style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Payment Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'You can add and edit payments during checkout',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 280,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentMethodListScreen()),
                    );
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
                        child: Icon(Icons.add, color: customBlue, size: 30),
                      ),
                      SizedBox(height: 10),
                      Text(
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
        ),
      ),
    );
  }
}
