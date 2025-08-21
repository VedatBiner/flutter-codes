// <📜 ----- home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — Firestore’dan okuma + JSON/CSV/Excel dışa aktarma

  NE YAPAR?
  - Uygulama açıldığında kelimeler koleksiyonunu **bir kez okur** ve özetini ekranda gösterir.
    (bkz. `readWordsOnce()`; toplam kayıt sayısı ve örnek bir belgeyi log’lar)
  - “JSON + CSV + Excel Dışa Aktar” butonu ile tüm koleksiyonu sayfalı (paginated) şekilde
    **sirpca alanına göre sıralı** okuyup üç formatta dışa aktarır:
      • JSON  → pretty-print, ID alanı çıkartılmış
      • CSV   → UTF-8 BOM’lu, başlık satırıyla (sirpca,turkce,userEmail)
      • XLSX  → başlık kalın & koyu mavi + beyaz, ilk 3 kolona AutoFilter, auto-fit
    (bkz. `exportWordsToJsonCsvXlsx()`; platforma göre kaydetme/indirme `JsonSaver` ile yapılır)

  KULLANILAN SERVİSLER
  - `readWordsOnce()`      : Firestore’dan tek atımlık okuma; log’a kısa özet yazar, ekrana durum (status) döndürür.
  - `exportWordsToJsonCsvXlsx()` : Firestore → JSON/CSV/XLSX üretir, kaydeder ve çıktı yollarını döndürür.

  UI AKIŞI
  - Orta ekranda bir durum metni (`status`) gösterilir.
  - “Dışa Aktar” tıklandığında buton kilitlenir (`exporting=true`), işlem bittiğinde yollar snackbar ile duyurulur.
  - “Yeniden Oku” tıklandığında koleksiyon tekrar okunur ve `status` güncellenir.

  PLATFORM NOTLARI
  - Web: tarayıcı indirmesi (Blob + <a download>), klasör kavramı yok.
  - Android/Desktop: Downloads klasörüne yazma denenir (gerekirse izin), iOS’ta Belgeler + Paylaş.
  - XLSX üretimi Syncfusion XlsIO ile yapılır (AutoFilter ve auto-fit için).

  ÖN KOŞULLAR
  - Firestore’da `orderBy('sirpca') + orderBy(docId)` sorgusu bir **composite index** gerektirebilir.
    Konsoldaki otomatik linki takip ederek bir kez oluşturun.
  - Android’de depolama izinleri doğru verilmiş olmalı (permission_handler ile istenir).

  ÖZELLEŞTİRME
  - Dışa aktarma sayfa boyutu: `pageSize: 1000`
  - Alt klasör adı: `subfolder: 'kelimelik_words_app'`
  - Dosya adları `file_info.dart` içinden yönetilir.

  HATA YÖNETİMİ
  - Hatalar `status` alanına yazılır ve Snackbar ile kullanıcıya gösterilir.
*/

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/info_constants.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/export_words.dart';
import '../services/words_reader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = 'Hazır. Konsolu kontrol edin.';
  bool exporting = false;

  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  // context 'i await 'ten önce resolve edip saklayan güvenli helper
  void _showSnack(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return; // widget dispose olmuş olabilir
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _runInitialRead();
    _getAppVersion();
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  Future<void> _runInitialRead() async {
    final s = await readWordsOnce();
    if (!mounted) return;
    setState(() => status = s);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 📜 AppBar
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: CustomAppBar(
            appBarName: appBarName,
            //    isSearching: isSearching,
            //    searchController: searchController,
            //    onSearchChanged: _filterWords,
            //    onClearSearch: _clearSearch,
            //    onStartSearch: () => setState(() => isSearching = true),
            //    itemCount: words.length,
          ),
        ),

        /// 📁 Drawer
        drawer: CustomDrawer(
          // onDatabaseUpdated: _loadWords,
          appVersion: appVersion,
          // isFihristMode: isFihristMode,
          // onToggleViewMode: () {
          //   setState(() => isFihristMode = !isFihristMode);
          // },

          //  ⬇️  Yeni imzalı geri-çağrı
          // onLoadJsonData:
          //     ({
          //       required BuildContext ctx, // Drawer ’dan gelir, kullanmıyoruz
          //       required void Function(
          //         bool loading,
          //         double prog,
          //         String? currentWord,
          //         Duration elapsedTime,
          //       )
          //       onStatus,
          //     }) async {
          //       await loadDataFromDatabase(
          //         context: context, //  ⚠️  HomePage’in context ’i
          //         onLoaded: (loadedWords) {
          //           setState(() {
          //             // allWords = loadedWords;
          //             // words = loadedWords;
          //           });
          //
          //           // if (mounted) {
          //           //   Provider.of<WordCountProvider>(
          //           //     context,
          //           //     listen: false,
          //           //   ).setCount(loadedWords.length);
          //           // }
          //         },
          //
          //         //  ⬇️  Drawer ’a da aynı geri-bildirimi ilet
          //         onLoadingStatusChange:
          //             (
          //               bool loading,
          //               double prog,
          //               String? currentWord,
          //               Duration elapsed,
          //             ) {
          //               setState(() {
          //                 //    isLoadingJson = loading;
          //                 //    progress = prog;
          //                 //    loadingWord = currentWord;
          //                 //    elapsedTime = elapsed;
          //               });
          //               onStatus(
          //                 loading,
          //                 prog,
          //                 currentWord,
          //                 elapsed,
          //               ); // ↩︎ ilet
          //             },
          //       );
          //     },
        ),

        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(status, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: exporting
                        ? null
                        : () async {
                            setState(() {
                              exporting = true;
                              status = 'JSON + CSV + Excel hazırlanıyor...';
                            });

                            // await 'ten önce messenger 'ı al
                            final messenger = ScaffoldMessenger.maybeOf(
                              context,
                            );

                            try {
                              final res = await exportWordsToJsonCsvXlsx(
                                pageSize: 1000,
                                subfolder: 'kelimelik_words_app',
                              );

                              if (!mounted) return;
                              setState(
                                () => status =
                                    'Tamam: ${res.count} kayıt • JSON: ${res.jsonPath} • CSV: ${res.csvPath} • XLSX: ${res.xlsxPath}',
                              );

                              // güvenli kullanım: messenger üzerinden
                              messenger?.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Kaydedildi:\nJSON → ${res.jsonPath}\nCSV  → ${res.csvPath}\nXLSX → ${res.xlsxPath}',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              setState(() => status = 'Hata: $e');
                              messenger?.showSnackBar(
                                SnackBar(content: Text('Hata: $e')),
                              );
                            } finally {
                              if (!mounted) return;
                              setState(() => exporting = false);
                            }
                          },

                    icon: const Icon(Icons.download),
                    label: const Text('JSON + CSV + Excel Dışa Aktar'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      setState(() => status = 'Koleksiyon okunuyor...');

                      // await 'ten önce al
                      final messenger = ScaffoldMessenger.maybeOf(context);

                      final s = await readWordsOnce();
                      if (!mounted) return;
                      setState(() => status = s);

                      // gerekirse bilgi vermek için
                      // messenger?.showSnackBar(SnackBar(content: Text('Okuma tamam')));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Yeniden Oku'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
