import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String cardHolderName = '';

  void setCardNumber(String number) {
    cardNumber = number;
    notifyListeners();
  }

  void setExpiryDate(String date) {
    expiryDate = date;
    notifyListeners();
  }

  void setCVV(String newCVV) {
    cvv = newCVV;
    notifyListeners();
  }

  void setCardHolderName(String name) {
    cardHolderName = name;
    notifyListeners();
  }
}