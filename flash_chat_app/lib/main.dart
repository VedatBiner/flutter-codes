import 'package:flutter/material.dart';
import 'package:flash_chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/chat_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Uygulama hem web hem de mobil cihazda çalışacak ise
  /// bu satır aşağıdaki gibi olmalıdır.
  /// Firebase ayarları aşağıdaki adresteki adımlar ile yapıldı
  /// https://firebase.google.com/docs/flutter/setup?platform=android
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
      },
    );
  }
}
