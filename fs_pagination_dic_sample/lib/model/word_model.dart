class Word {
  Word({
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  Word.fromJson(Map<String, Object?> json)
      : this(
    sirpca: json['sirpca'].toString(),
    turkce: json['turkce'].toString(),
    userEmail: json['userEmail'].toString(),
  );

  final String sirpca;
  final String turkce;
  final String userEmail;

  Map<String, Object?> toJson() {
    return {
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}