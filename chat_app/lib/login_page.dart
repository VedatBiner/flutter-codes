import 'package:flutter/material.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/login_text_field.dart';
import '../utils/spaces.dart';
import '../widgets/social_media_buttons.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final Uri _url = Uri.parse("https://vedatbiner.github.io/");

  void loginUser(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print(userNameController.text);
      print(passwordController.text);
      Navigator.pushReplacementNamed(
        context,
        "/chat",
        arguments: userNameController.text,
      );
      print("Login Successful!");
    } else {
      print("not successful");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Let's sign you in!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black,
                ),
              ),
              verticalSpacing(10),
              const Text(
                "Welcome back ! \nYou've been missed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              verticalSpacing(10),
              Image.asset(
                "assets/images/illustration.png",
                height: 200,
              ),
              verticalSpacing(10),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    LoginTextField(
                      hintText: "Enter your username",
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 5) {
                          return "Your username should be more then 5 characters";
                        } else if (value != null && value.isEmpty) {
                          return "Please type your username";
                        }
                        return null;
                      },
                      controller: userNameController,
                    ),
                    verticalSpacing(24),
                    LoginTextField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      hasAsterisks: true,
                    ),
                  ],
                ),
              ),
              verticalSpacing(24),
              ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              verticalSpacing(24),
              GestureDetector(
                onTap: () async {
                  print("Link clicked!");
                  if (!await launchUrl(_url)) {
                    throw "Could not launch this $_url";
                  }
                },
                child: Column(
                  children: [
                    const Text("Find us on"),
                    Text("$_url"),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SMButton(
                    socialMedia: "https://www.linkedin.com/in/vedatbiner/",
                    color: Colors.indigo,
                    iconData: SocialMediaIcons.linkedin,
                  ),
                  SMButton(
                    socialMedia: "https://www.github.com/vedatbiner",
                    color: Colors.black,
                    iconData: SocialMediaIcons.github_circled,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
