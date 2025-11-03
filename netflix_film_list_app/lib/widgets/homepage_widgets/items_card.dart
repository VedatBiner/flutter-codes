// 📃 <----- lib/widgets/items_card.dart ----->
//
// 🎬 Netflix Film List App
// -----------------------------------------------------------
// Bu widget, film ve dizileri liste görünümünde göstermek için kullanılır.
// Her kayıt bir “Card” üzerinde; sol tarafta uygun ikon (🎥 veya 📺),
// ortada başlık ve izlenme tarihi, sağda bilgi ikonu gösterilir.
//
// Otomatik tür algılama:
//  • Başlık içinde “season”, “episode”, “s1”, “ep ” gibi ifadeler varsa => Dizi
//  • Aksi halde => Film
//
// Renk & ikon farkları:
//  • Dizi  → Mavi tonlu arka plan, TV ikonu
//  • Film  → Kırmızı tonlu arka plan, Film ikonu
//
// Kullanım:
//   NetflixItemCard(item: item);
//
// Gereksinimler:
//   import '../models/item_model.dart';
//
// -----------------------------------------------------------

import 'package:flutter/material.dart';

import '../../models/item_model.dart';

class NetflixItemCard extends StatelessWidget {
  final NetflixItem item;

  const NetflixItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 🔍 Otomatik dizi algılama (basit ama etkili)
    final nameLower = item.netflixItemName.toLowerCase();
    final bool isSeries =
        nameLower.contains('season') ||
        nameLower.contains('episode') ||
        nameLower.contains('s1') ||
        nameLower.contains('ep ');

    // 🎨 Görsel farklılıklar
    final Color cardColor = isSeries ? Colors.blueGrey[900]! : Colors.red[900]!;
    final Color iconColor = isSeries
        ? Colors.lightBlueAccent
        : Colors.redAccent;
    final IconData iconData = isSeries ? Icons.tv : Icons.movie;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(iconData, color: iconColor, size: 32),

        // 🎬 Başlık
        title: Text(
          item.netflixItemName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        // 📅 Tarih bilgisi
        subtitle: Text(
          "📅 ${item.watchDate}",
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),

        // ℹ️ Sağ tarafta tür ikonu (Tooltip ile)
        trailing: Tooltip(
          message: isSeries ? "Dizi" : "Film",
          child: Icon(
            isSeries ? Icons.layers : Icons.play_circle_fill,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
