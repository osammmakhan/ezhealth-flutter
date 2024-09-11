import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/screens/patient/payment_method_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  @override
  _AppointmentDetailsScreenState createState() =>
      _AppointmentDetailsScreenState();
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking for',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Myself', 'Others'], bookingFor,
                        (value) {
                      setState(() {
                        bookingFor = value;
                        showOtherPersonName = value == 'Others';
                      });
                    }),
                    if (showOtherPersonName) ...[
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Name of the other person',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => otherPersonName = value,
                      ),
                    ],
                    SizedBox(height: 16),
                    Text('Gender',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Male', 'Female', 'Others'], gender,
                        (value) {
                      setState(() => gender = value);
                    }),
                    SizedBox(height: 16),
                    Text('Age',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildAgeSlider(),
                    SizedBox(height: 16),
                    Text('Write Your Problem',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe your problem here...',
                      ),
                      onChanged: (value) => problem = value,
                    ),
                    SizedBox(height: 100), // Space for the button at the bottom
                  ],
                ),
              ),
            ),
          ),
          //Make Appointment Button
          Container(
            alignment: Alignment.bottomCenter,
            child: HorizontalBtn(
                text: 'Process to Payment',
                // context: context,
                nextScreen: PaymentMethodScreen(),
                onPressed: () {
                  // Handle the appointment creation here
                  print('Appointment details:');
                  print('Booking for: $bookingFor');
                  if (showOtherPersonName)
                    print('Other person name: $otherPersonName');
                  print('Gender: $gender');
                  print('Age: ${age.toInt()}');
                  print('Problem: $problem');
                  // Navigate to the next screen or show a confirmation dialog
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value,
      Function(String?) onChanged) {
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
            padding: EdgeInsets.symmetric(horizontal: 8),
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
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: customBlue),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: customBlue,
            inactiveTrackColor: customBlue.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.4),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
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
        Row(
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
