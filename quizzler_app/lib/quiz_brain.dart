import 'package:quizzler_app/question.dart';

class QuizBrain {
  int _questionNumber = 0;

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

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getCorrectAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }
}








