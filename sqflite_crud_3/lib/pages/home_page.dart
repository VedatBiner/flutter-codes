/// <----- home_page.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bottom_sheets/add_task_bottom_sheet.dart';
import '../database/app_database.dart';
import '../models/task.dart';
import '../widgets/task_tile_widget.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppDatabase.instance;
    final tasks = useState<List<Task?>>([]);
    final isLoading = useState<bool>(false);

    late Widget body;

    Future refreshTasks() async {
      isLoading.value = true;
      tasks.value = await db.readAllTask();
      isLoading.value = false;
    }

    useEffect(() {
      refreshTasks();
      return () => db.close();
    }, const []);

    Future<bool?> showAddTaskBottomSheet(context, {Task? task}) =>
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(),
          builder: (context) => const AddTaskBottomSheet(task: task),
        );

    if (isLoading.value) {
      body = const LoadingWidget(isFullScreen: true);
    }

    if (tasks.value.isEmpty) {
      body = const EmptyListWidget();
    }

    if (tasks.value.isNotEmpty && !isLoading.value) {
      body = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.value.length,
        separatorBuilder: (context, i) => verticalSpace16,
        itemBuilder: (context, i) {
          final task = tasks.value[i]!;
          return TaskTileWidget(
            task: task,
            onEdit: () => showAddTaskBottomSheet(
              context,
              task: task,
            ).then(
                (_) => refreshTasks(),
            ),
            onDelete: () => db.deleteTask(task.id!).then(
                (_) => refreshTasks()
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: body,
      floatingActionButton: AddTaskFloatingButton(
        onPressed: () => showAddTaskBottomSheet(context).then(
          (_) => refreshTasks(),
        ),
      ),
    );
  }
}
