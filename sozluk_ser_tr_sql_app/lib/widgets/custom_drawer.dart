// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../db/db_helper.dart';
import '../providers/word_count_provider.dart';
import '../utils/csv_backup_helper.dart';
import '../utils/json_backup_helper.dart';
import 'confirmation_dialog.dart';
import 'help_page_widgets/drawer_list_tile.dart';
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
      Provider.of<WordCountProvider>(context, listen: false).updateCount();

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
                    DrawerListTile(
                      icon: Icons.wc,
                      title: 'Latin',
                      routeName: '/sayfaLatin',
                      iconColor: menuColor,
                    ),

                    /// 📌 Kiril harfleri sayfası
                    DrawerListTile(
                      icon: Icons.wc,
                      title: 'Kiril',
                      routeName: '/sayfaKiril',
                      iconColor: menuColor,
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
                    DrawerListTile(
                      icon: Icons.wc,
                      title: 'Kelimelerde Cinsiyet',
                      routeName: '/sayfaCinsiyet',
                      iconColor: menuColor,
                    ),

                    /// 📌 Kelimelerde çoğul kullanımı
                    DrawerListTile(
                      icon: Icons.wc,
                      title: 'Çoğul Kullanımı',
                      routeName: '/sayfaCogul',
                      iconColor: menuColor,
                    ),

                    /// 📌 Şahıs zamirleri kullanımı
                    DrawerListTile(
                      icon: Icons.question_mark,
                      title: 'Şahıs Zamirleri Kullanımı',
                      routeName: '/sayfaZamir',
                      iconColor: menuColor,
                    ),

                    /// 📌 Soru cümleleri kullanımı
                    DrawerListTile(
                      icon: Icons.question_mark,
                      title: 'Soru Cümleleri Kullanımı',
                      routeName: '/sayfaSoru',
                      iconColor: menuColor,
                    ),

                    /// 📌 Fiiller
                    ExpansionTile(
                      leading: Icon(Icons.menu, color: menuColor),
                      title: const Text('Fiiler', style: drawerMenuText),
                      childrenPadding: const EdgeInsets.only(left: 24),
                      collapsedIconColor: menuColor,

                      children: [
                        /// 📌 Geniş zaman / Şimdiki zaman
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'Şimdiki Zaman Kullanımı',
                          routeName: '/sayfaSimdikiGenisZaman',
                          iconColor: menuColor,
                        ),

                        /// 📌 Geçişli ve Dönüşlü Fiiller
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'Geçişli ve Dönüşlü Fiiler',
                          routeName: '/sayfaGecisliDonusluFiiller',
                          iconColor: menuColor,
                        ),

                        /// 📌 Gelecek zaman
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'Gelecek Zaman Kullanımı',
                          routeName: '/sayfaGelecekZaman',
                          iconColor: menuColor,
                        ),

                        /// 📌 Sık kullanılan fiiler
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'Sık Kullanılan Fiiler',
                          routeName: '/sayfaFiiller',
                          iconColor: menuColor,
                        ),
                      ],
                    ),

                    /// 📌 Sıfatlar
                    ExpansionTile(
                      leading: Icon(Icons.menu, color: menuColor),
                      title: const Text('Sıfatlar', style: drawerMenuText),
                      childrenPadding: const EdgeInsets.only(left: 24),
                      collapsedIconColor: menuColor,
                      children: [
                        /// 📌 İşaret Sıfatları
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'İşaret Sıfatları Kullanımı',
                          routeName: '/sayfaIsaretSifatlari',
                          iconColor: menuColor,
                        ),

                        /// 📌 Sahiplik Sıfatları
                        DrawerListTile(
                          icon: Icons.question_mark,
                          title: 'Sahiplik Sıfatları Kullanımı',
                          routeName: '/sayfaSahiplikSifatlari',
                          iconColor: menuColor,
                        ),
                      ],
                    ),

                    /// 📌 Uzun kısa kelime kullanımı
                    DrawerListTile(
                      icon: Icons.question_mark,
                      title: 'Uzun Kısa Kelime Kullanımı',
                      routeName: '/sayfaUzunKisa',
                      iconColor: menuColor,
                    ),
                  ],
                ),

                /// 📌 Yardımcı Kavramlar
                ExpansionTile(
                  leading: Icon(Icons.menu, color: menuColor),
                  title: const Text(
                    'Yardımcı Kavramlar',
                    style: drawerMenuText,
                  ),
                  childrenPadding: const EdgeInsets.only(left: 24),
                  collapsedIconColor: menuColor,
                  children: [
                    /// 📌 Sayılar
                    DrawerListTile(
                      icon: Icons.numbers,
                      title: 'Sayılar',
                      routeName: '/sayfaSayilar',
                      iconColor: menuColor,
                    ),

                    /// 📌 Günler
                    DrawerListTile(
                      icon: Icons.question_mark,
                      title: 'Günler',
                      routeName: '/sayfaGunler',
                      iconColor: menuColor,
                    ),

                    /// 📌 Saatler
                    DrawerListTile(
                      icon: Icons.question_mark,
                      title: 'Saatler',
                      routeName: '/sayfaSaatler',
                      iconColor: menuColor,
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
