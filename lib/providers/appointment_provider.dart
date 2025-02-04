import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // STATE VARIABLES
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
  bool _isEmergency = false;

  // GETTERS
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
  bool get isEmergency => _isEmergency;

  //SETTERS
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
    _age = value.roundToDouble();
    notifyListeners();
  }

  void setProblemDescription(String value) {
    _problemDescription = value;
    notifyListeners();
  }

  void setOtherPersonName(String name) {
    _otherPersonName = name.trim();
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setEmergency(bool value) {
    _isEmergency = value;
    notifyListeners();
  }

  // Special setters
  void setAppointmentIdSilently(String value) {
    _appointmentId = value;
  }

  set appointmentId(String value) {
    _appointmentId = value;
    notifyListeners();
  }

  // APPOINTMENT CREATION & MANAGEMENT
  Future<String> _generateAppointmentNumber() async {
    final today = DateTime.now();
    final counterKey = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    final docRef = _firestore.collection('counters').doc('appointments');

    try {
      String number = await _firestore.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(docRef);
        Map<String, dynamic> data = snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};
        int currentNumber = data[counterKey] ?? 0;
        int newNumber = (currentNumber % 99) + 1;
        transaction.set(docRef, {counterKey: newNumber}, SetOptions(merge: true));
        return 'AP-${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}-${newNumber.toString().padLeft(2, '0')}';
      });
      return number;
    } catch (e) {
      print('Error generating appointment number: $e');
      rethrow;
    }
  }

  Future<void> createAppointment({bool isAdmin = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final appointmentNumber = await _generateAppointmentNumber();

      final appointmentRef = _firestore.collection('appointments').doc();
      _appointmentId = appointmentRef.id;

      // Get the correct patient name
      String patientName;
      if (_bookingFor == 'Myself') {
        patientName = user.displayName ?? 'Unknown';
      } else {
        if (_otherPersonName.isEmpty) {
          throw 'Other person name is required';
        }
        patientName = _otherPersonName;
      }

      await appointmentRef.set({
        'appointmentNumber': appointmentNumber,
        'userId': user.uid,
        'patientName': patientName,
        'appointmentDate': Timestamp.fromDate(_selectedDate),
        'appointmentTime': _selectedTime,
        'bookingFor': _bookingFor,
        'gender': _gender,
        'age': _age,
        'problemDescription': _problemDescription,
        'status': isAdmin ? 'confirmed' : 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'paymentStatus': isAdmin ? 'cash' : 'completed',
        'paymentAmount': 500.00,
        'isStarted': false,
        'startedAt': null,
        'completedAt': null,
        'isEmergency': isAdmin ? _isEmergency : false,
      });

      // If admin and emergency, add to waiting list immediately
      if (isAdmin && _isEmergency) {
        await _firestore.collection('waitingList').add({
          'appointmentId': _appointmentId,
          'isEmergency': true,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      // Create notification only for patient appointments
      if (!isAdmin) {
        await _firestore.collection('notifications').add({
          'userId': 'admin',
          'type': 'new_appointment',
          'appointmentId': _appointmentId,
          'message': 'New appointment request: $appointmentNumber',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // If it's an emergency appointment, create notification for doctor
      if (isAdmin && _isEmergency) {
        await createDoctorNotification(
          type: 'emergency_appointment',
          appointmentId: _appointmentId,
          appointmentData: {
            'patientName': patientName,
            'appointmentTime': _selectedTime,
          },
        );
      }

    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

      final appointmentData = appointmentDoc.data() as Map<String, dynamic>;

      // Update appointment status
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'confirmed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for doctor
      await createDoctorNotification(
        type: 'new_appointment_confirmed',
        appointmentId: appointmentId,
        appointmentData: appointmentData,
      );

      // Create notification for patient (existing logic)
      final patientId = appointmentData['userId'];
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

  // NOTIFICATION MANAGEMENT
  Future<void> createDoctorNotification({
    required String type,
    required String appointmentId,
    required Map<String, dynamic> appointmentData,
  }) async {
    try {
      String message;
      bool isPriority = false;

      switch (type) {
        case 'new_appointment_confirmed':
          message = 'New appointment confirmed for ${appointmentData['appointmentTime']} with ${appointmentData['patientName']}';
          break;
        case 'emergency_appointment':
          message = 'Emergency appointment added: ${appointmentData['patientName']}';
          isPriority = true;
          break;
        default:
          return;
      }

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': 'doctor',
        'type': type,
        'appointmentId': appointmentId,
        'message': message,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
        if (isPriority) 'priority': 'high',
      });
    } catch (e) {
      print('Error creating doctor notification: $e');
      rethrow;
    }
  }

  // STREAM MANAGEMENT
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

  // UTILITY METHODS
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

  String formatAge(dynamic age) {
    if (age == null) return 'N/A';
    try {
      return double.parse(age.toString()).round().toString();
    } catch (e) {
      return age.toString();
    }
  }

  // PAYMENT PROCESSING
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
}