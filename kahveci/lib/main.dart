import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const BenimUyg(),
  );
}

class BenimUyg extends StatelessWidget {
  const BenimUyg({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown.shade300,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 70.0,
                  backgroundColor: Colors.lime,
                  backgroundImage: AssetImage(
                    "assets/images/kahve.jpg",
                  ),
                ),
                Text(
                  "Flutter Kahvecisi",
                  style: TextStyle(
                    fontFamily: "Satisfy",
                    fontSize: 45,
                    color: Colors.brown[900],
                  ),
                ),
                Text(
                  "Bir Fincan Uzağınızda",
                  style: GoogleFonts.pacifico(
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Divider(
                    height: 30,
                    color: Colors.brown.shade900,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 45.0,),
                  color: Colors.brown.shade900,
                  child: const ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: Text(
                      "siparis@fkahvecisi.com",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 45.0,),
                  color: Colors.brown.shade900,
                  child: const ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    title: Text(
                      "+90 555 55 55",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

