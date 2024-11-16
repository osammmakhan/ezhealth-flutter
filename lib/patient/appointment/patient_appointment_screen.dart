import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/appointment/appointment_details_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientAppointmentScreen extends StatefulWidget {
  final String? appointmentId;
  final bool isRescheduling;

  const PatientAppointmentScreen({
    super.key,
    this.appointmentId,
    this.isRescheduling = false,
  });

  @override
  State<PatientAppointmentScreen> createState() =>
      _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  List<DateTime> _generateWeekDays() {
    final now = DateTime.now();
    return List.generate(7, (index) => now.add(Duration(days: index)));
  }

  Future<List<String>> _generateTimeSlots(DateTime selectedDate) async {
    try {
      // Normalize the date to midnight
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Query appointments for the selected date
      final QuerySnapshot appointmentsSnapshot = await FirebaseFirestore
          .instance
          .collection('appointments')
          .where('appointmentDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
          .where('status', whereIn: ['pending', 'confirmed']).get();

      // Create a set of booked time slots
      final Set<String> bookedTimeSlots = appointmentsSnapshot.docs
          .map((doc) => doc['appointmentTime'] as String)
          .toSet();

      // Generate all possible time slots for the clinic hours (5 PM to 10 PM)
      final List<String> allTimeSlots = List.generate(11, (index) {
        final time =
            TimeOfDay(hour: 17 + (index ~/ 2), minute: (index % 2) * 30);
        return _formatTimeOfDay(time);
      });

      // Remove booked slots and return available ones
      return allTimeSlots
          .where((slot) => !bookedTimeSlots.contains(slot))
          .toList();
    } catch (e) {
      print('Error generating time slots: $e');
      // Return all time slots if there's an error reading appointments
      return List.generate(11, (index) {
        final time =
            TimeOfDay(hour: 17 + (index ~/ 2), minute: (index % 2) * 30);
        return _formatTimeOfDay(time);
      });
    }
  }

  // Helper method to format TimeOfDay consistently
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // Use 12-hour format with AM/PM
    return format.format(dateTime);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1024;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isRescheduling ? 'Reschedule Appointment' : 'Book Appointment',
          style: const TextStyle(color: Colors.black),
        ),
        // ... rest of AppBar code ...
      ),
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
                      _buildDoctorInfo(isSmallScreen, isMediumScreen),
                      SizedBox(
                          height: isSmallScreen
                              ? 40
                              : isMediumScreen
                                  ? 60
                                  : 80),
                      const Divider(
                          color: Colors.grey, indent: 20, endIndent: 20),
                      const SizedBox(height: 24),
                      _buildStats(isSmallScreen, isMediumScreen),
                      SizedBox(height: isSmallScreen ? 30 : 50),
                      Text(
                        widget.isRescheduling
                            ? 'Select New Date and Time'
                            : 'Book Appointment',
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
                text: widget.isRescheduling
                    ? 'Submit Reschedule Request'
                    : 'Make Appointment',
                enabled: appointmentProvider.selectedTime.isNotEmpty,
                onPressed: () =>
                    _handleProceedToPayment(context, appointmentProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(bool isSmallScreen, bool isMediumScreen) {
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Dr. Ahsan Siddiqui',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'Dentist',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: customBlue),
            Text('Hyderabad, Pakistan', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(bool isSmallScreen, bool isMediumScreen) {
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
        enlargeFactor: 0.3,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          provider.setSelectedDate(weekDays[index]);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final date = weekDays[index];
        final isSelected = provider.selectedDate.day == date.day;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: OutlinedButton(
            onPressed: () => provider.setSelectedDate(date),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor:
                  isSelected ? customLightBlue : Colors.transparent,
              side: BorderSide(
                color: isSelected ? customBlue : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
                  const SizedBox(height: 2),
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
          ),
        );
      },
    );
  }

  Map<DateTime, List<String>> _cachedTimeSlots = {};
  DateTime? _lastFetchedDate;

  Future<List<String>> _getTimeSlotsWithCache(DateTime selectedDate) async {
    // Compare only the date part, not the time
    final compareDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // Return cached results if available for the same date
    if (_lastFetchedDate != null &&
        _lastFetchedDate!.isAtSameMomentAs(compareDate) &&
        _cachedTimeSlots.containsKey(compareDate)) {
      return _cachedTimeSlots[compareDate]!;
    }

    // Fetch new time slots
    final timeSlots = await _generateTimeSlots(selectedDate);

    // Update cache
    _lastFetchedDate = compareDate;
    _cachedTimeSlots[compareDate] = timeSlots;

    return timeSlots;
  }

  Widget _buildTimePicker(
      AppointmentProvider provider, bool isSmallScreen, bool isMediumScreen) {
    return FutureBuilder<List<String>>(
      // Use the cached version instead
      future: _getTimeSlotsWithCache(provider.selectedDate),
      builder: (context, snapshot) {
        // Show previous data while loading if available
        if (snapshot.connectionState == ConnectionState.waiting) {
          final cachedDate = DateTime(
            provider.selectedDate.year,
            provider.selectedDate.month,
            provider.selectedDate.day,
          );

          if (_cachedTimeSlots.containsKey(cachedDate)) {
            return _buildTimeSlotCarousel(
              _cachedTimeSlots[cachedDate]!,
              provider,
              isSmallScreen,
              isMediumScreen,
            );
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error loading time slots. Please try again.',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          );
        }

        final timeSlots = snapshot.data ?? [];

        if (timeSlots.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No available time slots for this date',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        return _buildTimeSlotCarousel(
          timeSlots,
          provider,
          isSmallScreen,
          isMediumScreen,
        );
      },
    );
  }

  // Extract carousel building logic to a separate method
  Widget _buildTimeSlotCarousel(
    List<String> timeSlots,
    AppointmentProvider provider,
    bool isSmallScreen,
    bool isMediumScreen,
  ) {
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
        enlargeFactor: 0.3,
        enableInfiniteScroll: true,
        initialPage: timeSlots.indexOf(provider.selectedTime) != -1
            ? timeSlots.indexOf(provider.selectedTime)
            : 0,
        onPageChanged: (index, reason) {
          provider.setSelectedTime(timeSlots[index]);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        bool isSelected = provider.selectedTime == timeSlots[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: OutlinedButton(
            onPressed: () => provider.setSelectedTime(timeSlots[index]),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor:
                  isSelected ? customLightBlue : Colors.transparent,
              side: BorderSide(
                color: isSelected ? customBlue : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                timeSlots[index],
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: isSelected ? customBlue : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleProceedToPayment(
      BuildContext context, AppointmentProvider provider) {
    if (widget.isRescheduling) {
      FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .update({
        'status': 'pending',
        'requestedDate': provider.selectedDate,
        'requestedTime': provider.selectedTime,
        'updatedAt': FieldValue.serverTimestamp(),
      }).then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting reschedule request: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppointmentDetailsScreen(),
        ),
      );
    }
  }
}
