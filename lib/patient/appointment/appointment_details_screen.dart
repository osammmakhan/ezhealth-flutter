import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/payment/payment_method_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  String? bookingFor;
  String? gender;
  double age = 0;
  String problem = '';
  bool showOtherPersonName = false;
  String otherPersonName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Appointment Details', style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Booking for', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Myself', 'Other'], bookingFor,
                        (value) {
                      setState(() {
                        bookingFor = value;
                        showOtherPersonName = value == 'Other';
                      });
                    }),
                    if (showOtherPersonName) ...[
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name of the other person',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => otherPersonName = value,
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Male', 'Female', 'Other'], gender,
                        (value) {
                      setState(() => gender = value);
                    }),
                    const SizedBox(height: 16),
                    const Text('Age', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildAgeSlider(),
                    const SizedBox(height: 16),
                    const Text('Write Your Problem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe your problem here...',
                      ),
                      onChanged: (value) => problem = value,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: HorizontalBtn(
              text: 'Process to Payment',
              nextScreen: const PaymentMethodScreen(),
              onPressed: () {
                print('Appointment details:');
                print('Booking for: $bookingFor');
                if (showOtherPersonName) {
                  print('Other person name: $otherPersonName');
                }
                print('Gender: $gender');
                print('Age: ${age.toInt()}');
                print('Problem: $problem');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(hint),
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAgeSlider() {
    return Column(
      children: [
        Text(
          '${age.toInt()}',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: customBlue),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: customBlue,
            inactiveTrackColor: customBlue.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.4),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
          ),
          child: Slider(
            value: age,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (value) {
              setState(() => age = value);
            },
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0'),
            Text('100'),
          ],
        ),
      ],
    );
  }
}
