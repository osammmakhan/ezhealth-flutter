import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: customBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: _buildStatisticsCards(isSmallScreen),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildAppointmentsList(isSmallScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(bool isSmallScreen) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isSmallScreen ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Appointments', '45', Icons.calendar_today),
        _buildStatCard('Total Revenue', 'PKR 22,500', Icons.attach_money),
        _buildStatCard('Active Doctors', '3', Icons.medical_services),
        _buildStatCard('Pending Reviews', '12', Icons.rate_review),
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
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(bool isSmallScreen) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .orderBy('appointmentDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = snapshot.data?.docs ?? [];

          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index].data() as Map<String, dynamic>;
              return _buildAppointmentCard(
                context,
                appointment,
                appointments[index].id,
                isSmallScreen,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appointment, String id, bool isSmallScreen) {
    final status = appointment['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);
    final timestamp = appointment['appointmentDate'] as Timestamp?;
    final date = timestamp?.toDate() ?? DateTime.now();
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patientName'] ?? 'Patient Name',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${appointment['referenceNumber']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  Icons.calendar_today,
                  DateFormat('MMM dd, yyyy').format(date),
                ),
                const SizedBox(width: 16),
                _buildInfoChip(
                  Icons.access_time,
                  appointment['appointmentTime'] ?? 'No time set',
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (status != 'completed' && status != 'cancelled')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (status == 'pending')
                    Expanded(
                      child: _buildActionButton(
                        'Confirm',
                        Icons.check_circle_outline,
                        Colors.green,
                        () => _updateAppointmentStatus(id, 'confirmed'),
                      ),
                    ),
                  if (status == 'pending') const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Cancel',
                      Icons.cancel_outlined,
                      Colors.red,
                      () => _showCancelDialog(context, id),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Reschedule',
                      Icons.schedule,
                      customBlue,
                      () => _showRescheduleDialog(context, id),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        if (status == 'cancelled') 'cancelledBy': 'admin',
      });
    } catch (e) {
      print('Error updating appointment status: $e');
    }
  }

  Future<void> _showCancelDialog(BuildContext context, String appointmentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _updateAppointmentStatus(appointmentId, 'cancelled');
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRescheduleDialog(BuildContext context, String appointmentId) async {
    DateTime selectedDate = DateTime.now();
    String selectedTime = '';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reschedule Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Picker
                CarouselSlider.builder(
                  itemCount: 7,
                  options: CarouselOptions(
                    height: 70,
                    viewportFraction: 0.35,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectedDate = DateTime.now().add(Duration(days: index));
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final date = DateTime.now().add(Duration(days: index));
                    final isSelected = selectedDate.day == date.day;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: OutlinedButton(
                        onPressed: () => setState(() => selectedDate = date),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: isSelected ? customLightBlue : Colors.transparent,
                          side: BorderSide(
                            color: isSelected ? customBlue : Colors.grey.shade300,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? customBlue : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('d MMM').format(date),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? customBlue : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Time Picker
                CarouselSlider.builder(
                  itemCount: 11,
                  options: CarouselOptions(
                    height: 50,
                    viewportFraction: 0.35,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        final time = TimeOfDay(
                          hour: 17 + (index ~/ 2),
                          minute: (index % 2) * 30,
                        );
                        selectedTime = time.format(context);
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final time = TimeOfDay(
                      hour: 17 + (index ~/ 2),
                      minute: (index % 2) * 30,
                    );
                    final timeString = time.format(context);
                    final isSelected = selectedTime == timeString;

                    return OutlinedButton(
                      onPressed: () => setState(() => selectedTime = timeString),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: isSelected ? customLightBlue : Colors.transparent,
                        side: BorderSide(
                          color: isSelected ? customBlue : Colors.grey.shade300,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? customBlue : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: selectedTime.isEmpty ? null : () async {
                await FirebaseFirestore.instance
                    .collection('appointments')
                    .doc(appointmentId)
                    .update({
                  'appointmentDate': Timestamp.fromDate(selectedDate),
                  'appointmentTime': selectedTime,
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}