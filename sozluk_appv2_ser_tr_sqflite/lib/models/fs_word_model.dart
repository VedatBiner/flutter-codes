/// <----- fs_word_model.dart ----->
/// Firestore veri tabanı için model
library;

/// kelimelerin modeli
class FsWords {
  final String sirpca;
  final String turkce;
  final String userEmail;

  FsWords({
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  FsWords.fromJson(Map<String, Object?> json)
      : this(
    sirpca: json['sirpca'].toString(),
    turkce: json['turkce'].toString(),
    userEmail: json['userEmail'].toString(),
  );

  Map<String, Object?> toJson() {
    return {
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }
}