import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../database/app_database.dart';
import '../models/task.dart';
import '../models/task_type.dart';

class AddTaskBottomSheet extends StatefulHookWidget {
  final Task? task;
  const AddTaskBottomSheet(this.task, {super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic>? get formData => formKey.currentState?.value;
  final AppDatabase db = AppDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final isDone = useState<bool?>(false);
    final isLoading = useState<bool>(false);
    final task = useState<Task?>(widget.task);

    /// Formun kaydedilmesi
    void onSubmit() {
      if (formKey.currentState?.validate() == true) {
        isLoading.value = true;
        formKey.currentState?.save();
        final newTask = Task.fromJson(formData!);
        if (widget.task == null) {
          db.createTask(newTask);
        } else {
          db.updateTask(newTask.copyWith(id: widget.task!.id!));
        }

        isLoading.value = false;
        Navigator.pop(context, true);
      }
    }

    if (isLoading.value) {
      return const LoadingWidget(isFullScreen:true);
    }
    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child:
          FormBuilder(key: formKey, enabled: !isLoading.value, initialValue: {
        idField: task.value?.id,
        titleField: task.value?.title,
        descriptionField: task.value?.description,
        dueDateField: task.value?.dueDate ?? defaultDueDate,
        taskTypeField: task.value?.taskType ?? TaskType.today,
        isDoneField: task.value?.isDone ?? isDone.value,
      }),
    );
  }
}
