import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';


class DateRangePickerScreen extends StatefulWidget {
  @override
  _DateRangePickerScreenState createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  List<DateTime?> _selectedDates = [null, null];



  List<DateTime> _getDatesInRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      dates.add(start.add(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CalendarDatePicker2(

            config: CalendarDatePicker2Config(

              calendarType: CalendarDatePicker2Type.range,
            ),
            value: _selectedDates,
            onValueChanged: (dates) {
              setState(() {

                _selectedDates[0] = dates[0];
                _selectedDates[1]=dates[1]??null;
              });
            },
          ),
          if (_selectedDates[0] != null && _selectedDates[1] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Start Date: ${_selectedDates[0]!.toLocal()}',
                ),
                Text(
                  'Selected End Date: ${_selectedDates[1]!.toLocal()}',
                ),
                SizedBox(height: 20),
                Text(
                  'All Dates:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ..._getDatesInRange(
                    _selectedDates[0]!, _selectedDates[1]!)
                    .map((date) => Text(date.toLocal().toString()))
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }
}
