// ============================================================================
// 🌐 OMDbSeriesLoader – Dizi Metadata Servisi
// ============================================================================
//
// Bu servis sınıfı OMDb API üzerinden dizi metadata bilgilerini çeker
// ve sonucu doğrudan SeriesGroup modeline uygular.
//
// ---------------------------------------------------------------------------
// 🎯 Sorumlulukları
// ---------------------------------------------------------------------------
// • Dizi adına göre OMDb sorgusu yapmak
// • Gerekirse fallback arama (search) yapmak
// • imdbID ile detay çağrısı yapmak
// • Gelen JSON verisini SeriesGroup modeline yazmak
// • Poster "N/A" ise null ’a çevirmek
//
// ---------------------------------------------------------------------------
// 🔎 Mimari Not
// ---------------------------------------------------------------------------
// Bu sınıf UI ’dan tamamen bağımsızdır.
// SeriesTile yalnızca loadIfNeeded() çağırır.
// Veri yazımı doğrudan SeriesGroup içine yapılır.
//
// ============================================================================

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../constants/file_info.dart';
import '../models/series_models.dart';

class OmdbSeriesLoader {
  static const tag = "omdb_series";

  // ==========================================================================
  // 🔄 loadIfNeeded
  // ==========================================================================
  /// Verilen SeriesGroup için OMDb metadata bilgisini yükler.
  ///
  /// Çalışma sırası:
  /// 1️⃣ Eğer group.imdbId doluysa → zaten yüklenmiş kabul edilir, çıkılır.
  /// 2️⃣ title (t=) parametresi ile doğrudan arama yapılır.
  /// 3️⃣ Eğer Response == False ise → fallback olarak search (s=) yapılır.
  /// 4️⃣ Search sonucundan ilk "series" tipi bulunur.
  /// 5️⃣ imdbID ile detay (i=) çağrısı yapılır.
  /// 6️⃣ Gelen veri _applyData() ile modele yazılır.
  ///
  /// Neden lazy?
  /// - Uygulama açılırken tüm diziler için OMDb çağrısı yapmak pahalıdır.
  /// - Kullanıcı sadece tıkladığı dizinin bilgisini görmek ister.
  ///
  static Future<void> loadIfNeeded(SeriesGroup group) async {

    // ✅ Zaten imdbId varsa tekrar API çağrısı yapmayız
    if (group.imdbId != null && group.imdbId!.isNotEmpty) {
      log("⏭ Dizi zaten yüklü: ${group.seriesName}", name: tag);
      return;
    }

    try {
      final title = Uri.encodeQueryComponent(group.seriesName);

      // ----------------------------------------------------------------------
      // 1️⃣ Direkt başlık ile sorgu (type=series önemli!)
      // ----------------------------------------------------------------------
      final url = Uri.parse(
        "https://www.omdbapi.com/?t=$title&type=series&apikey=$apiKey",
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      // ----------------------------------------------------------------------
      // Eğer doğrudan eşleşme bulunamazsa fallback search yapılır
      // ----------------------------------------------------------------------
      if (data["Response"] == "False") {

        final searchUrl = Uri.parse(
          "https://www.omdbapi.com/?s=$title&type=series&apikey=$apiKey",
        );

        final searchRes = await http.get(searchUrl);
        final searchData = jsonDecode(searchRes.body);

        // Search sonucu hiç yoksa çık
        if (searchData["Search"] == null) {
          log("❌ OMDb bulamadı: ${group.seriesName}", name: tag);
          return;
        }

        // İlk "series" tipindeki sonucu al
        final firstSeries = searchData["Search"]
            .firstWhere((e) => e["Type"] == "series");

        final imdbId = firstSeries["imdbID"];

        // ------------------------------------------------------------------
        // 3️⃣ imdbID ile detay çağrısı
        // ------------------------------------------------------------------
        final detailUrl = Uri.parse(
          "https://www.omdbapi.com/?i=$imdbId&apikey=$apiKey",
        );

        final detailRes = await http.get(detailUrl);
        final detailData = jsonDecode(detailRes.body);

        _applyData(group, detailData);
        return;
      }

      // Eğer doğrudan eşleşme varsa direkt uygula
      _applyData(group, data);

    } catch (e) {
      // Ağ hatası, JSON hatası vs.
      log("🚨 OMDb series error: $e", name: tag);
    }
  }

  // ==========================================================================
  // 🧠 _applyData
  // ==========================================================================
  /// OMDb ’den gelen JSON verisini SeriesGroup modeline uygular.
  ///
  /// Neden ayrı metod?
  /// - loadIfNeeded() içinde kod tekrarını önler.
  /// - Tek sorumluluk prensibini korur.
  ///
  /// Dönüşüm kuralları:
  /// • Poster "N/A" ise null yapılır.
  /// • imdbRating boş gelebilir → olduğu gibi yazılır.
  ///
  static Future<void> _applyData(SeriesGroup group, Map<String, dynamic> data) async {

    group.originalTitle = data["Title"];
    group.year = data["Year"];
    group.genre = data["Genre"];
    group.rating = data["imdbRating"];
    group.type = data["Type"];
    group.imdbId = data["imdbID"];

    final poster = data["Poster"];
    group.poster = (poster != null && poster != "N/A") ? poster : null;

    log("✅ Dizi yüklendi: ${group.originalTitle}", name: tag);
  }
}