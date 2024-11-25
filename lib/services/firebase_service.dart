import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth Methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User Methods
  Future<void> createUserDocument(User user, String name) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLastLogin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  // Appointment Methods
  Future<void> createAppointment(Map<String, dynamic> appointmentData) async {

    final updatedData = {
      ...appointmentData,
      'isStarted': false,
      'startedAt': null,
      'completedAt': null,
    };

    await _firestore.collection('appointments').add(updatedData);
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> startAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'isStarted': true,
      'startedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'completed',
      'isStarted': false,
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Get the appointment details for notification
    final appointment = await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .get();

    if (appointment.exists) {
      final patientId = appointment.data()?['userId'];
      if (patientId != null) {
        await createNotification(
          patientId,
          'Your appointment has been completed',
          'appointment_completed',
        );
      }
    }
  }

  // Method for rescheduling
  Future<void> rescheduleAppointment(String appointmentId, DateTime newDate, String newTime) async {

    await _firestore.collection('appointments').doc(appointmentId).update({
      'appointmentDate': newDate,
      'appointmentTime': newTime,
      'status': 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Waiting List Methods
  Future<void> addToWaitingList(String appointmentId, bool isEmergency) async {
    final waitingListRef = _firestore.collection('waitingList').doc('current');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(waitingListRef);

      if (!snapshot.exists) {
        transaction.set(waitingListRef, {
          'queue': [{
            'appointmentId': appointmentId,
            'isEmergency': isEmergency,
            'addedAt': FieldValue.serverTimestamp(),
          }]
        });
      } else {
        List<dynamic> queue = snapshot.data()?['queue'] ?? [];
        queue.add({
          'appointmentId': appointmentId,
          'isEmergency': isEmergency,
          'addedAt': FieldValue.serverTimestamp(),
        });
        transaction.update(waitingListRef, {'queue': queue});
      }
    });
  }

  Future<void> removeFromWaitingList(String appointmentId) async {
    final waitingListRef = _firestore.collection('waitingList').doc('current');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(waitingListRef);

      if (snapshot.exists) {
        List<dynamic> queue = snapshot.data()?['queue'] ?? [];
        queue.removeWhere((item) => item['appointmentId'] == appointmentId);
        transaction.update(waitingListRef, {'queue': queue});
      }
    });
  }

  // Notification Methods
  Future<void> createNotification(String userId, String message, String type) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'message': message,
      'type': type,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'read': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}