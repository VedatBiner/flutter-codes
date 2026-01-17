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
  // The complete list of Todo items
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

  // The list displayed on the screen, which can be filtered
  late List<_TodoInfo> _filteredTodoItems;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list contains all items
    _filteredTodoItems = _todoItems;
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTodoItems = _todoItems
          .where((item) => item.text.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTodoItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredTodoItems[index];
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
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
      ),
    );
  }
}
