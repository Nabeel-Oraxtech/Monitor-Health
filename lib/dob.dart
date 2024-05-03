import 'package:flutter/material.dart';

class DOBScreen extends StatefulWidget {
  const DOBScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DOBScreenState createState() => _DOBScreenState();
}

class _DOBScreenState extends State<DOBScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date and Time Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'Select Date of Birth'
                  : 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedTime!.format(context)}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDateAndTime(context),
              child: const Text('Select Date and Time'),
            ),
          ],
        ),
      ),
    );
  }
}
