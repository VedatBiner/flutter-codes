import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Progress HUD',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress HUD'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Show for a second'),
                  onPressed: () {
                    final progress = ProgressHUD.of(context);
                    progress?.show();
                    Future.delayed(const Duration(seconds: 1), () {
                      progress?.dismiss();
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('Show with text'),
                  onPressed: () {
                    final progress = ProgressHUD.of(context);
                    progress?.showWithText('Loading...');
                    Future.delayed(const Duration(seconds: 1), () {
                      progress?.dismiss();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}