// 📃 <----- button_constants.dart ----->

import 'package:flutter/material.dart';

import 'color_constants.dart';

final ButtonStyle elevatedCancelButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  shadowColor: Colors.black54,
  backgroundColor: cancelButtonColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle elevatedConfirmButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  shadowColor: Colors.black54,
  backgroundColor: deleteButtonColor,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle elevatedAddButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: addButtonColor,
  elevation: 8,
  shadowColor: Colors.black54,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle elevatedUpdateButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  shadowColor: Colors.black54,
  backgroundColor: editButtonColor,
  foregroundColor: buttonIconColor,
);

final ButtonStyle elevateDeleteButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  shadowColor: Colors.black54,
  backgroundColor: deleteButtonColor,
  foregroundColor: buttonIconColor,
);
