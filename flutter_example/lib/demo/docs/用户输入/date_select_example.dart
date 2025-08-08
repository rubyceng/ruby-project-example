import 'package:flutter/material.dart';

class DateSelectExample extends StatefulWidget {
  const DateSelectExample({super.key});

  @override
  State<DateSelectExample> createState() => _DateSelectExampleState();
}

class _DateSelectExampleState extends State<DateSelectExample> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  /// DatePickerDialog 日期选择器
  Future<DateTime?> buildDatePickerDialog() async {
    return await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );
  }

  /// TimePickerDialog
  Future<TimeOfDay?> buildTimePickerDialog() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('DatePickerDialog 日期选择器'),
          SizedBox(height: 10),
          Text('selectedDate: ${_selectedDate?.toString()}'),
          ElevatedButton.icon(
            icon: Icon(Icons.calendar_month),
            label: Text('Pick a date'),
            onPressed: () async {
              var date = await buildDatePickerDialog();
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          Text('TimePickerDialog 时间选择器'),
          SizedBox(height: 10),
          Text('selectedTime: ${_selectedTime?.toString()}'),
          ElevatedButton.icon(
            icon: Icon(Icons.access_time),
            label: Text('Pick a time'),
            onPressed: () async {
              var time = await buildTimePickerDialog();
              setState(() {
                _selectedTime = time;
              });
            },
          ),
        ],
      ),
    );
  }
}
