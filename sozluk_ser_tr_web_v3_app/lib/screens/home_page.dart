// <📜 ----- home_page.dart ----->
/*
  🖥️ Ana Ekran (HomePage) — AppBar + Drawer, açılışta tek seferlik Firestore okuma

  BU EKRAN NE YAPAR?
  - Uygulama açıldığında `readWordsOnce()` ile kelimeler koleksiyonunu **bir kez okur**
    (toplam kayıt ve örnek belgeyi log’a yazar). Bu ekranda içerik göstermiyoruz.
  - Dışa aktarma (JSON/CSV/XLSX) ve yeniden okuma gibi işlemler **Drawer içindeki öğelerden**
    tetiklenir:
      • “Yedek oluştur (JSON/CSV/XLSX)” → DrawerBackupTile (export helper üzerinden)
      • “Verileri tekrar oku” → CustomDrawer, `onReload` callback’i ile `readWordsOnce()` çağırır
        ve Snackbar’la kullanıcıyı bilgilendirir.

  UI YAPISI
  - Üstte `CustomAppBar` (başlık/stil), solda `CustomDrawer` (menü).
  - Ana gövde bilinçli olarak boş/temiz bırakıldı; tüm aksiyonlar Drawer menüsünden başlatılır.

  KULLANILAN SERVİSLER / HELPER’LAR
  - `readWordsOnce()`          : Firestore’dan kısa özet okur, log’a yazar, kısa durum metni döndürür.
  - (Drawer tarafı) export     : `exportWordsToJsonCsvXlsx()` ve `JsonSaver` kullanır.
  - (Drawer tarafı) yeniden oku: Bu sayfadaki `_handleReload()` callback’i üzerinden `readWordsOnce()`.

  ÖNEMLİ NOTLAR
  - Firestore’da büyük koleksiyonlar için export sırasında `orderBy('sirpca') + orderBy(docId)`
    sorgusu **composite index** isteyebilir (konsoldaki linkten bir kez oluşturun).
  - Android’de Downloads klasörüne yazmak için gerekli izinler `permission_handler` ile yönetilir.

  HATA YÖNETİMİ
  - Drawer’dan tetiklenen işlemler (export/yeniden okuma) Snackbar ile kullanıcıya bildirilir.
  - Ayrıntılı hatalar/özetler log’a düşer.
*/

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 📌 Yardımcı yüklemeler burada
import '../constants/info_constants.dart';
import '../services/word_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ℹ️  Uygulama versiyonu
  String appVersion = '';

  // context 'i await 'ten önce resolve edip saklayan güvenli helper
  // void _showSnack(String message) {
  //   final messenger = ScaffoldMessenger.maybeOf(context);
  //   if (messenger == null) return; // widget dispose olmuş olabilir
  //   messenger.showSnackBar(SnackBar(content: Text(message)));
  // }

  @override
  void initState() {
    super.initState();
    _runInitialRead();
    _getAppVersion();
  }

  // 👇 Drawer ’dan çağrılacak “yeniden oku” eylemi
  Future<void> _handleReload() async {
    // await ’ten önce Messenger ’ı al → güvenli kullanım
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      const SnackBar(content: Text('Koleksiyon okunuyor...')),
    );

    final result =
        await WordService.readWordsOnce(); // log ’lar + kısa durum metni döner
    if (!mounted) return;

    messenger?.showSnackBar(SnackBar(content: Text(result)));
  }

  /// 📌 Versiyonu al
  void _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = 'Versiyon: ${info.version}');
  }

  Future<void> _runInitialRead() async {
    final s = await WordService.readWordsOnce();
    if (!mounted) return;
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

        /// 📌 Drawer Burada
        drawer: CustomDrawer(
          appVersion: appVersion,
          onReload: _handleReload,
          // onDatabaseUpdated: _loadWords,
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

        /// 📌 Body Burada
        ///
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SizedBox(height: 20)],
              ),
            ),
          ),
        ),

        /// 📌 FAB Burada
        ///
        floatingActionButton: CustomFAB(
          onWordAdded: _handleReload,
          // refreshWords: _loadWords,
          // clearSearch: _clearSearch,
        ),
      ),
    );
  }
}
