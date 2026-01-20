// <----- main_screen.dart ----->

import 'dart:math';

import 'package:flutter/material.dart';
import '../../data/entity/todos.dart';
import '../../ui/screens/update_screen.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/screens/save_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // The complete list of Todo items
  final List<Todos> _todoItems = [
    Todos(id: 1, name: 'Buy a plane ticket', image: 'agac.png'),
    Todos(id: 2, name: 'Join the meeting', image: 'araba.png'),
    Todos(id: 3, name: 'Go to gym', image: 'cicek.png'),
    Todos(id: 4, name: 'Edit files', image: 'damla.png'),
    Todos(id: 5, name: 'Attend English class', image: 'gunes.png'),
  ];

  final List<String> _imageAssets = [
    'agac.png',
    'araba.png',
    'cicek.png',
    'damla.png',
    'gezegen.png',
    'gunes.png',
    'roket.png',
    'semsiye.png',
    'simsek.png',
    'yildiz.png',
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('ToDos', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.darkGray),
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
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.white,
        onPressed: () {
          final randomImage =
              _imageAssets[Random().nextInt(_imageAssets.length)];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveScreen(imageName: randomImage),
            ),
          ).then((_) {
            print("Returned from SaveScreen");
          });
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
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateScreen(todo: todo)),
          ).then((_) {
            print("Returned from UpdateScreen");
          });
        },
        leading: Image.asset(
          'assets/images/${todo.image}',
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_not_supported_outlined,
              size: 28,
              color: AppColors.darkGray,
            );
          },
        ),
        title: Text(
          todo.name,
          style: const TextStyle(color: AppColors.darkGray),
        ),
        trailing: const Icon(Icons.close, color: AppColors.darkGray),
      ),
    );
  }
}
