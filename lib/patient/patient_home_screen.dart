import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/appointment/patient_appointment_screen.dart';
import 'package:ez_health/providers/appointment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ez_health/appointment_details_screen.dart';
import 'package:ez_health/auth.dart';
import 'package:ez_health/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize streams after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AppointmentProvider>(context, listen: false)
            .initializeStreams();

        // Set initialized after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.04;

    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    _buildAppointmentSection(context, provider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 350;
          final avatarSize = isSmallScreen ? 40.0 : 50.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: customBlue.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundImage: const AssetImage(
                            'lib/assets/images/Patient Profile Picture.png'),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: customBlue.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: isSmallScreen ? 16 : 20,
                            color: customBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  _buildPopupMenuItem(
                    'View Profile',
                    Icons.person_outline,
                    () {
                      // Add navigation to profile screen
                    },
                  ),
                  _buildPopupMenuItem(
                    'Settings',
                    Icons.settings_outlined,
                    () {
                      // Add navigation to settings screen
                    },
                  ),
                  const PopupMenuDivider(),
                  _buildPopupMenuItem(
                    'Sign Out',
                    Icons.logout_outlined,
                    () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        // Navigate to login screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const AuthScreen()),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Error signing out. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    isDestructive: true,
                  ),
                ],
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome to EZ Health! 👋',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find your doctor and book appointments',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isSmallScreen ? 14 : 16,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .where('read', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        iconSize: 28,
                        color: customBlue,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      onTap: () {
        // Delay the execution to avoid BuildContext issues
        Future.delayed(Duration.zero, () {
          if (text == 'Sign Out') {
            _showSignOutConfirmation(context);
          } else {
            onTap();
          }
        });
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red : Colors.grey[700],
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDestructive ? Colors.red : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to sign out?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  
                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully signed out'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Navigate to login screen (keeping existing logic)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error signing out. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, bool hasAppointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            'Experienced dentist specializing in preventive care and cosmetic dentistry.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          if (!hasAppointment)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientAppointmentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customBlue,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_today_outlined, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Make Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Dr. Ahsan',
                    style: TextStyle(
                      fontSize: 20,
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
    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: provider.isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientAppointmentScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: customBlue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: provider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  'Make Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAppointmentSection(
      BuildContext context, AppointmentProvider provider) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('status', whereIn: ['confirmed', 'pending', 'cancelled'])
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check for reschedule request or pending appointment
        if (provider.hasRescheduleRequest) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Doctor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDoctorCard(context, true),
              _buildRescheduleRequestMessage(),
            ],
          );
        }

        // Even if there's an error or no data, show the initial home screen
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return _buildInitialHomeScreen(context);
        }

        // Get the most recent active appointment
        final activeAppointment = snapshot.data?.docs.first;
        if (activeAppointment != null) {
          final appointmentData =
              activeAppointment.data() as Map<String, dynamic>;
          final status = appointmentData['status'] as String;

          // Update the provider without notifying listeners
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.setAppointmentIdSilently(activeAppointment.id);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Doctor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDoctorCard(context, status != 'cancelled'),
              if (status == 'pending')
                _buildPendingAppointmentMessage(appointmentData),
              if (status == 'cancelled' &&
                  appointmentData['cancelledBy'] == 'admin')
                _buildAdminCancelledMessage(appointmentData),
              if (status == 'confirmed')
                _buildWaitingList(provider.appointmentId),
            ],
          );
        }

        return _buildInitialHomeScreen(context);
      },
    );
  }

  Widget _buildRescheduleRequestMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: customLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: customBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.pending_actions,
            size: 48,
            color: customBlue.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Reschedule Request Pending',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your request to reschedule the appointment is under review. Once confirmed, you\'ll see your updated appointment details here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialHomeScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get Your Appointment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDoctorCard(context, false),
      ],
    );
  }

  Widget _buildWaitingList(String? currentAppointmentId) {
    // Early return if no appointment ID
    if (currentAppointmentId == null || currentAppointmentId.isEmpty) {
      return const Center(
        child: Text(
          'No active appointment found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Waitlist',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(currentAppointmentId)
              .snapshots(),
          builder: (context, appointmentSnapshot) {
            if (!appointmentSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final appointmentData =
                appointmentSnapshot.data?.data() as Map<String, dynamic>?;
            if (appointmentData == null) return const SizedBox.shrink();

            // Get the appointment date
            final appointmentDate =
                (appointmentData['appointmentDate'] as Timestamp).toDate();
            final startOfDay = DateTime(appointmentDate.year,
                appointmentDate.month, appointmentDate.day);
            final endOfDay = DateTime(appointmentDate.year,
                appointmentDate.month, appointmentDate.day, 23, 59, 59);

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('status', isEqualTo: 'confirmed')
                  .where('appointmentDate', 
                      isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
                      isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
                  .orderBy('appointmentDate')
                  .orderBy('appointmentTime')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading waiting list',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Sort appointments to prioritize emergency ones
                final appointments = List.from(snapshot.data?.docs ?? []);
                appointments.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  
                  // First sort by emergency status
                  final aEmergency = aData['isEmergency'] ?? false;
                  final bEmergency = bData['isEmergency'] ?? false;
                  
                  if (aEmergency != bEmergency) {
                    return aEmergency ? -1 : 1;
                  }
                  
                  // Then sort by appointment time if emergency status is the same
                  final aTime = aData['appointmentTime'] as String;
                  final bTime = bData['appointmentTime'] as String;
                  return aTime.compareTo(bTime);
                });

                if (appointments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No appointments scheduled for this date',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                // Find the index of current user's appointment
                final currentUserIndex = appointments
                    .indexWhere((doc) => doc.id == currentAppointmentId);

                // Calculate wait time once for the current user
                String getCurrentUserWaitTime() {
                  if (currentUserIndex == -1) return '';
                  if (currentUserIndex == 0) return 'Next in line';

                  final waitTimeMinutes = currentUserIndex * 30;

                  if (waitTimeMinutes >= 60) {
                    final hours = waitTimeMinutes ~/ 60;
                    final minutes = waitTimeMinutes % 60;

                    if (minutes == 0) {
                      return 'Estimated wait: $hours ${hours == 1 ? 'Hour' : 'Hours'}';
                    } else {
                      return 'Estimated wait: $hours ${hours == 1 ? 'Hour' : 'Hours'} $minutes Minutes';
                    }
                  }

                  return 'Estimated wait: $waitTimeMinutes Minutes';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentUserIndex > 0)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          getCurrentUserWaitTime(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: customBlue,
                          ),
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment =
                            appointments[index].data() as Map<String, dynamic>;
                        final appointmentId = appointments[index].id;
                        final isCurrentUser =
                            currentAppointmentId == appointmentId;
                        final userId = appointment['userId'] as String?;
                        final isCurrentUserAppointment =
                            userId == FirebaseAuth.instance.currentUser?.uid;

                        return Card(
                          color: isCurrentUser ? Colors.blue.shade50 : Colors.white,
                          elevation: isCurrentUser ? 2 : 1,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isCurrentUser
                                  ? customBlue.withOpacity(0.3)
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: isCurrentUserAppointment
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentDetailsScreen(
                                                appointmentId: appointmentId,
                                                isConfirmationScreen: true,
                                            ),
                                      ),
                                    );
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  // Top Row: Queue Number and Time
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: appointment['isEmergency'] == true 
                                            ? Colors.red.shade50 
                                            : customBlue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: appointment['isEmergency'] == true 
                                                ? Colors.red 
                                                : customBlue,
                                              radius: 12,
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              appointment['isEmergency'] == true 
                                                ? 'Emergency' 
                                                : 'Queue',
                                              style: TextStyle(
                                                color: appointment['isEmergency'] == true 
                                                  ? Colors.red 
                                                  : customBlue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        appointment['appointmentTime'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentUserAppointment
                                              ? customBlue
                                              : Colors.grey[800],
                                        ),
                                      ),
                                      if (isCurrentUserAppointment) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Middle Row: Date and Status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDate(
                                            appointment['appointmentDate']),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      if (isCurrentUserAppointment)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: customBlue.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Your Appointment',
                                            style: TextStyle(
                                              color: customBlue,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  if (isCurrentUserAppointment) ...[
                                    const SizedBox(height: 12),
                                    // Buttons Row
                                    Consumer<AppointmentProvider>(
                                      builder: (context, provider, child) =>
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  _showRescheduleDialog(
                                                context,
                                                appointmentId,
                                                provider,
                                              ),
                                              icon: const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 18,
                                                color: customBlue,
                                              ),
                                              label: const Text(
                                                'Reschedule',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: customBlue,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: customBlue,
                                                backgroundColor:
                                                    const Color(0x8AFFFFFF),
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                alignment: Alignment.center,
                                                side: const BorderSide(
                                                  color: customBlue,
                                                  width: 0.5,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  _showCancelConfirmation(
                                                context,
                                                appointmentId,
                                                provider,
                                              ),
                                              icon: const Icon(
                                                Icons.close,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                alignment: Alignment.center,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPendingAppointmentMessage(Map<String, dynamic> appointmentData) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: customLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: customBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.pending_actions,
            size: 48,
            color: customBlue.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Appointment Request Pending',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your appointment request for ${appointmentData['appointmentTime']} on ${_formatDate(appointmentData['appointmentDate'])} is under review. You\'ll be notified once it\'s confirmed.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCancelledMessage(Map<String, dynamic> appointmentData) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 48,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Appointment Cancelled by Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your appointment for ${appointmentData['appointmentTime']} on ${_formatDate(appointmentData['appointmentDate'])} has been cancelled by the admin. Please book a new appointment or contact the clinic for more information.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('MMM dd, yyyy').format(date.toDate());
    }
    return 'Date not available';
  }

  void _showCancelConfirmation(BuildContext context, String appointmentId,
      AppointmentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                await provider.cancelAppointment(appointmentId);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error cancelling appointment: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(BuildContext context, String appointmentId,
      AppointmentProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientAppointmentScreen(
          appointmentId: appointmentId,
          isRescheduling: true,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        Color backgroundColor;
        Color textColor;
        
        switch (label) {
          case 'Cancel':
            backgroundColor = const Color(0xFFEF5350); // Red
            textColor = Colors.white;
            break;
          case 'Reschedule':
            backgroundColor = Colors.orange;
            textColor = Colors.white;
            break;
          default:
            backgroundColor = customBlue;
            textColor = Colors.white;
        }

        return ElevatedButton(
          onPressed: provider.isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: backgroundColor.withOpacity(0.5),
            disabledForegroundColor: textColor.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.isLoading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(
                  label == 'Cancel' 
                    ? Icons.cancel_outlined 
                    : label == 'Reschedule' 
                      ? Icons.schedule 
                      : icon,
                  size: 20,
                  color: textColor,
                ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}