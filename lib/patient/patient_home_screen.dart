import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient.dart';

class HomeScreen extends StatefulWidget {
  final bool hasAppointment;

  const HomeScreen({
    super.key,
    this.hasAppointment = false,
});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default to home tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('lib/assets/images/user_profile.png'),),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to EZ Health! 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,),),
                        Text(
                          'Find your doctor and book appointments',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,),),],),],),
                const SizedBox(height: 24),

                // Doctor Section Title
                Text(
                  widget.hasAppointment ? 'Your Doctor' : 'Get Your Appointment',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,),),
                const SizedBox(height: 16),

                // Doctor Card
                Card(
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
                            Row(
                              children: [
                                // Doctor Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'lib/assets/images/Doctor Profile Picture.png',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,),),
                                const SizedBox(width: 16),
                                // Doctor Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Dr. Osama',
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
                                                fontWeight: FontWeight.bold,),),),],),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green[50],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
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
                                                    fontSize: 12,),),],),),],),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow[700], size: 16),
                                          const Text(
                                            ' 4.9',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,),),],),],),),],),
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
                                fontSize: 14,),),
                            const SizedBox(height: 16),
                            if (!widget.hasAppointment)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PatientAppointmentScreen(),
                                    ),);},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),),),
                                child: const Text(
                                  'Make Appointment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,),),),],),),],),),

                // Appointment Section (only when hasAppointment is true)
                if (widget.hasAppointment) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Your Appointment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 16),
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Appointment at 5:00 PM',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,),),
                              Text(
                                '#042',
                                style: TextStyle(
                                  color: customBlue,
                                  fontWeight: FontWeight.bold,),),],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActionButton(
                                context,
                                'Reschedule',
                                Icons.calendar_today,
                                () {
                                  // Handle reschedule
                                },),
                              _buildActionButton(
                                context,
                                'Cancel',
                                Icons.close,
                                () {
                                  // Handle cancel
                                },),],),],),),),

                  // Waiting List
                  const SizedBox(height: 24),
                  const Text(
                    'Waiting List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),),
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
                                fontWeight: FontWeight.bold,),),),
                          title: Text(
                            'Appointment at ${5 + (index ~/ 2)}:${index % 2 == 0 ? "00" : "30"} PM',
                            style: const TextStyle(fontWeight: FontWeight.bold),),),);},),],],),),),),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: customBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),),],),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarItem(0, Icons.home, 'Home'),
                _buildNavBarItem(1, Icons.calendar_today, 'Appointments'),
                _buildNavBarItem(2, Icons.notifications, 'Notifications'),],),),),),);}

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Add navigation logic here
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 35,
            icon,
            color: isSelected ? customLightBlue : customLightBlue.withOpacity(0.7),),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? customLightBlue : customLightBlue.withOpacity(0.7),
              fontSize: 12,),),],),);}

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
          borderRadius: BorderRadius.circular(8),),),);}}