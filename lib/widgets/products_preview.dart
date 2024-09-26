import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/app_theme.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../utils.dart';

class ProductsPreview extends StatelessWidget {
  const ProductsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final listInfo =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: size.height * 0.90,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.only(bottom: response.setHeight(6.5)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          for (var index = 0;
                              index < (listInfo.length / 2).floor();
                              index++)
                            ProductCard(index: index)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: response.setHeight(60)),
                        child: Column(
                          children: <Widget>[
                            for (var i = (listInfo.length / 2).floor();
                                i < listInfo.length;
                                i++)
                              ProductCard(index: i)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          width: response.screenWidth,
          child: Container(
            height: response.setHeight(70),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1],
                colors: [
                  AppTheme.mainScaffoldBackgroundColor,
                  AppTheme.mainScaffoldBackgroundColor.withAlpha(150)
                ],
              ),
            ),
            child: Opacity(
              opacity: 1,
              child: Align(
                alignment: const Alignment(0, 0.4),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: response.setWidth(20)),
                  child: Row(
                    children: <Widget>[
                      Hero(
                        tag: 'back-arrow',
                        child: GestureDetector(
                          onTap: () => _buildAlertDialog(context),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: response.setHeight(21),
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      Text(
                        "Pasta & Noodles",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: response.setFontSize(18),
                        ),
                      ),
                      const Spacer(flex: 8),
                      GestureDetector(
                          onTap: () async {
                            await _buildAlertDialog(context);
                          },
                          child: const FaIcon(FontAwesomeIcons.bars))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _buildAlertDialog(BuildContext context) async {
    return showPlatformDialog<bool>(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text(
          'Info',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text("This feature will be implemented soon, stay tuned."),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
