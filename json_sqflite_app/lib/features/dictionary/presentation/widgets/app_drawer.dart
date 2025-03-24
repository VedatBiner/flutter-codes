// <----- 📜 app_drawer.dart ----->
// -----------------------------------------------------------------------------
// Drawer menüsünü oluşturmak için kullanılan widget
// -----------------------------------------------------------------------------
//
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onResetDatabase;

  const AppDrawer({
    super.key,
    required this.onResetDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Veritabanını Sıfırla ve Yeniden Yükle'),
            onTap: () => onResetDatabase(),
          ),
        ],
      ),
    );
  }
}


