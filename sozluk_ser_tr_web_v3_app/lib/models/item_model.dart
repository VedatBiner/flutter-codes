// <📜 ----- item_model.dart ----->

/*
  🧠 Word Modeli — Sırpça ↔ Türkçe sözlük girdisi (Firestore + JSON)

  BU DOSYA NE İŞE YARAR?
  - Uygulamada kullandığımız tek bir “Word” veri tipini tanımlar.
  - Aynı modeli hem Firestore okuma/yazma (withConverter) hem de
    dosyaya export/import (JSON/CSV/XLSX üretimi için JSON kısmı) süreçlerinde kullanır.
  - Eşitlik, kopyalama ve dönüştürme (Firestore/JSON) işlemlerini tek yerde toplar.

  ALANLAR
  - id        : (opsiyonel) Firestore doküman kimliği (doc.id)
  - sirpca    : Sırpça kelime/ifade
  - turkce    : Türkçe karşılık
  - userEmail : Kaydı oluşturan/kaydeden kullanıcının e-postası

  NEDEN Equatable?
  - `Equatable` sayesinde iki Word nesnesi alan bazında karşılaştırılır (==),
    böylece Widget’larda rebuild ve liste farklarını yönetmek kolaylaşır.

  METOTLARIN ÖZETİ
  - copyWith(...)           : Var olan bir Word’den seçili alanları değiştirerek yeni bir Word üretir.
  - fromFirestore(...)      : Firestore DocumentSnapshot → Word dönüşümü (withConverter ‘from’ için).
  - toFirestore()           : Word → Firestore’a yazılacak Map dönüşümü (withConverter ‘to’ için).
  - fromJson(Map)           : JSON → Word (dosyadan/haricî kaynaktan içeri alma).
  - toJson({includeId})     : Word → JSON (dosyaya yazma/export). `includeId` ile id’yi dahil etmeyi seçebilirsin.
  - toString()              : Debug/log yazımı için okunabilir çıktı.

  FIRESTORE İLE KULLANIM
  ```dart
  final ref = FirebaseFirestore.instance
      .collection('kelimeler')
      .withConverter<Word>(
        fromFirestore: Word.fromFirestore,
        toFirestore: (w, _) => w.toFirestore(),
      );

  // Okuma:
  final snap = await ref.limit(1).get();
  final Word w = snap.docs.first.data();

  // Yazma:
  await ref.add(const Word(sirpca: 'primer', turkce: 'örnek', userEmail: 'x@y.com'));
*/

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

  /// ℹ️ ---- Firestore converter helpers ----

  /// 📌 Firestore -> Model (withConverter için)
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

  /// 📌 Model -> Firestore (id yazılmaz)
  Map<String, Object?> toFirestore() {
    return <String, Object?>{
      'sirpca': sirpca,
      'turkce': turkce,
      'userEmail': userEmail,
    };
  }

  /// 📌  ---- Genel JSON (dosyaya export/import) ----
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String?,
      sirpca: (json['sirpca'] as String?) ?? '',
      turkce: (json['turkce'] as String?) ?? '',
      userEmail: (json['userEmail'] as String?) ?? '',
    );
  }

  /// 📌 Dosyaya yazarken istersen `id` dahil edebilirsin.
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
