/// <----- fab_helper.dart ----->
library;

import 'package:flutter/material.dart';

FloatingActionButton _buildFloatingActionButton({
  required VoidCallback onPressed,
}) {
  return _FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: Colors.blueAccent,
    child: const Icon(
      Icons.add,
      color: Colors.amberAccent,
    ),
  );
}
