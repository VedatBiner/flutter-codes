// 📃 <----- custom_drawer.dart ----->
// Drawer menüye buradan erişiliyor.

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/text_constants.dart';
import '../utils/backup_notification_helper.dart';
import '../utils/database_reset_helper.dart';
import 'help_page_widgets/drawer_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDatabaseUpdated;
  final String appVersion;
  final bool isFihristMode;
  final VoidCallback onToggleViewMode;

  /// 📌 JSON ’dan veri yüklemek için üst bileşenden gelen fonksiyon
  ///    İmza → ({ctx, onStatus})
  final Future<void> Function({
    required BuildContext ctx,
    required void Function(bool, double, String?, Duration) onStatus,
  })
  onLoadJsonData;

  const CustomDrawer({
    super.key,
    required this.onDatabaseUpdated,
    required this.appVersion,
    required this.isFihristMode,
    required this.onToggleViewMode,
    required this.onLoadJsonData,
  });

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
                      icon: Icons.calendar_month_sharp,
                      title: 'Günler',
                      routeName: '/sayfaGunler',
                      iconColor: menuColor,
                    ),

                    /// 📌 Saatler
                    DrawerListTile(
                      icon: Icons.watch_later_outlined,
                      title: 'Saatler',
                      routeName: '/sayfaSaatler',
                      iconColor: menuColor,
                    ),
                  ],
                ),
              ],
            ),

            /// 📌 Yedek oluştur (JSON/CSV/XLSX)
            Tooltip(
              message: "JSON/CSV/XLSX yedeği oluştur",
              child: ListTile(
                leading: Icon(
                  Icons.download,
                  color: downLoadButtonColor,
                  size: 32,
                ),
                title: const Text(
                  'Yedek Oluştur \n(JSON/CSV/XLSX)',
                  style: drawerMenuText,
                ),
                onTap: () async {
                  await createAndNotifyBackup(context);
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
                  await onLoadJsonData(
                    ctx: context,
                    onStatus: (_, __, ___, ____) {},
                  );
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
                onTap: () async {
                  await showResetDatabaseDialog(
                    context,
                    onAfterReset: () {
                      onDatabaseUpdated(); // listeyi yenile
                    },
                  );
                },
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
