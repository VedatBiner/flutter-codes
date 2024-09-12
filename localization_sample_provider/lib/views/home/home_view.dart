import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/locale_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// metinin değişmesi
            Text(S.of(context).welcome),
            const SizedBox(height: 24),
            Text(S.of(context).Channel),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    context.read<LocaleProvider>().setTurkish();
                  },
                  child: const Text("Türkçe"),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: (){
                    context.read<LocaleProvider>().setEnglish();
                  },
                  child: const Text("İngilizce"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

