import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarWidget extends StatefulWidget {
  final List<DateTime> busyDates;

  CustomCalendarWidget({required this.busyDates});

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Colors.lightGreenAccent,
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
              todayDecoration:  BoxDecoration(
                color: Colors.lightGreen[200],
                shape: BoxShape.circle,
              ),
            ),

            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            availableGestures: AvailableGestures.none,
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              formatButtonVisible: false
            ),

            selectedDayPredicate: (day) {
              return isSameDay(_startDate, day) || isSameDay(_endDate, day);
            },
            rangeStartDay: _startDate,
            rangeEndDay: _endDate,

            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },

            onDaySelected: (selectedDay, focusedDay) {
              if (!widget.busyDates.contains(selectedDay)) {
                setState(() {
                  if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
                    _endDate = selectedDay;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  } else {
                    _startDate = selectedDay;
                    _endDate = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  }
                  _focusedDay = focusedDay;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Cannot select busy date'),
                ));
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              if (!_containsBusyDates(start, end)) {
                setState(() {
                  _startDate = start;
                  _endDate = end;
                  _focusedDay = focusedDay;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Range includes busy dates'),
                ));
              }
            },
            calendarBuilders:
            CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
              bool isBusy = false;
              widget.busyDates.forEach((date) {

                if (date.toString()==day.toString().substring(0,day.toString().length-1) ) {
                  isBusy = true;
                  return ;
                }
              });
              if (isBusy == true) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return null;
            }),
          ),
          SizedBox(height: 20),
          _startDate != null && _endDate != null
              ? Text(
              'Selected range: ${_startDate!.toLocal()} - ${_endDate!.toLocal()}')
              : Text('Select a start and end date'),
        ],
      ),
    );
  }

  bool _containsBusyDates(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    for (var busyDate in widget.busyDates) {
      if (busyDate.isAfter(start.subtract(Duration(days: 1))) &&
          busyDate.isBefore(end.add(Duration(days: 1)))) {
        return true;
      }
    }
    return false;
  }
}
