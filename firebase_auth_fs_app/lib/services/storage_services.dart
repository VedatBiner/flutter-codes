/// <----- storage_services.dart ----->
///
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Firebase bağlantısı
FirebaseStorage storage = FirebaseStorage.instance;

/// Referans yapısı
/// Storage 'ın root dizinindeki dosyaya referans verelim
Reference ref = storage.ref("read_me.txt");

/// Storage içindeki bir klasörde bulunan dosyaya referans verelim
/// kök dizine git
/// klasörü seç
/// dosyayı seç
Reference fileReference =
    storage.ref().child("images").child("profilephoto.png");

class StorageServices {
  /// listeleme İşlemleri
  /// belli bir dizindeki tüm dosyaları listeleme
  Future<void> listExample() async {
    /// listeleme sonuçları ListResult tipinde döner.
    /// root dizindeki tüm dosyaları listele
    ListResult result = await storage.ref().child("users").listAll();

    /// root dizindeki users dizindeki tüm dosyaların listesi
    ListResult usersResult = await storage.ref().child("users").listAll();

    /// ListResult içinde Reference tipindeki
    /// veriler forEach ile (vey for) döndürülür.
    for (var ref in result.items) {
      print("found file : $ref");
    }

    /// dosyanın dizinini yazdır
    for (var ref in result.prefixes) {
      print("found directory : $ref");
    }
  }

  /// Belirli sayıda dosyayı listelemek
  /// Genelde pagination için kullanılır.
  Future<void> listExamplewithLimit() async {
    /// 210 dosyalık liste hazırla
    ListResult result = await storage.ref().list(
          const ListOptions(maxResults: 10),
        );
  }

  /// Dosya yükleme (upload)
  Future<void> uploadFile(String filePath) async {
    /// yüklenecek dosya
    File file = File(filePath);
    try {
      /// dosyanın yükleneceği dizin
      await storage
          .ref('uploads/file-to-upload.png')

          /// dosyayı yükle-yerine koy
          .putFile(file);
    } on FirebaseException catch (e) {
      /// hata çıkarsa yakala
      print(e.toString());
    }
  }

  /// Dosya İndirme (download)
  Future<void> downloadFile() async {
    /// dosya ve dizin referansları
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File("${appDocDir.path}/download-logo.png");
    try {
      /// storage 'daki dosyaya git
      await storage.ref("uploads/logo.png").writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  /// Silme (delete) İşlemi
  Future<void> deleteFile() async {
    try {
      /// root dizinden bir dosya silelim. (Storage/vedat.png)
      await storage.ref("vedat.png").delete();

      /// users dizininden bir dosya silelim. (Storage/users/vedat.png)
      await storage.ref().child("users").child("vedat.png").delete();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  /// Dosya yüklerken duraklatma, devam etme ve
  /// iptal işlemleri (Pause, resume, cancel)

  Future<void> handleTaskExample3(String filePath) async {
    File largeFile = File(filePath);

  /// Bu işlemler için bir UploadTask nesnesi tanımlarız
    UploadTask task = storage.ref('uploads/hello-world.txt')
        .putFile(largeFile);

    /// Yüklemeyi duraklat.
    bool paused = await task.pause();
    print('paused, $paused');

    /// Yüklemeyi devam ettir.
    bool resumed = await task.resume();
    print('resumed, $resumed');

    /// Yüklemeyi iptal et.
    bool canceled = await task.cancel();
    print('canceled, $canceled');
  }
}












