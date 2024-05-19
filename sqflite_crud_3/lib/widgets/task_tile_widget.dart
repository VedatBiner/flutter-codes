/// <task_tile_widget.dart ----->
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskTileWidget extends HookWidget {
  const TaskTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onEdit,
        title: Text(
          task.title,
        ),
      ),
    );
  }
}
