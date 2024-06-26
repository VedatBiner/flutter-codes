import 'package:flutter/material.dart';
import 'my_custom_appbar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextStyle _bodytextstyle = const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
  var priceButtonPadding = MaterialStateProperty.all(
    const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 25,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ListView(
        children: [
          Column(
            children: [
              MediaQuery.of(context).size.width > 720
                  ? const MyCustomAppBar()
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 60,
                ),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Design Buddy',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text("Unlimited Design", style: _bodytextstyle),
              Text("Subscription Service", style: _bodytextstyle),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: const Text(
                  'A design-made-easy monthly subscription solutionm tailored '
                      'around your business needs. No fuss, no hassle, no messy '
                      'contracts, just straight forward best-in-class design '
                      'at a click of a button.',
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onHover: (value) {
                  if (value) {
                    setState(() {
                      priceButtonPadding = MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 30,
                        ),
                      );
                    });
                  } else {
                    setState(() {
                      priceButtonPadding = MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 25,
                        ),
                      );
                    });
                  }
                },
                style: ButtonStyle(
                  padding: priceButtonPadding,
                  overlayColor: MaterialStateProperty.all(
                    Colors.black.withOpacity(0.8),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.black.withOpacity(0.7),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "View Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Column(
                  children: [
                    Text("Our Services", style: _bodytextstyle),
                    Image.asset(
                      'assets/images/services.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          )
        ],
      ),
    );
  }
}
