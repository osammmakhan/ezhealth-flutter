import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  int _selectedIndex = 1;
  bool _hasAppointment = false;

  int get selectedIndex => _selectedIndex;
  bool get hasAppointment => _hasAppointment;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setHasAppointment(bool value) {
    _hasAppointment = value;
    notifyListeners();
  }
}