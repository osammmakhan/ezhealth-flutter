import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/patient/patient_home_screen.dart';
import 'package:ez_health/assets/widgets/buttons/horizontal_button.dart';

// Patient's Appointment Screen
class PatientAppointmentScreen extends StatefulWidget {
  const PatientAppointmentScreen({super.key});

  @override
  State<PatientAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<PatientAppointmentScreen> {
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
                      _buildDoctorInfo(),
                      const SizedBox(height: 60),
                      const Divider(
                          color: Colors.grey, indent: 20, endIndent: 20),
                      const SizedBox(height: 24),
                      _buildStats(),
                      const SizedBox(height: 50),
                      const Text(
                        'Book Appointment',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 50),
                      _buildDatePicker(),
                      const SizedBox(height: 10),
                      _buildTimePicker(),],),),),),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HorizontalBtn(
                text: 'Make Appointment',
                nextScreen: const AppointmentDetailsScreen(),
                onPressed: () {},
              ),
            ),],),),);}

  Widget _buildDoctorInfo() {
    return const Row(
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage('lib/assets/images/Doctor Profile Picture.png'),
          minRadius: 70,),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Osama Khan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            Text(
              'Dentist',
              style: TextStyle(fontSize: 16),),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: customBlue),
                Text(
                  'Hyderabad, Pakistan',
                  style: TextStyle(color: Colors.grey),),],),],),],);}

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(Icons.group, '7,500+', 'Patients'),
        _buildStatItem(Icons.work, '10+', 'Years Exp.'),
        _buildStatItem(Icons.star, '4.9', 'Ratings'),
        _buildStatItem(Icons.chat, '4,956', 'Reviews'),],);}

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
            child: Icon(icon, color: customBlue, size: 24),
          ),),
        const SizedBox(height: 8),
        Text(
          value,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: customBlue),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),],);}

  Widget _buildDatePicker() {
    final weekDays = _generateWeekDays();
    return CarouselSlider.builder(
      itemCount: weekDays.length,
      options: CarouselOptions(
        height: 80,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() => _selectedDateIndex = index);
        },),
      itemBuilder: (context, index, realIndex) {
        return _buildDateButton(weekDays[index], index);},);}

  Widget _buildTimePicker() {
    final timeSlots = _generateTimeSlots();
    return CarouselSlider.builder(
      itemCount: timeSlots.length,
      options: CarouselOptions(
        height: 60,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() => _selectedTimeIndex = index);
        },),
      itemBuilder: (context, index, realIndex) {
        return _buildTimeButton(timeSlots[index], index == _selectedTimeIndex);},);}

  Widget _buildDateButton(DateTime date, int index) {
    bool isSelected = index == _selectedDateIndex;
    return OutlinedButton(
      onPressed: () {
        setState(() => _selectedDateIndex = index);
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: isSelected ? customBlue : Colors.grey, width: 2),
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
            style: const TextStyle(fontSize: 16, color: Colors.black),),],),);}

  Widget _buildTimeButton(String time, bool isSelected) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedTimeIndex = _generateTimeSlots().indexOf(time);
          });},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: isSelected ? customBlue : Colors.grey, width: 2),
        backgroundColor: isSelected ? customLightBlue : Colors.transparent,
      ),
      child: Text(
        time,
        style: TextStyle(
            fontSize: 16, color: isSelected ? customBlue : Colors.black),),);}}

// Appointment Details Screen
class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() =>
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white),
        ),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Myself', 'Other'], bookingFor,
                        (value) {
                      setState(() {
                        bookingFor = value;
                        showOtherPersonName = value == 'Other';
                      });}),
                    if (showOtherPersonName) ...[
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name of the other person',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => otherPersonName = value,
                      ),],
                    const SizedBox(height: 16),
                    const Text('Gender',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                        'Select Here', ['Male', 'Female', 'Other'], gender,
                        (value) {
                      setState(() => gender = value);
                    }),
                    const SizedBox(height: 16),
                    const Text('Age',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildAgeSlider(),
                    const SizedBox(height: 16),
                    const Text('Write Your Problem',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe your problem here...',
                      ),
                      onChanged: (value) => problem = value,
                    ),
                    const SizedBox(height: 100),],),),),),
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
                print('Problem: $problem');},),),],),);}

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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(hint),
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(item),),);}).toList(),
          onChanged: onChanged,
          ),),);}

  Widget _buildAgeSlider() {
    return Column(
      children: [
        Text(
          '${age.toInt()}',
          style: const TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: customBlue),
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
            },),),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0'),
            Text('100'),
          ],),],);}}

// Payment Method Screen
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment Methods',
            style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No Payment Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'You can add and edit payments during checkout',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),),
            const SizedBox(height: 40),
            Container(
              width: 280,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),],),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentMethodListScreen()
                          ),);},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: customBlue, width: 2),
                        ),
                        child:
                            const Icon(Icons.add, color: customBlue, size: 30),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Add Payment Method',
                        style: TextStyle(
                          color: customBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),],),),),),],),),);}}

