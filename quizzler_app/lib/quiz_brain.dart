import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzler_app/question.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizBrain {
  int _questionNumber = 0;

  /// soru-cevap listesi
  final List<Question> _questionBank = [
    Question(
      questionText: "You can lead a cow down stairs but not up stairs.",
      questionAnswer: false,
    ),
    Question(
      questionText: "Approximately one quarter of human bones are in the feet.",
      questionAnswer: true,
    ),
    Question(
      questionText: "A slug's blood  is green.",
      questionAnswer: true,
    ),
    Question(
      questionText: "Buzz Aldrin's mother's maiden name was 'moon'",
      questionAnswer: true,
    ),
    Question(
      questionText:
          "no piece of square dry paper can be folded in half more than 7 times",
      questionAnswer: false,
    ),
  ];

  /// Bir sonraki soruya geç
  void nextQuestion(BuildContext context) {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
      if (_questionNumber == _questionBank.length - 1) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Quiz alert !!!",
          desc: "quiz Completed...",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
        _questionNumber = 0;
      }
    }
  }

  /// soruyu al
  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  /// cevabı al
  bool getCorrectAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }
}
