import 'package:flutter/material.dart';

class HalamanEditTask extends StatefulWidget {
  final Map<String, dynamic> task;

  const HalamanEditTask({super.key, required this.task});

  @override
  State<HalamanEditTask> createState() => _HalamanEditTaskState();
}

class _HalamanEditTaskState extends State<HalamanEditTask> {
  late TextEditingController _tidyNameController;
  late TextEditingController _notesController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _tidyNameController = TextEditingController(text: widget.task['title']);
    _notesController = TextEditingController(text: widget.task['notes'] ?? '');
    _dateController = TextEditingController(text: widget.task['subtitle']);
  }

  @override
  void dispose() {
    _tidyNameController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_dateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'TidyTask',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tidyNameController,
              decoration: InputDecoration(
                hintText: 'Tidy Name',
                filled: true,
                fillColor: const Color(0xFFE8F5E9), // Light green color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Notes',
                filled: true,
                fillColor: const Color(0xFFE8F5E9), // Light green color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: 'Date',
                filled: true,
                fillColor: const Color(0xFFE8F5E9), // Light green color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'action': 'edit',
                    'updatedTask': {
                      'title': _tidyNameController.text,
                      'notes': _notesController.text,
                      'subtitle': _dateController.text,
                      'isChecked': widget.task['isChecked'],
                    },
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A), // Green color
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {'action': 'erase'});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600], // Red color
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Erase Task',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 