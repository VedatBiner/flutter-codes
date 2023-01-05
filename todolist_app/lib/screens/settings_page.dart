import 'package:flutter/material.dart';
import '../models/color_theme_data.dart';
import 'package:provider/provider.dart';

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

class SwitchCard extends StatefulWidget {
  const SwitchCard({Key? key}) : super(key: key);

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  bool _value = true;

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
          setState(() {
            _value = value;
          });
          Provider.of<ColorThemeData>(context, listen: false)
              .switchTheme(value);
        },
      ),
    );
  }
}
