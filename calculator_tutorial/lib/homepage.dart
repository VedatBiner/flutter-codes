import 'package:calculator_tutorial/buttons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final myTextStyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);
  var userQuestion = "";
  var userAnswer = "";

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userQuestion,
                        style: const TextStyle(fontSize: 20,),),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userQuestion,
                        style: const TextStyle(fontSize: 20,),),
                    )
                  ],
                ),
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
                    // Clear button
                    if (index == 0){
                      return MyButton(
                        buttonTapped: (){
                          setState(() {
                            userQuestion = "";
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.green,
                        textColor: Colors.white,
                      );
                    } else if (index == 1){
                      // Delete button
                        return MyButton(
                          buttonTapped: (){
                            setState(() {
                              userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.red,
                          textColor: Colors.white,
                      );
                    } else {
                        return MyButton(
                          buttonTapped: (){
                            setState(() {
                              userQuestion += buttons[index];
                            });
                        },
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











