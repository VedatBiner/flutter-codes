/// <----- home_detail_view.dart ----->
library;

import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class HomeDetailView extends StatelessWidget {
  const HomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Home Detail View",
          style: context.theme.textTheme.displaySmall,
        ),
      ],
    );
  }
}
