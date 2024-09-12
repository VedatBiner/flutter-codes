import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // translate metodunun kullanılabilmesi için gerekli import

class ChangeLanguageDialog extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const ChangeLanguageDialog({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.translate('choose_language')), // 'translate' extension artık kullanılabilir
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              onLocaleChange(const Locale('en', 'US'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Türkçe'),
            onTap: () {
              onLocaleChange(const Locale('tr', 'TR'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
