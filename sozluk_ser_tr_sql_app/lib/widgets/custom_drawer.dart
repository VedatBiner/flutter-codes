// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/help_pages/pages/page_cinsiyet.dart';
import '../constants/help_pages/pages/page_cogul.dart';
import '../constants/help_pages/pages/page_kiril.dart';
import '../constants/help_pages/pages/page_latin.dart';
import '../constants/help_pages/pages/page_soru.dart';
import '../constants/help_pages/pages/page_zamirler.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../utils/csv_backup_helper.dart';
import '../utils/json_backup_helper.dart';
import 'confirmation_dialog.dart';
import 'notification_service.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;
  final Future<void> Function({required BuildContext context}) onLoadJsonData;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
    required this.isFihristMode,
    required this.onToggleViewMode,
    required this.onLoadJsonData,
  });

  void _showResetDatabaseDialog(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context: context,
      title: 'Veritabanını Sıfırla',
      content: const Text(
        'Tüm kelimeler silinecek. Emin misiniz?',
        style: kelimeText,
      ),
      confirmText: 'Sil',
      cancelText: 'İptal',
      confirmColor: deleteButtonColor,
      cancelColor: cancelButtonColor,
    );

    if (confirm == true) {
      final db = await WordDatabase.instance.database;
      await db.delete('words');

      if (!context.mounted) return;
      Navigator.of(context).maybePop();

      onDatabaseUpdated();

      NotificationService.showCustomNotification(
        context: context,
        title: 'Veritabanı Sıfırlandı',
        message: const Text('Tüm kayıtlar silindi.'),
        icon: Icons.delete_forever,
        iconColor: Colors.red,
        progressIndicatorColor: Colors.red,
        progressIndicatorBackground: Colors.red.shade100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: drawerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: drawerColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                'Menü',
                style: TextStyle(
                  color: menuColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Divider(thickness: 2, color: menuColor, height: 0),

            /// 📌 Görünüm değiştirme
            Tooltip(
              message: "Görünüm değiştir",
              child: ListTile(
                leading: Icon(Icons.swap_horiz, color: menuColor, size: 32),
                title: Text(
                  isFihristMode ? 'Klasik Görünüm' : 'Fihristli Görünüm',
                  style: drawerMenuText,
                ),
                onTap: () {
                  onToggleViewMode();
                  Navigator.of(context).maybePop();
                },
              ),
            ),

            /// 📌 Yardımcı Bilgiler - Alt Menülü
            ExpansionTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: menuColor,
                size: 32,
              ),
              title: const Text('Yardımcı Bilgiler', style: drawerMenuText),
              childrenPadding: const EdgeInsets.only(left: 24),
              collapsedIconColor: menuColor,

              children: [
                /// 📌 Alfabe - İçinde Latin ve Kiril seçenekleri
                ExpansionTile(
                  leading: Icon(Icons.sort_by_alpha, color: menuColor),
                  title: const Text('Alfabe', style: drawerMenuText),
                  childrenPadding: const EdgeInsets.only(left: 24),
                  collapsedIconColor: menuColor,

                  children: [
                    /// 📌 Latin harfleri sayfası
                    ListTile(
                      leading: Icon(Icons.sort_by_alpha, color: menuColor),
                      title: const Text('Latin', style: drawerMenuText),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaLatin(),
                          ),
                        );
                      },
                    ),

                    /// 📌 Kiril harfleri sayfası
                    ListTile(
                      leading: Icon(Icons.sort_by_alpha, color: menuColor),
                      title: const Text('Kiril', style: drawerMenuText),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaKiril(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                /// 📌 Gramer
                ExpansionTile(
                  leading: Icon(Icons.menu_book, color: menuColor),
                  title: const Text('Gramer', style: drawerMenuText),
                  childrenPadding: const EdgeInsets.only(left: 24),
                  collapsedIconColor: menuColor,

                  children: [
                    /// 📌 Kelimelerde cinsiyet
                    ListTile(
                      leading: Icon(Icons.wc, color: menuColor),
                      title: const Text(
                        'Kelimelerde Cinsiyet',
                        style: drawerMenuText,
                      ),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaCinsiyet(),
                          ),
                        );
                      },
                    ),

                    /// 📌 Kelimelerde çoğul kullanımı
                    ListTile(
                      leading: Icon(Icons.wc, color: menuColor),
                      title: const Text(
                        'Kelimelerde Çoğul Kullanımı',
                        style: drawerMenuText,
                      ),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaCogul(),
                          ),
                        );
                      },
                    ),

                    /// 📌 Şahıs zamirleri kullanımı
                    ListTile(
                      leading: Icon(Icons.wc, color: menuColor),
                      title: const Text(
                        'Şahıs Zamirleri Kullanımı',
                        style: drawerMenuText,
                      ),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaZamir(),
                          ),
                        );
                      },
                    ),

                    /// 📌 Soru cümleleri kullanımı
                    ListTile(
                      leading: Icon(Icons.question_mark, color: menuColor),
                      title: const Text(
                        'Soru Cümleleri Kullanımı',
                        style: drawerMenuText,
                      ),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SayfaSoru(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            /// 📌 Yedekleme (JSON/CSV)
            Tooltip(
              message: "JSON/CSV yedeği oluştur",
              child: ListTile(
                leading: Icon(
                  Icons.download,
                  color: downLoadButtonColor,
                  size: 32,
                ),
                title: const Text(
                  'Yedek Oluştur \n(JSON/CSV)',
                  style: drawerMenuText,
                ),
                onTap: () async {
                  final jsonPath = await createJsonBackup(context);
                  if (!context.mounted) return;
                  final csvPath = await createCsvBackup(context);
                  if (!context.mounted) return;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    NotificationService.showCustomNotification(
                      context: context,
                      title: 'JSON/CSV Yedeği Oluşturuldu',
                      message: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "JSON yedeği : ",
                              style: kelimeAddText,
                            ),
                            TextSpan(
                              text: ' $jsonPath',
                              style: normalBlackText,
                            ),
                            const TextSpan(
                              text: "\nCSV yedeği : ",
                              style: kelimeAddText,
                            ),
                            TextSpan(text: ' $csvPath', style: normalBlackText),
                          ],
                        ),
                      ),
                      icon: Icons.download,
                      iconColor: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      progressIndicatorBackground: Colors.blue.shade100,
                    );
                  });

                  if (!context.mounted) return;
                  Navigator.of(context).maybePop();
                },
              ),
            ),

            /// 📌 Veritabanını Yenile (JSON 'dan yükle)
            Tooltip(
              message: "Veritabanını Yenile",
              child: ListTile(
                leading: const Icon(
                  Icons.refresh,
                  color: Colors.amber,
                  size: 32,
                ),
                title: const Text(
                  'Veritabanını Yenile (SQL)',
                  style: drawerMenuText,
                ),
                onTap: () async {
                  Navigator.of(context).maybePop();
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (!context.mounted) return;
                  await onLoadJsonData(context: context);
                },
              ),
            ),

            /// 📌 Veritabanını Sıfırla
            Tooltip(
              message: "Veritabanını Sıfırla",
              child: ListTile(
                leading: Icon(Icons.delete, color: deleteButtonColor, size: 32),
                title: const Text(
                  'Veritabanını Sıfırla (SQL)',
                  style: drawerMenuText,
                ),
                onTap: () => _showResetDatabaseDialog(context),
              ),
            ),

            Divider(color: menuColor, thickness: 2),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    appVersion,
                    textAlign: TextAlign.center,
                    style: versionText,
                  ),
                  Text("Vedat Biner", style: nameText),
                  Text("vbiner@gmail.com", style: nameText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
