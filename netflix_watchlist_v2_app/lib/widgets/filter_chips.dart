// 📁 lib/widgets/filter_chips.dart
//
// ============================================================================
// 🎛 FilterChips – Liste Filtreleme Bileşeni
// ============================================================================
//
// Bu widget, ana ekranda film/dizi listesini filtrelemek için kullanılan
// ChoiceChip tabanlı filtre çubuklarını üretir.
//
// ---------------------------------------------------------------------------
// 🎯 Amaç
// ---------------------------------------------------------------------------
// • Kullanıcıya listeyi kategori bazlı filtreleme imkânı sunmak.
// • Filtre seçimini parent widget ’a callback ile iletmek.
// • Stil/tema ayarlarını tek noktadan yönetmek.
//
// ---------------------------------------------------------------------------
// 🧠 Mimari Rol
// ---------------------------------------------------------------------------
// Bu widget SADECE UI üretir.
// Filtreleme mantığı burada yapılmaz.
//
// Seçim değiştiğinde:
//    onSelected(option)
// çağrılır ve asıl filtreleme işlemi parent widget içinde yapılır.
//
// Böylece:
// ✅ Tek sorumluluk prensibi korunur.
// ✅ UI ile iş mantığı ayrılmış olur.
// ============================================================================

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../models/filter_option.dart';

class FilterChips extends StatelessWidget {
  /// 🔎 Şu an aktif olan filtre.
  /// Parent widget tarafından belirlenir.
  final FilterOption filter;

  /// 🎯 Kullanıcı bir chip seçtiğinde tetiklenecek callback.
  /// Filtre değişimini yukarı bildirir.
  final ValueChanged<FilterOption> onSelected;

  const FilterChips({
    super.key,
    required this.filter,
    required this.onSelected,
  });

  // ==========================================================================
  // 🏗 build()
  // ==========================================================================
  /// FilterChips bileşeninin UI ağacını üretir.
  ///
  /// İçerik:
  ///  • ChipTheme: Chip ’lerin genel görsel stilini belirler (renk, font, şekil)
  ///  • Wrap: Chip ’leri yatay akışta dizer, ekrana sığmazsa alt satıra geçirir
  ///
  /// Not:
  ///  • ChipThemeData içindeki labelStyle / selectedColor gibi ayarlar sayesinde
  ///    her ChoiceChip’i tek tek özelleştirmek zorunda kalmayız.
  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: ChipThemeData(
        /// Chip ’in seçili değilken arka plan rengi
        backgroundColor: drawerColor,

        /// Chip seçili olduğunda arka plan rengi
        selectedColor: editButtonColor,

        /// Seçili değilken label stili
        labelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(color: menuColor),

        /// Seçiliyken label stili (secondaryLabelStyle)
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Oswald',
        ).copyWith(color: menuColor),

        /// Chip şekli (oval/stadium)
        shape: const StadiumBorder(),

        /// Material default checkmark ’i kapatıyoruz
        showCheckmark: false,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          spacing: 8,
          children: [
            _filterChip("Tümü", FilterOption.all),
            _filterChip("Filmler", FilterOption.movies),
            _filterChip("Diziler", FilterOption.series),
            _filterChip("Son 30 Gün", FilterOption.last30days),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 🧩 _filterChip()
  // ==========================================================================
  /// Tek bir filtre seçeneği için ChoiceChip üretir.
  ///
  /// Parametreler:
  ///  • label  : Kullanıcıya görünen yazı
  ///  • option : Bu chip ’in temsil ettiği FilterOption değeri
  ///
  /// Çalışma:
  ///  • selected = (filter == option) ile seçili durum hesaplanır.
  ///  • Kullanıcı chip ’e tıklayınca onSelected(option) çağrılır.
  ///
  /// Not:
  ///  • Burada doğrudan filtreleme yapılmaz; sadece seçim değişimi bildirilir.
  Widget _filterChip(String label, FilterOption option) {
    final selected = filter == option;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(option),
    );
  }
}
