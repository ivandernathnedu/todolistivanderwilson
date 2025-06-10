import 'package:flutter/material.dart';

class HalamanKalender extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const HalamanKalender({super.key, required this.tasks});

  @override
  State<HalamanKalender> createState() => _HalamanKalenderState();
}

class _HalamanKalenderState extends State<HalamanKalender> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'TidyTask Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMonthNavigator(),
          _buildDayLabels(),
          _buildCalendarGrid(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return _buildTaskItem(task['title'], task['subtitle']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                    _currentMonth.year, _currentMonth.month - 1, _currentMonth.day);
              });
            },
          ),
          Text(
            '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                    _currentMonth.year, _currentMonth.month + 1, _currentMonth.day);
              });
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  Widget _buildDayLabels() {
    final List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9), // Light green color
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days
              .map((day) => Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final DateTime firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final int firstWeekday = firstDayOfMonth.weekday; // Monday is 1, Sunday is 7

    // Adjust firstWeekday to be 0 for Sunday, 1 for Monday, etc. (consistent with Flutter's DateTime.weekday)
    final int startingDay = (firstWeekday == 7) ? 0 : firstWeekday; // If Sunday is 7, make it 0.

    List<Widget> dayWidgets = [];

    // Add empty cells for the days before the 1st of the month
    for (int i = 0; i < startingDay; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    // Add actual days of the month
    for (int i = 1; i <= daysInMonth; i++) {
      final DateTime currentDate = DateTime(_currentMonth.year, _currentMonth.month, i);
      final bool hasTask = widget.tasks.any((task) {
        if (task['subtitle'] is String && task['subtitle'] != 'Tomorrow') {
          try {
            final taskDate = DateTime.parse(task['subtitle']);
            return taskDate.year == currentDate.year &&
                   taskDate.month == currentDate.month &&
                   taskDate.day == currentDate.day;
          } catch (e) {
            return false; // Handle parsing errors
          }
        }
        return false;
      });

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            // Handle date selection or task filtering
            // print('Tapped on day $i'); // Removed print statement
          },
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: hasTask
                ? BoxDecoration(
                    color: const Color(0xFFE0BBE4), // Purple color for dates with tasks
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '$i',
              style: TextStyle(
                color: hasTask ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: dayWidgets.length,
        itemBuilder: (context, index) {
          return dayWidgets[index];
        },
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Radio<bool>(
            value: false, // This will be dynamic based on task completion
            groupValue: true, // This is just a placeholder for now
            onChanged: (bool? value) {
              // Handle task completion toggle
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
