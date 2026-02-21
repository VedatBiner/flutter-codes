// <----- update_screen.dart ----->

import 'package:flutter/material.dart';
import '../../data/entity/todos.dart';
import '../../ui/theme/app_colors.dart';

class UpdateScreen extends StatefulWidget {
  final Todos todo;

  const UpdateScreen({super.key, required this.todo});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _taskNameController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the task's current name.
    _taskNameController = TextEditingController(text: widget.todo.name);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> update(int id, String name) async {
    print("Updating ToDo with ID: $id and name: $name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Update Screen',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/${widget.todo.image}',
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  /// resim yoksa bunu göster
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 28,
                    color: Colors.grey,
                  );
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      update(widget.todo.id, _taskNameController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
