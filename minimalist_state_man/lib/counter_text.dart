import 'package:flutter/material.dart';
import 'package:minimalist_state_man/service_locator.dart';
import 'counter_state.dart';

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final state = getIt<CounterState>();
    return ValueListenableBuilder<int>(
       // ne dinlenecek ?
        valueListenable: state.counter,
        // ne build edilecek ?
        builder: (context, counterValue, child) {
          return Text(
            // yenilenen değer
            '$counterValue',
            style: TextStyle(
              fontSize: counterValue >= 0 ? 30 : 20,
              fontWeight:
                  counterValue >= 0 ? FontWeight.bold : FontWeight.normal,
              color: counterValue >= 0 ? Colors.green : Colors.red,
            ),
          );
        });
  }
}
