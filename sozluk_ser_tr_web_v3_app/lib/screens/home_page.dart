// <📜 ----- home_page.dart ----->
// (yalnızca butonun onPressed 'i yeni fonksiyona yönlendirildi)

// 📌 Flutter hazır paketleri
import 'package:flutter/material.dart';

/// 📌 Yardımcı yüklemeler burada
import '../services/export_words.dart';
import '../services/words_reader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = 'Hazır. Konsolu kontrol edin.';
  bool exporting = false;

  @override
  void initState() {
    super.initState();
    _runInitialRead();
  }

  Future<void> _runInitialRead() async {
    final s = await readWordsOnce();
    if (!mounted) return;
    setState(() => status = s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sırpça-Türkçe Sözlük - WEB')),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Kaydedildi:\nJSON → ${res.jsonPath}\nCSV  → ${res.csvPath}\nXLSX → ${res.xlsxPath}',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => status = 'Hata: $e');
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('Hata: $e')));
                          } finally {
                            if (mounted) setState(() => exporting = false);
                          }
                        },
                  icon: const Icon(Icons.download),
                  label: const Text('JSON + CSV + Excel Dışa Aktar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    setState(() => status = 'Koleksiyon okunuyor...');
                    final s = await readWordsOnce();
                    if (!mounted) return;
                    setState(() => status = s);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeniden Oku'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
