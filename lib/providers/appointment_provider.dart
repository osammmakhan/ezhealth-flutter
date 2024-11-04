import 'package:flutter/material.dart';

class AppointmentProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  String _bookingFor = '';
  String _gender = '';
  double _age = 0;
  String _problemDescription = '';
  String _otherPersonName = '';
  bool _isRescheduling = false;
  String _appointmentId = '';

  // Getters
  DateTime get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;
  String get bookingFor => _bookingFor;
  String get gender => _gender;
  double get age => _age;
  String get problemDescription => _problemDescription;
  String get otherPersonName => _otherPersonName;
  bool get isRescheduling => _isRescheduling;
  String get appointmentId => _appointmentId;

  // Check if there's an active appointment
  bool get hasActiveAppointment =>
      _selectedTime.isNotEmpty && _selectedDate.isAfter(DateTime.now());

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setBookingFor(String booking) {
    _bookingFor = booking;
    if (booking != 'Other') {
      _otherPersonName = '';
    }
    notifyListeners();
  }

  void setOtherPersonName(String name) {
    _otherPersonName = name;
    notifyListeners();
  }

  void setGender(String selectedGender) {
    _gender = selectedGender;
    notifyListeners();
  }

  void setAge(double newAge) {
    _age = newAge;
    notifyListeners();
  }

  void setProblemDescription(String description) {
    _problemDescription = description;
    notifyListeners();
  }

  void setAppointmentId(String id) {
    _appointmentId = id;
    notifyListeners();
  }

  void startRescheduling() {
    _isRescheduling = true;
    notifyListeners();
  }

  void cancelRescheduling() {
    _isRescheduling = false;
    notifyListeners();
  }

  void cancelAppointment() {
    _selectedDate = DateTime.now();
    _selectedTime = '';
    _appointmentId = '';
    _isRescheduling = false;
    notifyListeners();
  }

  void confirmAppointment() {
    // Generate a random appointment ID (in real app, this would come from backend)
    _appointmentId =
        '#${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';
    _isRescheduling = false;
    notifyListeners();
  }

  void rescheduleAppointment(DateTime newDate, String newTime) {
    _selectedDate = newDate;
    _selectedTime = newTime;
    _isRescheduling = false;
    notifyListeners();
  }

  // Reset all appointment data
  void resetAppointmentData() {
    _selectedDate = DateTime.now();
    _selectedTime = '';
    _bookingFor = '';
    _gender = '';
    _age = 0;
    _problemDescription = '';
    _otherPersonName = '';
    _isRescheduling = false;
    _appointmentId = '';
    notifyListeners();
  }
}
