// <----- main_screen.dart ----->

import 'package:flutter/material.dart';
import 'package:todo_app/data/entity/todos.dart';
import '../../ui/screens/save_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // The complete list of Todo items
  final List<Todos> _todoItems = [
    Todos(id: 1, name: 'Buy a plane ticket', image: 'simsek.png'),
    Todos(id: 2, name: 'Join the meeting', image: 'simsek.png'),
    Todos(id: 3, name: 'Go to gym', image: 'simsek.png'),
    Todos(id: 4, name: 'Edit files', image: 'simsek.png'),
    Todos(id: 5, name: 'Attend English class', image: 'simsek.png'),
  ];

  // The list displayed on the screen, which can be filtered
  late List<Todos> _filteredTodoItems;

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
          .where((item) => item.name.toLowerCase().contains(query))
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
      appBar: AppBar(title: const Text('ToDos'), centerTitle: true),
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
                  return TodoItem(todo: item);
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
  const TodoItem({super.key, required this.todo});

  final Todos todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset('assets/${todo.image}'),
        title: Text(todo.name),
        trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
      ),
    );
  }
}
