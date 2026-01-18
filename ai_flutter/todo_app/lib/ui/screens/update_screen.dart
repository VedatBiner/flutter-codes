// <----- update_screen.dart ----->

import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  // The initial name of the task to be updated.
  final String initialTaskName;

  const UpdateScreen({super.key, required this.initialTaskName});

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
    _taskNameController = TextEditingController(text: widget.initialTaskName);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Screen'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/gezegen.png',
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  /// resim yoksa bunu göster
                  return Icon(
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
                  border: OutlineInputBorder(),
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
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, handle updating the data here
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
