import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe_bundle.dart';
import 'package:recipe_app/screens/components/recipe_bundle_card.dart';
import 'package:recipe_app/size_config.dart';
import 'categories.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Categories(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize! * 2,
              ),
              child: GridView.builder(
                itemCount: recipeBundles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      SizeConfig.orientation == Orientation.landscape ? 2 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing:
                      SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.defaultSize! * 2
                          : 0,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) =>
                    RecipeBundleCard(recipeBundle: recipeBundles[index],press: (){},),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
