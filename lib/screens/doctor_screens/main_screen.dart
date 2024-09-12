import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorProfile(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Current Appointment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CurrentAppointmentCard(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Upcoming Appointments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: AppointmentList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.email), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
        ],
      ),
    );
  }
}

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                AssetImage('lib/assets/images/Doctor Profile Picture.png'),
          ),
          SizedBox(width: 8),
          Text(
            'Dr Osama Khan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CurrentAppointmentCard extends StatefulWidget {
  const CurrentAppointmentCard({super.key});

  @override
  _CurrentAppointmentCardState createState() => _CurrentAppointmentCardState();
}

class _CurrentAppointmentCardState extends State<CurrentAppointmentCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Jan 1, 2024 - 5:00 PM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'lib/assets/images/Patient Profile.png',
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
                        'Syed Ali Shah',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      ProblemDescription(
                        problem:
                            'My jaw clicks and feels stiff, especially in the mornings.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(
                      icon: Icons.confirmation_number,
                      label: 'Booking ID:',
                      value: '2101BSCS017'),
                  SizedBox(height: 8),
                  InfoRow(icon: Icons.cake, label: 'Age:', value: '23'),
                  SizedBox(height: 8),
                  InfoRow(
                      icon: Icons.confirmation_number,
                      label: 'Token:',
                      value: '001'),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
                backgroundColor: customBlue,
                foregroundColor: Colors.white,
              ),
              child: Text(_isExpanded ? 'Less Info' : 'More Info'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void _showMoreInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Age: 23', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Token: 001', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    },
  );
}

class ProblemDescription extends StatelessWidget {
  final String problem;

  const ProblemDescription({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          const TextSpan(
            text: 'Problem: ',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: problem),
        ],
      ),
    );
  }
}

class BookingID extends StatelessWidget {
  final String id;

  const BookingID({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('Booking ID: $id', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. You would typically use a ListView.builder here
    // with actual appointment data.
    return ListView(
      children: const [
        AppointmentCard(
          name: 'Jane Doe',
          problem:
              'Experiencing sharp pain in my lower left molar whenever I chew.',
          time: '5:00 PM',
        ),
        AppointmentCard(
          name: 'Sami Shaikh',
          problem:
              'My gums bleed when I brush. They feel swollen and sensitive.',
          time: '5:30 PM',
        ),
        AppointmentCard(
          name: 'Sajan Dhandhav',
          problem:
              "A piece of my tooth broke off while eating. It's uncomfortable.",
          time: '6:00 PM',
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String problem;
  final String time;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.problem,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/patient_profile.png'),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: ProblemDescription(problem: problem),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: Text('Appointment at $time'),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow(
      {super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label ', style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
