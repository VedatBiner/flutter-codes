/// <----- fab_helper.dart ----->
library;

import 'package:flutter/material.dart';

FloatingActionButton buildFloatingActionButton({
  required VoidCallback onPressed,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: Colors.blueAccent,
    child: const Icon(
      Icons.add,
      color: Colors.amberAccent,
    ),
  );
}
