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

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorInfo(),
                      const SizedBox(height: 60),
                      const Divider(
                          color: Colors.grey, indent: 20, endIndent: 20),
                      const SizedBox(height: 24),
                      _buildStats(),
                      const SizedBox(height: 50),
                      const Text(
                        'Book Appointment',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 50),
                      _buildDatePicker(appointmentProvider),
                      const SizedBox(height: 10),
                      _buildTimePicker(appointmentProvider),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HorizontalBtn(
                  text: 'Make Appointment',
                  nextScreen: const AppointmentDetailsScreen(),
                  enabled: appointmentProvider.selectedTime.isNotEmpty &&
                      appointmentProvider.selectedDate != DateTime(0),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(AppointmentProvider provider) {
    final weekDays = _generateWeekDays();
    return CarouselSlider.builder(
      itemCount: weekDays.length,
      options: CarouselOptions(
        height: 80,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: (index, reason) {
          provider.setSelectedDate(weekDays[index]);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final date = weekDays[index];
        final isSelected = provider.selectedDate.day == date.day;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? customBlue : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMM').format(date),
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildTimePicker(AppointmentProvider provider) {
    final timeSlots = _generateTimeSlots();
    return CarouselSlider.builder(
      itemCount: timeSlots.length,
      options: CarouselOptions(
        height: 60,
        viewportFraction: 0.3,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            timeSlots[index],
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? customBlue : Colors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorInfo() {
    return const Row(
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage('lib/assets/images/Doctor Profile Picture.png'),
          minRadius: 70,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Osama Khan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text('Dentist', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: customBlue),
                Text('Hyderabad, Pakistan',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(Icons.group, '7,500+', 'Patients'),
        _buildStatItem(Icons.work, '10+', 'Years Exp.'),
        _buildStatItem(Icons.star, '4.9', 'Ratings'),
        _buildStatItem(Icons.chat, '4,956', 'Reviews'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: customLightBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: customBlue, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: customBlue)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
