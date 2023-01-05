import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/color_theme_data.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tema seçimi yapınız.",
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SwitchCard(),
    );
  }
}

class SwitchCard extends StatelessWidget {
  const SwitchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text greenText = const Text(
      "Green",
      style: TextStyle(
        color: Colors.green,
      ),
    );
    Text redText = const Text(
      "Red",
      style: TextStyle(
        color: Colors.red,
      ),
    );
    bool _value = Provider.of<ColorThemeData>(context).isGreen;
    return Card(
      child: SwitchListTile(
        subtitle: _value ? greenText : redText,
        title: const Text(
          "Change Theme Color",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        value: _value,
        onChanged: (bool value) {
          Provider.of<ColorThemeData>(context, listen: false)
              .switchTheme(value);
        },
      ),
    );
  }
}
