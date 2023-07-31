import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget {
  const MyCustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          TextButton(
            onPressed: () {},
            child: Text(
              "My Design Buddy",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Pricing",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Work",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "About Me",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "FAQ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Colors.black.withOpacity(0.8),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.black.withOpacity(0.7),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
