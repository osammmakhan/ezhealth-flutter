import 'package:flutter/material.dart';
import 'package:ez_health/patient/confirmation/ticket_generator.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient_home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketGenerator = TicketGenerator();
    final referenceNumber = ticketGenerator.generateReferenceNumber();
    final ticketToken = ticketGenerator.generateTicketToken();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: customLightBlue, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: customBlue, size: 60),
              ),
              const SizedBox(height: 30),
              const Text(
                'Appointment Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'PKR 5,000',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: customBlue),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Doctor', 'Dr. Osama Khan'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Date', 'October 26, 2024'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Time', '5:30 PM'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Location', 'Hyderabad, Pakistan'),
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 15),
                    _buildDetailRow('Reference No.', referenceNumber),
                    const SizedBox(height: 15),
                    _buildDetailRow('Ticket Token', ticketToken),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen(hasAppointment: true)),
                      (route) => false,
                    );
                  },
                  child: const Text('Done', style: TextStyle(fontSize: 18, color: customLightBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
