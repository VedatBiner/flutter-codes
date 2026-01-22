# netflix_watchlist_v2_app

Netflix watch list App v2

Netflix 'de izlediğimiz filmler ve dizileri listeleyen sıralayan bir uygulama


1. Netflix 'ten güncel izleme listemiz indiriliyor. Bu dosya CSV formatında. - 17.11.2025
2. Ana sayfa ve grafikler için `home_page.dart` ve `stats_page.dart`dosyaları oluşturuldu. - 17.11.2025
3. modeller için `netflix_item.dart` ve `series_models.dart` dosyaları oluşturuldu. - 17.11.2025
4. Csv ve API işlemleri için `csv_page.dart` ve `omdb_lazy_loader.dart` dosyaları oluşturuldu. - 17.11.2025
5. proje dosyalarını yeni uygulama açıp foray taşındı. - 17.11.2025
6. `theme.dart` dosyası oluşturuldu. - 17.11.2025
7. `package_info_plus` ve `device_info_plus` paketleri eklendi. - 17.11.2025
8. `permission_handler` ve `external_path` paketi eklendi. - 18.11.2025
9. `storage_permission_helper.dart` dosyası oluşturuldu. - 18.11.2025
10. `path` ve `path_provider` paketleri eklendi. - 18.11.2025
11. `download_helper.dart` ve `download_directory_helper.dart` dosyaları oluşturuldu. - 18.11.2025
12. `home_page.dart`içine ilk çalışmada izin kontrolü metodu eklendi. - 18.11.2025
13. Uygulama ikonu değiştirildi. - 18.11.2025
14. `color_constants.dart` ve `text_constants.dart` dosyaları oluşturuldu. - 19.11.2025
15. `custom_drawer.dart`, `drawer_title.dart`, `drawer_info_padding_tile.dart` dosyaları oluşturuldu. - 19.11.2025
16. `csv_export_all.dart` ve `csv_move_to_download.dart` dosyaları oluşturuldu. - 19.11.2025
17. ikon değişikliği yapıldı. - 20.11.2025
18. Mini dizi / Film ayrımı düzeltildi. - 20.01.2026
19. `pubspec.yaml` dosyasında açıklamalar düzenlendi. - 20.01.2026
20. `csv_parser.dart` dosyası düzenlendi. - 20.01.2026
21. `theme.dart` dosyası güncellendi. - 20.01.2026
22. `home_page.dart` dosyası düzenlendi. - 20.01.2026
23. `custom_drawer.dart` dosyası düzenlendi. - 20.01.2026
24. `drawer_info_padding_tile_dart` dosyası düzenlendi. - 22.01.2026
25. `custom_drawer.dart` dosyası düzenlendi. - 22.01.2026
26. `drawer_share_tile.dart` dosyası eklendi. - 22.01.2026
27. `drawer_backup_tile.dart` dosyası eklendi. - 22.01.2026
28. `show_notification_handler.dart` dosyası eklendi. - 22.01.2026
29. `elegant_notification` ve `share_plus` paketi eklendi. - 22.01.2026
30. `filter_chips.dart` ve `filer_option.dart` dosyası oluşturuldu. - 22.01.2026











Yapılacaklar:
- Drawer menü ile versiyon bilgisi al
- Download dizinlerine yazma izinlerini hallet. Bu işlem home_page_dart içinde en başta olsun.
- Tema görünümü ve dosya adlarını düzenle
- ikon görüntülerini düzelt
- csv dosyayı film bilgilerini de içerecek şekilde büyüt
- bu CSV dosyasından sql (db), xlsx / json yedek gönderimi için zip dosyaları oluştur.
- pubspec.yaml sayfasını düzenle
- Dark mode / light mode kodu oluştur.