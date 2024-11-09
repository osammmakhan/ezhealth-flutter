import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/providers/appointment_provider.dart';

class DoctorAppointmentDetailsScreen extends StatelessWidget {
  final String appointmentId;

  const DoctorAppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Appointment Details'),
            backgroundColor: customBlue,
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .doc(appointmentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Appointment not found'));
              }

              final appointmentData = snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppointmentInfo(appointmentData, isSmallScreen),
                    const SizedBox(height: 24),
                    _buildPatientInfo(appointmentData, isSmallScreen),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, provider, appointmentData, isSmallScreen),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAppointmentInfo(Map<String, dynamic> data, bool isSmallScreen) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Appointment ID', data['appointmentNumber'] ?? 'N/A', isSmallScreen),
            const SizedBox(height: 12),
            _buildInfoRow('Date', _formatDate(data['appointmentDate']), isSmallScreen),
            const SizedBox(height: 12),
            _buildInfoRow('Time', data['appointmentTime'] ?? 'N/A', isSmallScreen),
            const SizedBox(height: 12),
            _buildInfoRow('Status', data['status']?.toUpperCase() ?? 'N/A', isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfo(Map<String, dynamic> data, bool isSmallScreen) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Patient Name', data['patientName'] ?? 'N/A', isSmallScreen),
            const SizedBox(height: 12),
            _buildInfoRow('Age', '${data['age']?.toString() ?? 'N/A'} years', isSmallScreen),
            const SizedBox(height: 12),
            _buildInfoRow('Gender', data['gender'] ?? 'N/A', isSmallScreen),
            const SizedBox(height: 12),
            const Text(
              'Problem Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(data['problemDescription'] ?? 'No description provided'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppointmentProvider provider,
      Map<String, dynamic> data, bool isSmallScreen) {
    final status = data['status'] ?? '';
    if (status == 'completed' || status == 'cancelled') return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              try {
                await provider.markAppointmentAsCompleted(appointmentId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment marked as completed')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: customBlue,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 12 : 16,
              ),
            ),
            child: const Text('Mark as Completed'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      return date;
    } else if (date is num) {
      return DateTime.fromMillisecondsSinceEpoch(date.toInt()).toString();
    } else if (date is DateTime) {
      return date.toString();
    } else {
      throw Exception('Invalid date format');
    }
  }
} 