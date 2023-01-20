import 'package:calculator_tutorial/buttons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> buttons =
      [
        "C", "DEL", "%", "/",
        "9", "8", "7", "x",
        "6", "5", "4", "-",
        "3", "2", "1", "+",
        "0", ".", "ANS", "=",
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Container(
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.builder(
                // her sırada dört düğme olsun
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  if (index == 0){
                    return MyButton(
                      buttonText: buttons[index],
                      color: Colors.green,
                      textColor: Colors.white,
                    );
                  } else if (index == 1){
                    return MyButton(
                      buttonText: buttons[index],
                      color: Colors.red,
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      buttonText: buttons[index],
                      color: isOperator(buttons[index]) ? Colors.deepPurple : Colors.deepPurple.shade50,
                      textColor: isOperator(buttons[index]) ? Colors.white : Colors.deepPurple,
                    );
                }}
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x){
    if (x == "%" || x == "/" || x == "x" || x == "-" || x == "+" || x == "="){
      return true;
    }
    return false;
  }

}



