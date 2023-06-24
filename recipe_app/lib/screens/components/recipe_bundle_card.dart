import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/recipe_bundle.dart';
import '../../size_config.dart';

class RecipeBundleCard extends StatelessWidget {
  final RecipeBundle recipeBundle;
  final Function press;
  const RecipeBundleCard({
    Key? key,
    required this.recipeBundle,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize!;
    return GestureDetector(
      onTap: press(),
      child: Container(
        height: defaultSize * 20,
        decoration: BoxDecoration(
          color: recipeBundle.color,
          borderRadius: BorderRadius.circular(defaultSize * 1.8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(defaultSize * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      recipeBundle.title,
                      style: TextStyle(
                        fontSize: defaultSize * 2.2,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: defaultSize * 0.5),
                    Text(
                      recipeBundles[0].description,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(flex: 1),
                    buildInfoRow(
                      defaultSize,
                      iconSrc: "assets/icons/pot.svg",
                      text: "${recipeBundle.recipes} Recipes",
                    ),
                    SizedBox(height: defaultSize * 0.5),
                    buildInfoRow(
                      defaultSize,
                      iconSrc: "assets/icons/chef.svg",
                      text: " ${recipeBundle.chefs} Chefs",
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: defaultSize * 0.5,
            ),
            Expanded(
              child: Image.asset(
                recipeBundles[0].imageSrc,
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildInfoRow(
    double defaultSize, {
    required String iconSrc,
    required String text,
  }) {
    return Row(
      children: [
        SvgPicture.asset(iconSrc),
        SizedBox(width: defaultSize),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