// Payment Method List Screen
class PaymentMethodListScreen extends StatelessWidget {
  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Visa',
      'icon': 'lib/assets/images/paymentmethod-assets/visa.png'},
    {
      'name': 'MasterCard',
      'icon': 'lib/assets/images/paymentmethod-assets/mastercard.png'
    },
    {
      'name': 'American Express',
      'icon': 'lib/assets/images/paymentmethod-assets/american_ex.png'
    },
    {
      'name': 'PayPal',
      'icon': 'lib/assets/images/paymentmethod-assets/paypal.png'
    },
    {
      'name': 'Diners',
      'icon': 'lib/assets/images/paymentmethod-assets/diners.png'
    },
  ];

  PaymentMethodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment Methods',
            style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: paymentMethods.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentDetailsScreen()
                          ),);},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Row(
                      children: [
                        Image.asset(
                          paymentMethods[index]['icon']!,
                          width: 40,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            paymentMethods[index]['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),),),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],),),),),);},),),);}}

// Payment Details Screen
class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  String _cardHolderName = '';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String input) {
    if (input.length > 19) return input.substring(0, 19);
    input = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Payment Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Preview
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E2F97), Color(0xFF0165FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'lib/assets/images/paymentmethod-assets/chip.png',
                            height: 40,
                            width: 40,
                          ),
                          Image.asset(
                            'lib/assets/images/paymentmethod-assets/mastercard_logo.png',
                            height: 40,
                            width: 40,
                          ),],),
                      Text(
                        _cardNumber.isEmpty
                            ? '**** **** **** ****'
                            : _cardNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 2,
                        ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CARD HOLDER',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),),
                              Text(
                                _cardHolderName.isEmpty
                                    ? 'Your Name'
                                    : _cardHolderName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),],),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'EXPIRES',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),),
                              Text(
                                _expiryDate.isEmpty ? 'MM/YY' : _expiryDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),],),],),],),),
                const SizedBox(height: 30),
                // Card Number Field
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 19,
                  onChanged: (value) {
                    setState(() {
                      _cardNumber = _formatCardNumber(value);
                      _cardNumberController.value = TextEditingValue(
                        text: _cardNumber,
                        selection:
                            TextSelection.collapsed(offset: _cardNumber.length),
                      );});},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    return null;
                  },),
                const SizedBox(height: 20),
                // Expiry and CVV Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          labelText: 'MM/YY',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        onChanged: (value) {
                          setState(() {
                            _expiryDate = value;
                          });},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },),),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            _cvv = value;
                          });},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },),),],),
                const SizedBox(height: 20),
                // Card Holder Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Card Holder Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _cardHolderName = value;
                    });},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card holder name';
                    }
                    return null;
                  },),
                const SizedBox(height: 30),
                // Pay Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Mock payment processing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConfirmationScreen(),
                          ),);}},
                    child: const Text(
                      'Pay & Confirm',
                      style: TextStyle(fontSize: 18, color: customLightBlue),
                    ),),),],),),),),);}}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate reference number and ticket token
    final ticketGenerator = TicketGenerator();
    final referenceNumber = ticketGenerator.generateReferenceNumber();
    final ticketToken = ticketGenerator.generateTicketToken();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: customLightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: customBlue,
                  size: 60,
                ),),
              const SizedBox(height: 30),
              const Text(
                'Appointment Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
              const SizedBox(height: 10),
              const Text(
                'PKR 5,000',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customBlue,
                ),),
              const SizedBox(height: 40),
              // Appointment Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),],),
                child: Column(
                  children: [
                    _buildDetailRow('Doctor', 'Dr. Osama Khan'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Date', 'October 26, 2024'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Time', '5:30 PM'),
                    const SizedBox(height: 15),
                    _buildDetailRow('Location', 'Hyderabad, Pakistan'),
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 15),
                    _buildDetailRow('Reference No.', referenceNumber),
                    const SizedBox(height: 15),
                    _buildDetailRow('Ticket Token', ticketToken),
                  ],),),
              const Spacer(),
              // Done Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),),
                  onPressed: () {
                    // Clear the navigation stack and push the HomeScreen with appointment = true
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(hasAppointment: true),
                      ),
                      (route) => false, // This removes all previous routes
                    );},
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, color: customLightBlue),
                  ),),),],),),),);}

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),],);}}

// Ticket Generation System
class TicketGenerator {
  static final TicketGenerator _instance = TicketGenerator._internal();

  factory TicketGenerator() {
    return _instance;
  }

  TicketGenerator._internal();

  String generateReferenceNumber() {
    // Format: REF-YYMMDD-XXX
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final date = '$year${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final random = (100 + DateTime.now().millisecondsSinceEpoch % 900).toString();
    return 'REF-$date-$random';
  }

  String generateTicketToken() {
    // Format: TKT-XX
    // This is a mock implementation - in production, this would include
    // actual clinic ID and proper cryptographic random number generation
    final random = (10 + DateTime.now().second) % 99;
    return 'TKT-${random.toString().padLeft(2, '0')}';
  }

  // This method would be used by the admin module to validate tickets
  bool validateTicket(String token) {
    if (token.isEmpty) return false;

    final parts = token.split('-');
    if (parts.length != 3) return false;
    if (parts[0] != 'TKT') return false;

    // Add more validation logic as needed
    // In a real implementation, this would check against a database
    // of valid tickets and their status

    return true;
  }}