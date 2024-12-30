import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentScheduling extends StatefulWidget {
  @override
  _AppointmentSchedulingState createState() => _AppointmentSchedulingState();
}

class _AppointmentSchedulingState extends State<AppointmentScheduling> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _selectedDate = '';
  String _selectedTime = '';
  String _healthcareProvider = 'Dr. Jane Smith';

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    }
  }

  void _confirmAppointment() {
    String name = _nameController.text;
    String contact = _contactController.text;
    String notes = _notesController.text;

    // Call the actual email sending function
    _sendConfirmationEmail(name, contact, notes, _selectedDate, _selectedTime);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Confirmed'),
        content: Text('Your appointment has been scheduled. A confirmation email has been sent.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to send email using SendGrid
  void _sendConfirmationEmail(String name, String contact, String notes, String date, String time) async {
    final response = await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: {
        'Authorization': 'Bearer YOUR_SENDGRID_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'personalizations': [
          {
            'to': [{'email': contact}],
            'subject': 'Appointment Confirmation',
          },
        ],
        'from': {'email': 'drwiso@hotmail.com'},
        'content': [
          {
            'type': 'text/plain',
            'value': 'Dear $name,\n\nYour appointment with Dr. Jane Smith on $date at $time has been confirmed.\n\nNotes: $notes\n\nThank you!',
          },
        ],
      }),
    );

    if (response.statusCode == 202) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Scheduling'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFE0F7FA),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor's Photo and Information
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/doctor.jpg'), // Add your doctor's photo here
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dr. Jane Smith',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    Text(
                      'Endocrinologist & Diabetes Specialist',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal[300],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Who is Dr. Jane Smith?
              Text(
                'Who is Dr. Jane Smith?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Dr. Jane Smith is a leading endocrinologist and diabetes specialist with over 20 years of experience. She has dedicated her career to helping patients manage their diabetes through personalized care, education, and advanced treatment options. Dr. Smith is renowned for her compassionate approach and her commitment to staying at the forefront of medical advancements.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              // First Class Free
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'First consultation is free! Take advantage of this opportunity to receive personalized care and expert advice at no cost.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Why Participate
              Text(
                'Why Participate?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Participating in a 1-on-1 consultation with Dr. Smith provides personalized care, expert advice, and tailored treatment plans to help you manage your diabetes effectively.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              // What to Expect
              Text(
                'What to Expect?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'During your consultation, you can expect a thorough review of your health, personalized recommendations, and a comprehensive plan to manage your diabetes. Please be prepared to discuss your medical history and any current concerns.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              // Date and Time Selection
              Text(
                'Select Date and Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Select Date'),
                subtitle: Text(_selectedDate.isEmpty ? 'No date selected' : _selectedDate),
                trailing: Icon(Icons.calendar_today, color: Colors.teal),
                onTap: _selectDate,
              ),
              ListTile(
                title: Text('Select Time'),
                subtitle: Text(_selectedTime.isEmpty ? 'No time selected' : _selectedTime),
                trailing: Icon(Icons.access_time, color: Colors.teal),
                onTap: _selectTime,
              ),
              SizedBox(height: 20),
              // Patient Information
              Text(
                'Patient Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact Information',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes or Concerns',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Confirm Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
