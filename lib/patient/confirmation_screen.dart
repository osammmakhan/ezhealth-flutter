import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = screenSize.width < 600;

        return Scaffold(
          body: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(provider.appointmentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final appointmentData =
                    snapshot.data?.data() as Map<String, dynamic>?;
                if (appointmentData == null) {
                  return const Center(child: Text('Appointment not found'));
                }

                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isSmallScreen ? double.infinity : 600,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: isSmallScreen ? 40 : 60),
                            _buildSuccessIcon(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 30 : 40),
                            _buildHeader(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 40 : 50),
                            _buildAppointmentCard(
                              appointmentProvider: provider,
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: isSmallScreen ? 40 : 50),
                            _buildDoneButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessIcon(bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 100 : 120,
      height: isSmallScreen ? 100 : 120,
      decoration: BoxDecoration(
        color: customLightBlue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.check_circle,
        color: customBlue,
        size: isSmallScreen ? 60 : 72,
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        Text(
          'Appointment Confirmed!',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 8 : 12
              ),
          decoration: BoxDecoration(
            color: customLightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'PKR 500',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required AppointmentProvider appointmentProvider,
    required bool isSmallScreen,
  }) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentProvider.appointmentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointmentData = snapshot.data?.data() as Map<String, dynamic>?;
        if (appointmentData == null) {
          return const Center(child: Text('Appointment not found'));
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
            child: Column(
              children: [
                _buildDoctorInfo(isSmallScreen),
                SizedBox(height: isSmallScreen ? 24 : 32),
                _buildDetailRow(
                  'Date',
                  _formatDate(appointmentData['appointmentDate'] as Timestamp),
                  isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 15 : 20),
                _buildDetailRow(
                  'Time',
                  appointmentData['appointmentTime'] as String,
                  isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 15 : 20),
                _buildDetailRow('Location', 'Hyderabad, Pakistan', isSmallScreen),
                Divider(height: isSmallScreen ? 30 : 40),
                _buildDetailRow(
                  'Reference Number',
                  appointmentData['referenceNumber'] as String,
                  isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 15 : 20),
                _buildDetailRow(
                  'Token Number',
                  appointmentData['appointmentId'] as String,
                  isSmallScreen,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Widget _buildDoctorInfo(bool isSmallScreen) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'lib/assets/images/Doctor Profile Picture.png',
            width: isSmallScreen ? 60 : 80,
            height: isSmallScreen ? 60 : 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: isSmallScreen ? 16 : 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Osama Khan',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: isSmallScreen ? 16 : 20 ),
                  const Text(
                    ' 4.9',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' • DENTIST',
                    style: TextStyle(
                      color: customBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return HorizontalBtn(
      onPressed: () {
        // Get the provider but DON'T generate a new appointment ID
        final provider =
            Provider.of<AppointmentProvider>(context, listen: false);

        // Add a print statement to verify the state
        print('Appointment ID: ${provider.appointmentId}');

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      },
      text: 'Done',
    );
  }
}