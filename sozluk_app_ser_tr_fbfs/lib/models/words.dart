/// <----- words.dart ----->
class Words {
  String wordId;
  String sirpca;
  String turkce;

  Words(
    this.wordId,
    this.sirpca,
    this.turkce,
  );

  /// parse işlemi
  factory Words.fromJson(
    String key,
    Map<dynamic, dynamic> json,
  ) {
    return Words(
      key,
      json["sirpca"] as String,
      json["turkce"] as String,
    );
  }
}
