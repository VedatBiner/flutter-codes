// <----- main_screen.dart ----->

import 'package:flutter/material.dart';
import 'package:todo_app/screens/save_screen.dart';

// A simple data class for Todo items
class _TodoInfo {
  final IconData icon;
  final String text;
  final Color color;

  const _TodoInfo({
    required this.icon,
    required this.text,
    required this.color,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List of Todo items
  final List<_TodoInfo> _todoItems = [
    const _TodoInfo(
      icon: Icons.airplanemode_active,
      text: 'Buy a plane ticket',
      color: Colors.blue,
    ),
    const _TodoInfo(
      icon: Icons.work,
      text: 'Join the meeting',
      color: Colors.orange,
    ),
    const _TodoInfo(
      icon: Icons.sports_gymnastics,
      text: 'Go to gym',
      color: Colors.green,
    ),
    const _TodoInfo(icon: Icons.edit, text: 'Edit files', color: Colors.purple),
    const _TodoInfo(
      icon: Icons.school,
      text: 'Attend English class',
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDos')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return TodoItem(
                    icon: item.icon,
                    text: item.text,
                    iconColor: item.color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaveScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor, // Added color property
  });

  final IconData icon;
  final String text;
  final Color? iconColor; // Added color property

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor), // Used color property
        title: Text(text),
        trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
      ),
    );
  }
}
