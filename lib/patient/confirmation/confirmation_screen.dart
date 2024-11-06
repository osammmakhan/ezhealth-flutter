import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);

    // Make sure the appointment time is set
    if (appointmentProvider.selectedTime.isEmpty) {
      appointmentProvider.setSelectedTime('Your selected time here');
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildSuccessIcon(),
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildAppointmentCard(
                  appointmentProvider: appointmentProvider,
                ),
                const SizedBox(height: 40),
                _buildDoneButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100,
      height: 100,
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
      child: const Icon(
        Icons.check_circle,
        color: customBlue,
        size: 60,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Appointment Confirmed!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: customLightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'PKR 500',
            style: TextStyle(
              fontSize: 24,
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
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDoctorInfo(),
            const SizedBox(height: 24),
            _buildDetailRow('Date',
                '${appointmentProvider.selectedDate.day.toString().padLeft(2, '0')}-'
                '${appointmentProvider.selectedDate.month.toString().padLeft(2, '0')}-'
                '${appointmentProvider.selectedDate.year}'),
            const SizedBox(height: 15),
            _buildDetailRow('Time', appointmentProvider.selectedTime),
            const SizedBox(height: 15),
            _buildDetailRow('Location', 'Hyderabad, Pakistan'),
            const Divider(height: 30),
            _buildDetailRow('Reference Number', appointmentProvider.referenceNumber),
            const SizedBox(height: 15),
            _buildDetailRow('Ticket Token', appointmentProvider.appointmentId),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'lib/assets/images/Doctor Profile Picture.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Osama Khan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return HorizontalBtn(
      onPressed: () {
        // Get the provider but DON'T generate a new appointment ID
        final provider = Provider.of<AppointmentProvider>(context, listen: false);

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