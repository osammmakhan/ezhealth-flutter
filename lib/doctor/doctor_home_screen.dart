import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ez_health/appointment_details_screen.dart';
import 'package:ez_health/auth.dart';
import 'package:intl/intl.dart';
import 'package:ez_health/notification_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  String _selectedTab = 'Upcoming';
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.04;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                _buildCurrentAppointment(screenSize),
                const SizedBox(height: 16),
                _buildUpcomingAppointments(screenSize),
              ],
            ),
          ),
        ),
      ),
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
                        backgroundImage: const AssetImage('lib/assets/images/Doctor Profile Picture.png'),
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
                    () {
                      _showSignOutConfirmation(context);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading...');
                    }
                    final userData = snapshot.data?.data() as Map<String, dynamic>?;
                    final doctorName = userData?['name'] ?? 'Doctor';
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, Dr. $doctorName',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your patients are waiting for you',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  },
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
                              builder: (context) => const NotificationScreen(isAdmin: false),
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
      onTap: onTap,
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

                  // Navigate to login screen
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

  Widget _buildCurrentAppointment(Size screenSize) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'in_progress')
          .limit(3)
          .orderBy('startedAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Appointment',
              style: TextStyle(
                fontSize: screenSize.width < 600 ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _buildAppointmentCard(
                data,
                doc.id,
                0,
                screenSize,
                isCurrentAppointment: true,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingAppointments(Size screenSize) {
    // Get start and end of current date
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton('Upcoming', screenSize),
              ),
              Expanded(
                child: _buildTabButton('Completed', screenSize),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('status', isEqualTo: _selectedTab == 'Upcoming' ? 'confirmed' : 'completed')
              .where('appointmentDate',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
                  isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
              .orderBy('appointmentDate')
              .orderBy('appointmentTime')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No ${_selectedTab.toLowerCase()} appointments for today',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: screenSize.width < 600 ? 14 : 16,
                  ),
                ),
              );
            }

            // Sort appointments to prioritize emergency ones
            final sortedAppointments = List.from(snapshot.data!.docs);
            sortedAppointments.sort((a, b) {
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

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedAppointments.length,
              itemBuilder: (context, index) {
                final doc = sortedAppointments[index];
                final data = doc.data() as Map<String, dynamic>;
                return _buildAppointmentCard(
                  data,
                  doc.id,
                  index,
                  screenSize,
                  isCurrentAppointment: false,
                  isCompleted: _selectedTab == 'Completed',
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabButton(String title, Size screenSize) {
    final isSelected = _selectedTab == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? customBlue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? customBlue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: screenSize.width < 600 ? 16 : 18,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    Map<String, dynamic> data,
    String appointmentId,
    int index,
    Size screenSize, {
    bool isCurrentAppointment = false,
    bool isCompleted = false,
  }) {
    if (isCompleted) {
      return Card(
        elevation: isCurrentAppointment ? 2 : 1,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isCurrentAppointment 
                ? customBlue.withOpacity(0.3)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailsScreen(
                    appointmentId: appointmentId,
                    isConfirmationScreen: false,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: customLightBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: customBlue,
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
                                'Queue',
                                style: TextStyle(
                                  color: customBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: const AssetImage('lib/assets/images/Patient Profile Picture.png'),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              data['patientName'] ?? 'Patient Name',
                              style: TextStyle(
                                fontSize: screenSize.width < 600 ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              data['appointmentTime'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(data['appointmentDate']),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Card(
      elevation: isCurrentAppointment ? 2 : 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrentAppointment 
              ? customBlue.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailsScreen(
                      appointmentId: appointmentId,
                      isConfirmationScreen: false,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: data['isEmergency'] == true ? Colors.red.shade50 : customLightBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: data['isEmergency'] == true ? Colors.red : customBlue,
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
                                  data['isEmergency'] == true ? 'Emergency' : 'Queue',
                                  style: TextStyle(
                                    color: data['isEmergency'] == true ? Colors.red : customBlue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: const AssetImage('lib/assets/images/Patient Profile Picture.png'),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                data['patientName'] ?? 'Patient Name',
                                style: TextStyle(
                                  fontSize: screenSize.width < 600 ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data['appointmentTime'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(data['appointmentDate']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          isCurrentAppointment 
                              ? 'End Appointment' 
                              : 'Start Appointment',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          isCurrentAppointment
                              ? 'Are you sure you want to end this appointment?'
                              : 'Are you sure you want to start this appointment?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close dialog
                              try {
                                await FirebaseFirestore.instance
                                    .collection('appointments')
                                    .doc(appointmentId)
                                    .update({
                                  'status': isCurrentAppointment ? 'completed' : 'in_progress',
                                  isCurrentAppointment ? 'completedAt' : 'startedAt': 
                                      FieldValue.serverTimestamp(),
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isCurrentAppointment
                                            ? 'Appointment ended successfully'
                                            : 'Appointment started successfully',
                                      ),
                                      backgroundColor: customBlue,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: isCurrentAppointment ? Colors.red : customBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentAppointment ? Colors.red[400] : customBlue,
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.width < 600 ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isCurrentAppointment ? 'End Appointment' : 'Start Appointment',
                  style: TextStyle(
                    fontSize: screenSize.width < 600 ? 16 : 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('MMM dd, yyyy').format(date.toDate());
    }
    return 'Date not available';
  }
}