import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_health/assets/constants/constants.dart';

class AppointmentManagementScreen extends StatelessWidget {
  const AppointmentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Appointments'),
        backgroundColor: customBlue,
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: _buildAppointmentsList(isSmallScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', true),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', false),
            const SizedBox(width: 8),
            _buildFilterChip('Confirmed', false),
            const SizedBox(width: 8),
            _buildFilterChip('Completed', false),
            const SizedBox(width: 8),
            _buildFilterChip('Cancelled', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Implement filter logic
      },
      backgroundColor: Colors.grey[200],
      selectedColor: customLightBlue,
      checkmarkColor: customBlue,
    );
  }

  Widget _buildAppointmentsList(bool isSmallScreen) {
    return StreamBuilder<QuerySnapshot>(
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

        return ListView.builder(
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
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    Map<String, dynamic> appointment,
    String appointmentId,
    bool isSmallScreen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          appointment['patientName'] ?? 'Patient Name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Ref: ${appointment['referenceNumber']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Date', _formatDate(appointment['appointmentDate'])),
                const SizedBox(height: 8),
                _buildDetailRow('Time', appointment['appointmentTime']),
                const SizedBox(height: 8),
                _buildDetailRow('Status', appointment['status'] ?? 'pending'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      'Confirm',
                      Icons.check_circle,
                      Colors.green,
                      () => _updateAppointmentStatus(appointmentId, 'confirmed'),
                    ),
                    _buildActionButton(
                      'Cancel',
                      Icons.cancel,
                      Colors.red,
                      () => _showCancelDialog(context, appointmentId),
                    ),
                    _buildActionButton(
                      'Complete',
                      Icons.task_alt,
                      customBlue,
                      () => _updateAppointmentStatus(appointmentId, 'completed'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
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

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      final DateTime dateTime = date.toDate();
      return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    }
    return 'Invalid Date';
  }
} 