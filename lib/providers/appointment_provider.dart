import 'package:flutter/material.dart';

class AppointmentProvider with ChangeNotifier {
  // Home Screen State
  int _selectedIndex = 1;
  bool _hasAppointment = false;

  // Appointment State
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  String _bookingFor = '';
  String _gender = '';
  double _age = 0;
  String _problemDescription = '';
  String _otherPersonName = '';
  bool _isRescheduling = false;
  String _appointmentId = '';
  bool _hasConfirmedAppointment =false; // New field to track confirmed appointments
  String _referenceNumber = '';

  // Add this static variable at the top of the class to keep track of the last appointment number
  static int _lastAppointmentNumber = 0;

  // Home Screen Getters
  int get selectedIndex => _selectedIndex;
  bool get hasAppointment => _hasAppointment;

  // Appointment Getters
  DateTime get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;
  String get bookingFor => _bookingFor;
  String get gender => _gender;
  double get age => _age;
  String get problemDescription => _problemDescription;
  String get otherPersonName => _otherPersonName;
  bool get isRescheduling => _isRescheduling;
  String get appointmentId => _appointmentId;
  bool get hasConfirmedAppointment => _hasConfirmedAppointment;
  String get referenceNumber => _referenceNumber;

  bool get hasActiveAppointment {

    return _selectedTime.isNotEmpty && _appointmentId.isNotEmpty;
    // Check if there's an active appointment
    // bool get hasActiveAppointment =>
    // _hasConfirmedAppointment &&
    // _selectedTime.isNotEmpty &&
    // _selectedDate.isAfter(DateTime.now());
  }

  // Home Screen Methods
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setHasAppointment(bool value) {
    _hasAppointment = value;
    notifyListeners();
  }

  // Appointment Methods
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
    _hasConfirmedAppointment = false; // Reset confirmation status
    notifyListeners();
  }

//   // Updated confirmAppointment method
  void confirmAppointment() {
    // Generate sequential appointment ID
    _lastAppointmentNumber = (_lastAppointmentNumber + 1) % 100; // Keep it within 2 digits
    _appointmentId = '#${_lastAppointmentNumber.toString().padLeft(2, '0')}';

    // Generate reference number
    generateReferenceNumber();

    // Ensure we have all required data
    if (_selectedTime.isEmpty) {
      throw Exception('Selected time cannot be empty when confirming appointment');
    }

    _isRescheduling = false;
    _hasConfirmedAppointment = true;  // Set confirmation status
    notifyListeners();
  }

  void rescheduleAppointment(DateTime newDate, String newTime) {
    _selectedDate = newDate;
    _selectedTime = newTime;
    _isRescheduling = false;
    notifyListeners();
  }

  // Make sure appointment data persists when needed
  void resetAppointmentData() {
    if (!hasActiveAppointment) {
      _selectedDate = DateTime.now();
      _selectedTime = '';
      _bookingFor = '';
      _gender = '';
      _age = 0;
      _problemDescription = '';
      _otherPersonName = '';
      _isRescheduling = false;
      _appointmentId = '';
      // _hasConfirmedAppointment = false;  // Reset confirmation status
      notifyListeners();
    }
  }

  void generateReferenceNumber() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final date = '$year${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final random = (100 + DateTime.now().millisecondsSinceEpoch % 900).toString();
    _referenceNumber = 'REF-$date-$random';
    notifyListeners();
  }
}