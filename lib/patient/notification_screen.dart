import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ez_health/assets/constants/constants.dart';

class NotificationScreen extends StatelessWidget {
  final bool isAdmin;
  
  const NotificationScreen({
    super.key,
    this.isAdmin = false,  // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Modify the stream to filter based on isAdmin
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: isAdmin ? 'admin' : FirebaseAuth.instance.currentUser?.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading notifications',
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index].data() as Map<String, dynamic>;
              final notificationId = notifications[index].id;
              final isUnread = !(notification['read'] ?? false);

              // Mark notification as read when viewed
              if (isUnread) {
                FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(notificationId)
                    .update({
                  'read': true,
                  'readAt': FieldValue.serverTimestamp(),
                });
              }

              return Card(
                elevation: isUnread ? 2 : 1,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isUnread ? customBlue.withOpacity(0.3) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: _buildNotificationIcon(notification['type']),
                  title: Text(
                    notification['message'] ?? 'New Notification',
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _formatTimestamp(notification['createdAt']),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Handle notification tap - navigate to relevant screen
                    _handleNotificationTap(context, notification);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Update the notification icon logic to include admin-specific icons
  Widget _buildNotificationIcon(String? type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'appointment_confirmed':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'appointment_cancelled':
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      case 'appointment_completed':
        icon = Icons.task_alt;
        color = Colors.blue;
        break;
      case 'reschedule_request':
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      case 'new_appointment':  // Admin notification
        icon = Icons.calendar_today;
        color = customBlue;
        break;
      default:
        icon = Icons.notifications_outlined;
        color = customBlue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    final DateTime date = timestamp is Timestamp 
        ? timestamp.toDate() 
        : DateTime.now();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd, yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Update the notification tap handler to handle admin-specific actions
  void _handleNotificationTap(BuildContext context, Map<String, dynamic> notification) {
    // TODO: Implement navigation based on notification type and data
    // For example, navigate to appointment details screen if it's an appointment notification
    print('Notification tapped: ${notification['type']}');
  }
} 