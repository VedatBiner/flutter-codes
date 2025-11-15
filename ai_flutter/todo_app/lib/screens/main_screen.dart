import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
              child: ListView(
                children: const [
                  TodoItem(
                    icon: Icons.airplanemode_active,
                    text: 'Buy a plane ticket',
                  ),
                  TodoItem(icon: Icons.work, text: 'Join the meeting'),
                  TodoItem(icon: Icons.sports_gymnastics, text: 'Go to gym'),
                  TodoItem(icon: Icons.edit, text: 'Edit files'),
                  TodoItem(icon: Icons.school, text: 'Attend English class'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
      ),
    );
  }
}
