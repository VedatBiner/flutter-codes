import 'package:flutter/material.dart';
import 'package:minimalist_state_man/service_locator.dart';
import 'counter_state.dart';

class AppbarIcon extends StatelessWidget {
  const AppbarIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<CounterState>();
    return ValueListenableBuilder<int>(
        valueListenable: state.counter,
        builder: (context, counterValue, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              counterValue >= 0 ? Icons.mood : Icons.mood_bad,
              color: counterValue >= 0 ? Colors.green : Colors.red,
            ),
          );
        });
  }
}
