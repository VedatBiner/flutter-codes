import 'package:flutter/material.dart';

import 'child/about_subtitle_widget.dart';
import '../../core/constants/enum/enum.dart';
import 'child/about_title_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GapEnum.L.value,
        vertical: GapEnum.xxL.value,
      ),
      child: SingleChildScrollView(
        child: childrenWidget(),
      ),
    );
  }

  Column childrenWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AboutTitleWidget(),
          AboutSubtitleWidget(),
          GapEnum.L.heightBox,
          informations(),
        ],
      );
}

Widget informations() {
  return SizedBox(
    height: 400,
    width: 600,
    child: test(),
  );
}

GridView test() {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      mainAxisExtent: 48,
    ),
    itemCount: info.length,
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${info[index].title} : ${info[index].description}"),
          const Divider(),
        ],
      );
    },
  );
}

class InformationModel {
  InformationModel birthday;
  InformationModel website;
  InformationModel degree;
  InformationModel city;
  InformationModel age;
  InformationModel mail;
  InformationModel phone;
  InformationModel freelance;

  InformationModel(
    this.birthday,
    this.website,
    this.degree,
    this.city,
    this.age,
    this.mail,
    this.phone,
    this.freelance,
  );
}

class InformationSubModel {
  String title;
  String description;

  InformationSubModel(
    this.title,
    this.description,
  );
}

List<InformationSubModel> info = [
  InformationSubModel("Birthday", "01.01.1970"),
  InformationSubModel("Website", "www.vedatbiner.xyz"),
  InformationSubModel("Degree", "Flutter School"),
  InformationSubModel("City", "Ankaraz"),
  InformationSubModel("Age", "58"),
  InformationSubModel("Email", "vbiner@gmail.com"),
  InformationSubModel("Phone", "1234567"),
  InformationSubModel("Freelance", "available"),
];
