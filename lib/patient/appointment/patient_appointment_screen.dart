import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/appointment/appointment_details_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:ez_health/providers/appointment_provider.dart';

class PatientAppointmentScreen extends StatefulWidget {
  const PatientAppointmentScreen({super.key});

  @override
  State<PatientAppointmentScreen> createState() =>
      _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  List<DateTime> _generateWeekDays() {
    final now = DateTime.now();
    return List.generate(7, (index) => now.add(Duration(days: index)));
  }

  List<String> _generateTimeSlots() {
    return List.generate(11, (index) {
      final time = TimeOfDay(hour: 17 + (index ~/ 2), minute: (index % 2) * 30);
      return time.format(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1024;
    // final isLargeScreen = screenSize.width >= 1024;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen
                        ? 16.0
                        : isMediumScreen
                            ? 24.0
                            : 32.0,
                    vertical: isSmallScreen ? 16.0 : 24.0,
                  ),
                  child: Column(
                    children: [
                      _buildResponsiveDoctorInfo(isSmallScreen, isMediumScreen),
                      SizedBox(
                          height: isSmallScreen
                              ? 40
                              : isMediumScreen
                                  ? 60
                                  : 80),
                      const Divider(
                          color: Colors.grey, indent: 20, endIndent: 20),
                      const SizedBox(height: 24),
                      _buildResponsiveStats(isSmallScreen, isMediumScreen),
                      SizedBox(height: isSmallScreen ? 30 : 50),
                      Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 30 : 50),
                      _buildDatePicker(
                          appointmentProvider, isSmallScreen, isMediumScreen),
                      const SizedBox(height: 10),
                      _buildTimePicker(
                          appointmentProvider, isSmallScreen, isMediumScreen),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen
                    ? 16
                    : isMediumScreen
                        ? 24
                        : 32,
                vertical: isSmallScreen ? 16 : 24,
              ),
              child: HorizontalBtn(
                text: 'Make Appointment',
                nextScreen: const AppointmentDetailsScreen(),
                enabled: appointmentProvider.selectedTime.isNotEmpty &&
                    appointmentProvider.selectedDate != DateTime(0),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveDoctorInfo(bool isSmallScreen, bool isMediumScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isSmallScreen) {
          return Column(
            children: [
              const CircleAvatar(
                backgroundImage:
                    AssetImage('lib/assets/images/Doctor Profile Picture.png'),
                radius: 60,
              ),
              const SizedBox(height: 16),
              _buildDoctorDetails(),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage(
                    'lib/assets/images/Doctor Profile Picture.png'),
                radius: isMediumScreen ? 60 : 70,
              ),
              const SizedBox(width: 24),
              _buildDoctorDetails(),
            ],
          );
        }
      },
    );
  }

  Widget _buildDoctorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Dr. Osama Khan',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Dentist',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: customBlue),
            Text('Hyderabad, Pakistan', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildResponsiveStats(bool isSmallScreen, bool isMediumScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(Icons.group, '7,500+', 'Patients', isSmallScreen),
        _buildStatItem(Icons.work, '10+', 'Years Exp.', isSmallScreen),
        _buildStatItem(Icons.star, '4.9', 'Ratings', isSmallScreen),
        _buildStatItem(Icons.chat, '4,956', 'Reviews', isSmallScreen),
      ],
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 80 : 100,
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 40 : 50,
            height: isSmallScreen ? 40 : 50,
            decoration: const BoxDecoration(
              color: customLightBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  Icon(icon, color: customBlue, size: isSmallScreen ? 20 : 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: customBlue,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 12 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
      AppointmentProvider provider, bool isSmallScreen, bool isMediumScreen) {
    final weekDays = _generateWeekDays();

    return CarouselSlider.builder(
      itemCount: weekDays.length,
      options: CarouselOptions(
        height: isSmallScreen
            ? 70
            : isMediumScreen
                ? 80
                : 100,
        viewportFraction: isSmallScreen
            ? 0.35
            : isMediumScreen
                ? 0.25
                : 0.2,
        enlargeCenterPage: true,
        enlargeFactor: isSmallScreen ? 0.2 : 0.3,
        onPageChanged: (index, reason) {
          provider.setSelectedDate(weekDays[index]);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final date = weekDays[index];
        final isSelected = provider.selectedDate.day == date.day;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4),
          child: OutlinedButton(
            onPressed: () => provider.setSelectedDate(date),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor:
                  isSelected ? customLightBlue : Colors.transparent,
              side: BorderSide(
                color: isSelected ? customBlue : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 12,
                vertical: isSmallScreen ? 4 : 8,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: isSelected ? customBlue : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMM').format(date),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: isSelected ? customBlue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimePicker(
      AppointmentProvider provider, bool isSmallScreen, bool isMediumScreen) {
    final timeSlots = _generateTimeSlots();

    return CarouselSlider.builder(
      itemCount: timeSlots.length,
      options: CarouselOptions(
        height: isSmallScreen
            ? 50
            : isMediumScreen
                ? 60
                : 80,
        viewportFraction: isSmallScreen
            ? 0.35
            : isMediumScreen
                ? 0.25
                : 0.2,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          provider.setSelectedTime(timeSlots[index]);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        bool isSelected = provider.selectedTime == timeSlots[index];
        return OutlinedButton(
          onPressed: () => provider.setSelectedTime(timeSlots[index]),
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: isSelected ? customLightBlue : Colors.transparent,
            side: BorderSide(
              color: isSelected ? customBlue : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 12,
            ),
          ),
          child: Text(
            timeSlots[index],
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: isSelected ? customBlue : Colors.black,
            ),
          ),
        );
      },
    );
  }
}
