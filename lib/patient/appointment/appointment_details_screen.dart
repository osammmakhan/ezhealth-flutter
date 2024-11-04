import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/payment/payment_method_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';
import 'package:ez_health/providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late TextEditingController _ageController;
  late TextEditingController _otherPersonNameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _otherPersonNameController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _otherPersonNameController.dispose();
    super.dispose();
  }

  void _handleAgeChange(String value, AppointmentProvider provider) {
    if (value.isEmpty) {
      provider.setAge(0);
      return;
    }

    final age = int.tryParse(value);
    if (age != null && age >= 0 && age <= 100) {
      provider.setAge(age.toDouble());
    } else if (age != null && age > 100) {
      _ageController.text = '100';
      _ageController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 3),
      );
      provider.setAge(100);
    }
  }

  bool _isFormValid(AppointmentProvider provider) {
    // Check if booking type is selected
    if (provider.bookingFor.isEmpty) return false;

    // If booking for other, check if name is provided
    if (provider.bookingFor == 'Other' &&
        _otherPersonNameController.text.trim().isEmpty) return false;

    // Check if gender is selected
    if (provider.gender.isEmpty) return false;

    // Check if age is greater than 0
    if (provider.age <= 0) return false;

    return true;
  }

  void _handleProceedToPayment(BuildContext context, AppointmentProvider provider) {
    // No need because we don't allow the user to proceed if the form is not valid

    // if (!_isFormValid(provider)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please fill in all required fields'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    // Form is valid, we can proceed
    print('Appointment details:');
    print('Booking for: ${provider.bookingFor}');
    if (provider.bookingFor == 'Other') {
      print('Other person name: ${_otherPersonNameController.text}');
    }
    print('Gender: ${provider.gender}');
    print('Age: ${provider.age}');
    print('Problem: ${provider.problemDescription}');
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    if (!_isEditing) {
      _ageController.text = appointmentProvider.age.round().toString();
    }

    final bool isFormValid = _isFormValid(appointmentProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Appointment Details',
          style: TextStyle(color: Colors.white)),
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
                    const Text('Booking for',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      'Select Here',
                      ['Myself', 'Other'],
                      appointmentProvider.bookingFor,
                      (val) {
                        appointmentProvider.setBookingFor(val);
                        if (val != 'Other') {
                          _otherPersonNameController.clear();
                        }
                        setState(() {});
                      },
                    ),
                    if (appointmentProvider.bookingFor == 'Other') ...[
                      const SizedBox(height: 16),
                      const Text('Name of the other person *',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _otherPersonNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter name',
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('Gender ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      'Select Here',
                      ['Male', 'Female', 'Other'],
                      appointmentProvider.gender,
                      (val) {
                        appointmentProvider.setGender(val);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Age ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _ageController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onTap: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _isEditing = true;
                                _handleAgeChange(value, appointmentProvider);
                              });
                            },
                            onSubmitted: (value) {
                              if (value.isEmpty) {
                                _ageController.text = '0';
                                appointmentProvider.setAge(0);
                              }
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            onEditingComplete: () {
                              if (_ageController.text.isEmpty) {
                                _ageController.text = '0';
                                appointmentProvider.setAge(0);
                              }
                              setState(() {
                                _isEditing = false;
                              });
                            },
                          ),
                        ),
                        Row(
                          children: [
                            const Text('0'),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2,
                                  thumbColor: Colors.blue,
                                  activeTrackColor: Colors.blue,
                                  inactiveTrackColor: Colors.blue.withOpacity(0.2),
                                  overlayColor: Colors.blue.withOpacity(0.1),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                ),
                                child: Slider(
                                  value: appointmentProvider.age,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  onChanged: (value) {
                                    setState(() {
                                      _isEditing = false;
                                      appointmentProvider.setAge(value);
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Text('100'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Write Your Problem',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe your problem here...',
                      ),
                      onChanged: appointmentProvider.setProblemDescription,
                    ),
                    const SizedBox(height: 100),
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
                text: 'Process to Payment',
                nextScreen: const PaymentMethodScreen(),
                enabled: isFormValid,
                onPressed: () => _handleProceedToPayment(context, appointmentProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String value,
    Function(String) onChanged,
  ) {
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
          value: value.isEmpty ? null : value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              onChanged(val);
            }
          },
        ),
      ),
    );
  }
}