/// <----- sql_word_model.dart ----->
library;

/// kelimelerin modeli
class SqlWords {
  final String wordId;
  final String sirpca;
  final String turkce;
  final String userEmail;

  SqlWords({
    required this.wordId,
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  SqlWords.fromJson(Map<String, Object?> json)
      : this(
    wordId: json['wordId'].toString(),
    sirpca: json['sirpca'].toString(),
    turkce: json['turkce'].toString(),
    userEmail: json['userEmail'].toString(),
  );

  Map<String, Object?> toJson() {
    return {
     // 'wordId': wordId,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  @override
  String toString() {
    return 'SqlWords{sirpca: $sirpca, turkce: $turkce, userEmail: $userEmail}';
  }
}