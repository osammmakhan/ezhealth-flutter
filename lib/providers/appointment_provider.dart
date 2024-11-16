import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isLoading = false;
  String _appointmentId = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  String _bookingFor = 'Myself';
  String _gender = '';
  double _age = 0;
  String _problemDescription = '';
  Stream<QuerySnapshot>? _appointmentsStream;
  int _selectedIndex = 0;
  String _otherPersonName = '';
  bool _hasRescheduleRequest = false;

  // Getters
  bool get isLoading => _isLoading;
  String get appointmentId => _appointmentId;
  DateTime get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;
  String get bookingFor => _bookingFor;
  String get gender => _gender;
  double get age => _age;
  String get problemDescription => _problemDescription;
  Stream<QuerySnapshot>? get appointmentsStream => _appointmentsStream;
  int get selectedIndex => _selectedIndex;
  String get otherPersonName => _otherPersonName;
  bool get hasRescheduleRequest => _hasRescheduleRequest;

  // Generate Appointment Number
  Future<String> _generateAppointmentNumber() async {
    final today = DateTime.now();
    final counterKey = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    final docRef = _firestore.collection('counters').doc('appointments');
    
    try {
      String number = await _firestore.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(docRef);
        
        Map<String, dynamic> data = snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};
        int currentNumber = data[counterKey] ?? 0;
        
        int newNumber = (currentNumber % 99) + 1; // Reset to 1 after reaching 99
        
        // Update the counter for today's date
        transaction.set(docRef, {counterKey: newNumber}, SetOptions(merge: true));
        
        // Format: AP-MMDD-XX (e.g., AP-0512-01)
        return 'AP-${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}-${newNumber.toString().padLeft(2, '0')}';
      });
      
      return number;
    } catch (e) {
      print('Error generating appointment number: $e');
      rethrow;
    }
  }

  // Method to create initial appointment
  Future<void> createAppointment() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final appointmentNumber = await _generateAppointmentNumber();

      
      final appointmentRef = _firestore.collection('appointments').doc();
      _appointmentId = appointmentRef.id;

      await appointmentRef.set({
        'appointmentNumber': appointmentNumber,
        'userId': user.uid,
        'patientName': _bookingFor == 'Myself' ? user.displayName : _otherPersonName,
        'appointmentDate': Timestamp.fromDate(_selectedDate),
        'appointmentTime': _selectedTime,
        'bookingFor': _bookingFor,
        'gender': _gender,
        'age': _age,
        'problemDescription': _problemDescription,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'paymentStatus': 'completed',
        'paymentAmount': 500.00,
        'isStarted': false,
        'startedAt': null,
        'completedAt': null,
      });

      // Create notification for admin
      await _firestore.collection('notifications').add({
        'userId': 'admin',
        'type': 'new_appointment',
        'appointmentId': _appointmentId,
        'message': 'New appointment request: $appointmentNumber',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to only handle status changes
  Future<void> confirmAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get the appointment document
      final appointmentDoc = await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!appointmentDoc.exists) {
        throw 'Appointment not found';
      }

      // Update only the status and updatedAt fields
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'confirmed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for patient
      final patientId = appointmentDoc.data()?['userId'];
      if (patientId != null) {
        await _firestore.collection('notifications').add({
          'userId': patientId,
          'type': 'appointment_confirmed',
          'appointmentId': appointmentId,
          'message': 'Your appointment has been confirmed',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

    } catch (e) {
      print('Error confirming appointment: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Setters
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setBookingFor(String value) {
    _bookingFor = value;
    notifyListeners();
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void setAge(double value) {
    _age = value;
    notifyListeners();
  }

  void setProblemDescription(String value) {
    _problemDescription = value;
    notifyListeners();
  }

  void resetForm() {
    _appointmentId = '';
    _selectedDate = DateTime.now();
    _selectedTime = '';
    _bookingFor = 'Myself';
    _gender = '';
    _age = 0;
    _problemDescription = '';
    notifyListeners();
  }

  void setOtherPersonName(String value) {
    _otherPersonName = value;
    notifyListeners();
  }

  // Add this method
  Future<void> markAppointmentAsCompleted(String appointmentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for patient
      final appointment = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();
      
      if (appointment.exists) {
        final patientId = appointment.data()?['userId'];
        if (patientId != null) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'userId': patientId,
            'type': 'appointment_completed',
            'appointmentId': appointmentId,
            'message': 'Your appointment has been marked as completed',
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

    } catch (e) {
      print('Error marking appointment as completed: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Initialize streams
  void initializeStreams() {
    final user = _auth.currentUser;
    if (user != null) {
      // Get the current active appointment
      FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .where('status', whereIn: ['confirmed', 'pending'])
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          appointmentId = snapshot.docs.first.id;
        }
      });

      // Stream for all appointments
      _appointmentsStream = _firestore
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots();

      // Check for reschedule requests
      _firestore
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        _hasRescheduleRequest = snapshot.docs.any((doc) {
          Map<String, dynamic> data = {};
          try {
            data = doc.data() as Map<String, dynamic>;
          } catch (e) {
            return false;
          }
          return data.containsKey('requestedDate') && 
                 data.containsKey('requestedTime');
        });
        notifyListeners();
      });
    }
  }

  // Set selected index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Payment processing
  Future<void> processPayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful payment
      print('Payment processed successfully');
      print('Card Number: ${cardNumber.replaceRange(0, cardNumber.length - 4, '*' * (cardNumber.length - 4))}');
      print('Amount: \$500.00');

    } catch (e) {
      print('Payment processing error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add this new method
  Future<void> requestReschedule(String appointmentId, DateTime newDate, String newTime) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'pending',
        'requestedDate': Timestamp.fromDate(newDate),
        'requestedTime': newTime,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for admin
      await _firestore.collection('notifications').add({
        'userId': 'admin',
        'type': 'reschedule_request',
        'appointmentId': appointmentId,
        'message': 'Patient requested to reschedule appointment',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print('Error requesting reschedule: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setAppointmentIdSilently(String value) {
    _appointmentId = value;
    // No notifyListeners() call
  }

  set appointmentId(String value) {
    _appointmentId = value;
    notifyListeners();
  }

  Future<void> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for admin
      await _firestore.collection('notifications').add({
        'userId': 'admin',
        'type': 'appointment_cancelled',
        'appointmentId': appointmentId,
        'message': 'Patient cancelled their appointment',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print('Error cancelling appointment: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}