/// <----- home_about_view.dart ----->
library;

import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class HomeAboutView extends StatelessWidget {
  const HomeAboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Home About View",
          style: context.theme.textTheme.displaySmall,
        ),
      ],
    );
  }
}
