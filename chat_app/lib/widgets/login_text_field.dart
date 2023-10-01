import 'package:flutter/material.dart';

import '../utils/textfield_styles.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final bool hasAsterisks;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.hasAsterisks = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hasAsterisks,
      validator: (value) {
        if(validator != null){
          return validator!(value);
        }
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: "Add your user name",
        hintStyle: ThemeTextStyle.loginTextFieldStyle,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
