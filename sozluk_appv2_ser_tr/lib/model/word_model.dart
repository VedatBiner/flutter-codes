/// kelimelerin modeli
class Words {
  final String wordId;
  final String sirpca;
  final String turkce;
  final String userEmail;

  Words({
    required this.wordId,
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  Words.fromJson(Map<String, Object?> json)
      : this(
    wordId: json['wordId'].toString(),
    sirpca: json['sirpca'].toString(),
    turkce: json['turkce'].toString(),
    userEmail: json['userEmail'].toString(),
  );

  Map<String, Object?> toJson() {
    return {
      'wordId': wordId,
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}