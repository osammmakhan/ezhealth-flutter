import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/appointment/patient_appointment_screen.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:ez_health/providers/home_screen_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.04; // Dynamic padding

    return Consumer2<HomeScreenProvider, AppointmentProvider>(
      builder: (context, homeProvider, appointmentProvider, child) {
        final hasAppointment = appointmentProvider.hasActiveAppointment;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    const SizedBox(height: 24),

                    // Doctor Section Title
                    Text(
                      hasAppointment ? 'Your Doctor' : 'Get Your Appointment',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDoctorCard(context, hasAppointment),

                    if (hasAppointment) ...[
                      const SizedBox(height: 24),
                      _buildAppointmentSection(context, appointmentProvider),
                      _buildWaitingList(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context, homeProvider),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fontSize = constraints.maxWidth * 0.05;
        final double avatarRadius = constraints.maxWidth * 0.06;

        return Row(
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage:
                  const AssetImage('lib/assets/images/Patient Profile.png'),
            ),
            SizedBox(width: constraints.maxWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to EZ Health! 👋',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Find your doctor and book appointments',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: fontSize * 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, bool hasAppointment) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDoctorInfo(),
                const SizedBox(height: 12),
                const Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                if (!hasAppointment) _buildAppointmentButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double imageSize = constraints.maxWidth * 0.2;
        final double fontSize = constraints.maxWidth * 0.045;

        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'lib/assets/images/Doctor Profile Picture.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dr. Osama',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DENTIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildAvailabilityIndicator(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow[700], size: 16),
                      const Text(
                        ' 4.9',
                        style: TextStyle(
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
      },
    );
  }

  Widget _buildAvailabilityIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'Available',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PatientAppointmentScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Make Appointment',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAppointmentSection(
    BuildContext context,
    AppointmentProvider appointmentProvider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fontSize = constraints.maxWidth * 0.045;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Appointment',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: constraints.maxWidth * 0.04),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Appointment at ${appointmentProvider.selectedTime}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          appointmentProvider.appointmentId,
                          style: const TextStyle(
                            color: customBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                          context,
                          'Reschedule',
                          Icons.calendar_today,
                          () {
                            appointmentProvider.startRescheduling();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PatientAppointmentScreen(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          context,
                          'Cancel',
                          Icons.close,
                          () => appointmentProvider.cancelAppointment(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaitingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Waiting List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: customLightBlue,
                  child: Text(
                    '#${(43 + index).toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      color: customBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Appointment at ${5 + (index ~/ 2)}:${index % 2 == 0 ? "00" : "30"} PM',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav(
      BuildContext context, HomeScreenProvider homeProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double iconSize = constraints.maxWidth * 0.08;
        final double fontSize = constraints.maxWidth * 0.03;

        return Container(
          decoration: BoxDecoration(
            color: customBlue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(constraints.maxWidth * 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.04,
                vertical: constraints.maxWidth * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavBarItem(
                    homeProvider,
                    0,
                    Icons.home,
                    'Home',
                    iconSize,
                    fontSize,
                  ),
                  _buildNavBarItem(
                    homeProvider,
                    1,
                    Icons.calendar_today,
                    'Appointments',
                    iconSize,
                    fontSize,
                  ),
                  _buildNavBarItem(
                    homeProvider,
                    2,
                    Icons.notifications,
                    'Notifications',
                    iconSize,
                    fontSize,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavBarItem(
    HomeScreenProvider provider,
    int index,
    IconData icon,
    String label,
    double iconSize,
    double fontSize,
  ) {
    final isSelected = provider.selectedIndex == index;
    return InkWell(
      onTap: () => provider.setSelectedIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color:
                isSelected ? customLightBlue : customLightBlue.withOpacity(0.7),
          ),
          SizedBox(height: iconSize * 0.1),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? customLightBlue
                  : customLightBlue.withOpacity(0.7),
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: label == 'Cancel' ? Colors.red[100] : customLightBlue,
        foregroundColor: label == 'Cancel' ? Colors.red : customBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
