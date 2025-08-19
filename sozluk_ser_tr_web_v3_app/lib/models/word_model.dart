// <📜 ----- word_model.dart ----->

// 📌 Flutter hazır paketleri
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Word extends Equatable {
  /// Firestore doküman ID (koleksiyonda doc.id)
  final String? id;
  final String sirpca;
  final String turkce;
  final String userEmail;

  const Word({
    this.id,
    required this.sirpca,
    required this.turkce,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [id, sirpca, turkce, userEmail];

  Word copyWith({
    String? id,
    String? sirpca,
    String? turkce,
    String? userEmail,
  }) {
    return Word(
      id: id ?? this.id,
      sirpca: sirpca ?? this.sirpca,
      turkce: turkce ?? this.turkce,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  // ---- Firestore converter helpers ----

  /// Firestore -> Model (withConverter için)
  static Word fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? _,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Word(
      id: doc.id,
      sirpca: (data['sirpca'] as String?) ?? '',
      turkce: (data['turkce'] as String?) ?? '',
      userEmail: (data['userEmail'] as String?) ?? '',
    );
  }

  /// Model -> Firestore (id yazılmaz)
  Map<String, Object?> toFirestore() {
    return <String, Object?>{
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  // ---- Genel JSON (dosyaya export/import) ----

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String?,
      sirpca: (json['sirpca'] as String?) ?? '',
      turkce: (json['turkce'] as String?) ?? '',
      userEmail: (json['userEmail'] as String?) ?? '',
    );
  }

  /// Dosyaya yazarken istersen `id` dahil edebilirsin.
  Map<String, dynamic> toJson({bool includeId = true}) {
    final map = <String, dynamic>{
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
    if (includeId && id != null) map['id'] = id;
    return map;
  }

  @override
  String toString() =>
      'Word(id: $id, $sirpca ➜ $turkce, userEmail: $userEmail)';
}
