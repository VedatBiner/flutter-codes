import 'package:flutter/material.dart';

class CounterState{
  // başlangıç değerini belirtmeliyiz.
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  void incrementCounter() {
    // değeri böyle arttırıyoruz.
    counter.value++;
  }

  void decrementCounter() {
    // değeri böyle arttırıyoruz.
    counter.value--;
  }

  void resetCounter() {
    // değeri resetliyoruz.
    counter.value = 0;
  }
}
