import 'package:flutter/material.dart';

import '../page/profile_widget.dart';
import '../main.dart';
import '../widget/change_theme_button_widget.dart';
import 'navigationbar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu),
        title: const Text(MyApp.title),
        elevation: 0,
        actions: const [
          ChangeThemeButtonWidget(),
        ],
      ),
      body: const ProfileWidget(),
      extendBody: true,
      bottomNavigationBar: const NavigationBarWidget(),
    );
  }
}
