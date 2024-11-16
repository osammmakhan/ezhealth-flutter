import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_health/assets/constants/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: customBlue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStats(isSmallScreen),
            const SizedBox(height: 24),
            _buildAppointmentsList(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(bool isSmallScreen) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isSmallScreen ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Today\'s Appointments', '12', Icons.calendar_today),
        _buildStatCard('Waiting', '5', Icons.people),
        _buildStatCard('Completed', '7', Icons.check_circle),
        _buildStatCard('Cancelled', '2', Icons.cancel),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: customBlue, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: customBlue,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(bool isSmallScreen) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'confirmed')
          .orderBy('appointmentDate', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        print('Connection state: ${snapshot.connectionState}');
        print('Has error: ${snapshot.hasError}');
        if (snapshot.hasError) {
          print('Error details: ${snapshot.error}');
        }
        print('Has data: ${snapshot.hasData}');
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data?.docs ?? [];
        
        print('Number of appointments: ${appointments.length}');

        if (appointments.isEmpty) {
          return const Center(child: Text('No appointments found'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Appointments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index].data() as Map<String, dynamic>;
                print('Building appointment card for index: $index');
                try {
                  return _buildAppointmentCard(appointment, isSmallScreen, appointments[index].id);
                } catch (e, stackTrace) {
                  print('Error building appointment card: $e');
                  print('Stack trace: $stackTrace');
                  return const SizedBox();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, bool isSmallScreen, String appointmentId) {
    try {
      final patientName = appointment['patientName'] ?? 'Unknown Patient';
      final status = appointment['status'] ?? 'pending';
      final appointmentDate = appointment['appointmentDate'] as Timestamp?;
      final appointmentTime = appointment['appointmentTime'] ?? 'Not specified';
      final isStarted = appointment['isStarted'] ?? false;

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: customLightBlue,
                  child: Icon(Icons.person, color: customBlue),
                ),
                title: Text(
                  patientName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      appointmentDate != null 
                          ? _formatDate(appointmentDate) 
                          : 'Date not specified',
                    ),
                    Text('Time: $appointmentTime'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (status != 'completed') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isStarted) ...[
                      ElevatedButton.icon(
                        onPressed: () => _startAppointment(appointmentId),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Appointment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () => _markAsCompleted(appointmentId),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('End Appointment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in _buildAppointmentCard: $e');
      print('Stack trace: $stackTrace');
      return const Card(
        margin: EdgeInsets.only(bottom: 16),
        child: ListTile(
          title: Text('Error displaying appointment'),
        ),
      );
    }
  }

  String _formatDate(Timestamp timestamp) {
    try {
      final date = timestamp.toDate();
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid date';
    }
  }

  Future<void> _startAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'isStarted': true,
        'startedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment started')),
        );
      }
    } catch (e) {
      print('Error starting appointment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _markAsCompleted(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'completed',
        'isStarted': false,
        'completedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment completed')),
        );
      }
    } catch (e) {
      print('Error completing appointment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}