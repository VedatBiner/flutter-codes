import 'package:flutter/material.dart';
import 'package:portfolio_web/constants.dart';
import 'package:portfolio_web/sections/about/about_section.dart';
import 'package:portfolio_web/sections/contact/contact_section.dart';
import 'package:portfolio_web/sections/feedback/feedback_section.dart';
import 'package:portfolio_web/sections/recent_work/recent_work_section.dart';
import 'package:portfolio_web/sections/service/service_section.dart';
import 'package:portfolio_web/sections/topsection/top_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopSection(),
            SizedBox(height: kDefaultPadding * 2),
            AboutSection(),
            ServiceSection(),
            RecentWorkSection(),
            FeedbackSection(),
            SizedBox(height: kDefaultPadding),
            ContactSection(),
            SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}
