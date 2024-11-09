import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_health/assets/constants/constants.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({super.key});

  @override
  State<AppointmentManagementScreen> createState() => _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState extends State<AppointmentManagementScreen> {
  String _selectedStatus = 'all';
  Map<String, bool> _expandedSections = {
    'pending': true,
    'confirmed': true,
    'in_process': true,
    'completed': false,
    'cancelled': false,
  };

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
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', 'pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Confirmed', 'confirmed'),
            const SizedBox(width: 8),
            _buildFilterChip('In Process', 'in_process'),
            const SizedBox(width: 8),
            _buildFilterChip('Completed', 'completed'),
            const SizedBox(width: 8),
            _buildFilterChip('Cancelled', 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedStatus = selected ? status : 'all';
        });
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
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data?.docs ?? [];
        
        final Map<String, List<QueryDocumentSnapshot>> groupedAppointments = {
          'pending': [],
          'confirmed': [],
          'in_process': [],
          'completed': [],
          'cancelled': [],
        };

        for (var doc in appointments) {
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'] as String? ?? 'pending';
          final isStarted = data['isStarted'] as bool? ?? false;
          
          if (status == 'confirmed' && isStarted) {
            groupedAppointments['in_process']!.add(doc);
          } else {
            groupedAppointments[status]?.add(doc);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildExpandableSection(
                'Pending',
                groupedAppointments['pending']!,
                Colors.orange,
                isSmallScreen,
              ),
              _buildExpandableSection(
                'Confirmed',
                groupedAppointments['confirmed']!,
                Colors.green,
                isSmallScreen,
              ),
              _buildExpandableSection(
                'In Process',
                groupedAppointments['in_process']!,
                customBlue,
                isSmallScreen,
              ),
              _buildExpandableSection(
                'Completed',
                groupedAppointments['completed']!,
                Colors.grey,
                isSmallScreen,
              ),
              _buildExpandableSection(
                'Cancelled',
                groupedAppointments['cancelled']!,
                Colors.red,
                isSmallScreen,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<QueryDocumentSnapshot> appointments,
    Color color,
    bool isSmallScreen,
  ) {
    if (appointments.isEmpty) return const SizedBox.shrink();

    final sectionKey = title.toLowerCase().replaceAll(' ', '_');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[sectionKey] = !(_expandedSections[sectionKey] ?? false);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$title (${appointments.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(
                    _expandedSections[sectionKey] ?? false
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
          if (_expandedSections[sectionKey] ?? false)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final doc = appointments[index];
                return _buildAppointmentCard(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                  isSmallScreen,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Token: ${appointment['tokenNumber']?.toString().padLeft(2, '0') ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: customBlue),
            ),
            Text(
              'Ref: ${appointment['referenceNumber']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
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
                      () => _showCancelDialog(appointmentId),
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

  Future<void> _showCancelDialog(String appointmentId) async {
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