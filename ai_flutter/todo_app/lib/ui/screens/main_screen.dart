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
  List<Todos> _todoItems = [];

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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadToDos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadToDos() async {
    var todoList = [
      Todos(id: 1, name: 'Buy a plane ticket', image: 'agac.png'),
      Todos(id: 2, name: 'Join the meeting', image: 'araba.png'),
      Todos(id: 3, name: 'Go to gym', image: 'cicek.png'),
      Todos(id: 4, name: 'Edit files', image: 'damla.png'),
      Todos(id: 5, name: 'Attend English class', image: 'gunes.png'),
    ];
    setState(() {
      _todoItems = todoList;
    });
  }

  Future<void> search(String searchText) async {
    print("Searching for: $searchText");
  }

  Future<void> delete(int id) async {
    print("Deleting ToDo with ID: $id");
  }

  Widget _buildTodoList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          final item = _todoItems[index];
          return TodoItem(
            todo: item,
            onDelete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "'${item.name}' isimli görevi silmek istediğinize emin misiniz?"),
                  action: SnackBarAction(
                    label: 'SİL',
                    onPressed: () {
                      delete(item.id);
                    },
                  ),
                ),
              );
            },
            onReturn: loadToDos,
          );
        },
      ),
    );
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
              onChanged: (value) {
                search(value);
              },
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
            _buildTodoList(),
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
            loadToDos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem(
      {super.key,
      required this.todo,
      required this.onDelete,
      required this.onReturn});

  final Todos todo;
  final VoidCallback onDelete;
  final VoidCallback onReturn;

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
            onReturn();
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
        trailing: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkGray),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
