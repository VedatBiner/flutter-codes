import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/controller/main_screen_controller.dart';
import 'core/theme/theme_dark.dart';
import 'product/main_screen.dart';
import 'core/theme/theme_manager.dart';

void main() {
  runApp(provider());
}

MultiProvider provider() => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager.instance),
        ChangeNotifierProvider(create: (_) => MainScreenController.instance),
      ],
      child: const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio Web Site',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeManager>(context).currentTheme,
      darkTheme: ThemeDark.instance.theme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
