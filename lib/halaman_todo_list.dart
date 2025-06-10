import 'package:flutter/material.dart';
import 'package:todolistivanderwilson/halaman_add_list.dart';
import 'package:todolistivanderwilson/halaman_edit_task.dart';
import 'package:todolistivanderwilson/halaman_kalender.dart';
import 'package:todolistivanderwilson/Halaman_profil.dart';

class HalamanTodoList extends StatefulWidget {
  final String? email;

  const HalamanTodoList({super.key, this.email});

  @override
  State<HalamanTodoList> createState() => _HalamanTodoListState();
}

class _HalamanTodoListState extends State<HalamanTodoList> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Schedule a meeting with the team', 'subtitle': 'Tomorrow', 'isChecked': false},
    {'title': 'Buy groceries for the week', 'subtitle': '2025-05-10', 'isChecked': false},
    {'title': 'Buy groceries for the week', 'subtitle': '2025-05-17', 'isChecked': false},
    {'title': 'Pay the utility bills', 'subtitle': '2025-05-21', 'isChecked': false},
    {'title': 'Complete the project report', 'subtitle': '2025-05-30', 'isChecked': false},
  ];

  @override
  void initState() {
    super.initState();
    print('Email received in HalamanTodoList: ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TidyTask'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hi Tidy,ready to check off that list?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return _buildTaskItem(
                  task['title']!,
                  task['subtitle']!,
                  task['isChecked']!,
                  (bool? newValue) {
                    setState(() {
                      _tasks[index]['isChecked'] = newValue!;
                    });
                  },
                  () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanEditTask(task: task),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        if (result['action'] == 'erase') {
                          _tasks.removeAt(index);
                        } else if (result['action'] == 'edit') {
                          _tasks[index] = result['updatedTask'];
                        }
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanKalender(tasks: _tasks),
              ),
            );
          } else if (index == 1) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HalamanAddList()),
            );

            if (result != null) {
              setState(() {
                _tasks.add({
                  'title': result['tidyName'],
                  'subtitle': result['date'],
                  'isChecked': false,
                });
              });
            }
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanProfil(email: widget.email),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle, bool isChecked, Function(bool?) onToggle, Function() onNavigate) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Checkbox(
        value: isChecked,
        onChanged: onToggle,
      ),
      onTap: onNavigate,
    );
  }
}
