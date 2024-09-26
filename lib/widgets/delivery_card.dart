import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/app_theme.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../utils.dart';

class DeliveryCard extends StatelessWidget {
  final double totalPriceProvider;

  const DeliveryCard({
    super.key,
    required this.totalPriceProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: AppTheme.secondaryCartBackgroundColor,
          radius: response.setWidth(22),
          child: FaIcon(
            FontAwesomeIcons.truckMoving,
            color: AppTheme.mainOrangeColor,
            size: response.setHeight(20),
          ),
        ),
        SizedBox(width: response.setHeight(15)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: response.setHeight(13)),
            Text(
              "Delivery",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: response.setFontSize(15)),
            ),
            SizedBox(height: response.setHeight(15)),
            Text(
              "All orders of \$40 or more\nqualify for FREE delivery.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: response.setFontSize(11),
              ),
            ),
            SizedBox(height: response.setHeight(12)),
            StepProgressIndicator(
              fallbackLength: 140,
              totalSteps: 40,
              currentStep:
                  totalPriceProvider <= 40 ? totalPriceProvider.round() : 40,
              size: 4,
              padding: 0,
              selectedColor: Colors.yellow,
              unselectedColor: Colors.grey,
            )
          ],
        ),
        const Spacer(),
        Text(
          "\$$totalPriceProvider",
          style: TextStyle(
            color: Colors.white70,
            fontSize: response.setFontSize(15),
          ),
        ),
      ],
    );
  }
}
