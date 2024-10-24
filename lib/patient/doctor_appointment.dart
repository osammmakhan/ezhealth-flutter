import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/appointment_details.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

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
                      _buildDentistInfo(),
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
                      _buildDatePicker(),
                      const SizedBox(height: 10),
                      _buildTimePicker(),
                    ],
                  ),
                ),
              ),
            ),
            //Make Appointment Button
            HorizontalBtn(
              text: 'Make Appointment',
              nextScreen: const AppointmentDetailsScreen(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDentistInfo() {
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
            Text(
              'Dentist',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: customBlue),
                Text(
                  'Hyderabad, Pakistan',
                  style: TextStyle(color: Colors.grey),
                ),
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
            child: Icon(
              icon,
              color: customBlue,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: customBlue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final weekDays = _generateWeekDays();
    return CarouselSlider.builder(
      itemCount: weekDays.length,
      options: CarouselOptions(
        height: 80,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            _selectedDateIndex = index;
          });
        },
      ),
      itemBuilder: (context, index, realIndex) {
        return _buildDateButton(weekDays[index], index);
      },
    );
  }

  Widget _buildTimePicker() {
    final timeSlots = _generateTimeSlots();
    return CarouselSlider.builder(
      itemCount: timeSlots.length,
      options: CarouselOptions(
        height: 60,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            _selectedTimeIndex = index;
          });
        },
      ),
      itemBuilder: (context, index, realIndex) {
        return _buildTimeButton(timeSlots[index], index == _selectedTimeIndex);
      },
    );
  }

  Widget _buildDateButton(DateTime date, int index) {
    bool isSelected = index == _selectedDateIndex;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedDateIndex = index;
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side:
            BorderSide(color: isSelected ? customBlue : Colors.grey, width: 2),
        backgroundColor: isSelected ? customLightBlue : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(date),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d MMM').format(date),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String time, bool isSelected) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedTimeIndex = _generateTimeSlots().indexOf(time);
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side:
            BorderSide(color: isSelected ? customBlue : Colors.grey, width: 2),
        backgroundColor: isSelected ? customLightBlue : Colors.transparent,
      ),
      child: Text(
        time,
        style: TextStyle(
            fontSize: 16, color: isSelected ? customBlue : Colors.black),
      ),
    );
  }
}
