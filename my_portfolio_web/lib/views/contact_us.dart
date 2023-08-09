import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_buttons.dart';
import 'package:my_portfolio_web/globals/app_text_styles.dart';
import 'package:my_portfolio_web/globals/constants.dart';

import '../globals/app_colors.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.bgColor,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: size.width * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1200),
            child: RichText(
              text: TextSpan(
                text: "Contact ",
                style: AppTextStyles.headingStyles(fontSize: 30),
                children: [
                  TextSpan(
                    text: "Me",
                    style: AppTextStyles.headingStyles(
                      fontSize: 30,
                      color: AppColors.robinEdgeBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Constants.sizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  elevation: 8,
                  child: TextField(
                    cursorColor: AppColors.white,
                    style: AppTextStyles.normalStyle(),
                    decoration: buildInputDecoration(
                      hintText: "Full Name",
                    ),
                  ),
                ),
              ),
              Constants.sizedBox(width: 20),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  elevation: 8,
                  child: TextField(
                    cursorColor: AppColors.white,
                    style: AppTextStyles.normalStyle(),
                    decoration: buildInputDecoration(
                      hintText: "Email Address",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Constants.sizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  elevation: 8,
                  child: TextField(
                    cursorColor: AppColors.white,
                    style: AppTextStyles.normalStyle(),
                    decoration: buildInputDecoration(
                      hintText: "Mobile Number",
                    ),
                  ),
                ),
              ),
              Constants.sizedBox(width: 20),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  elevation: 8,
                  child: TextField(
                    cursorColor: AppColors.white,
                    style: AppTextStyles.normalStyle(),
                    decoration: buildInputDecoration(
                      hintText: "Email Subject",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Constants.sizedBox(height: 20),
          Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            elevation: 8,
            child: TextField(
              cursorColor: AppColors.white,
              style: AppTextStyles.normalStyle(),
              maxLines: 15,
              decoration: buildInputDecoration(
                hintText: "Your Message",
              ),
            ),
          ),
          Constants.sizedBox(height: 40),
          AppButtons.buildMaterialButton(
            buttonName: "Send Message",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.comfortaaStyle(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: AppColors.bgColor2,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
    );
  }
}
