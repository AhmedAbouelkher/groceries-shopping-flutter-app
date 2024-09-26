import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'dart:collection';
import '../utils.dart';
import '../app_theme.dart';

class CartPreview extends StatelessWidget {
  final double transformAnimationValue;
  final double animationValue;
  final UnmodifiableListView<Product> cartProductsProvider;

  const CartPreview({
    super.key,
    required this.transformAnimationValue,
    required this.animationValue,
    required this.cartProductsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, response.setHeight(0.4)),
      //This the Preview Section of the Cart
      child: Transform(
        transform:
            Matrix4.translationValues(0, transformAnimationValue * 30, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: response.setHeight(10)),
              child: Opacity(
                opacity: animationValue,
                child: Text(
                  "Cart  ",
                  style: TextStyle(
                    fontSize: response.setFontSize(28),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: response.setHeight(50),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cartProductsProvider.length,
                  itemBuilder: (context, index) {
                    return Opacity(
                      opacity: animationValue,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0,
                            -transformAnimationValue *
                                (index <= 2 ? index : 2) *
                                30,
                            0),
                        child: CartPreviewCard(
                          cartProductsProvider: cartProductsProvider,
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Transform.scale(
              scale: animationValue,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: AppTheme.mainOrangeColor,
                  radius: response.setHeight(20),
                  child: Text(
                    cartProductsProvider.length.toString(),
                    style: TextStyle(
                      fontSize: response.setFontSize(16),
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartPreviewCard extends StatelessWidget {
  const CartPreviewCard({
    super.key,
    required this.cartProductsProvider,
    required this.index,
  });

  final UnmodifiableListView<Product> cartProductsProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${cartProductsProvider[index].name}-name',
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: response.setHeight(3)),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: response.setWidth(21),
              child: Image.asset(
                cartProductsProvider[index].picPath,
                scale: 7,
              ),
            ),
          ),
          cartProductsProvider[index].orderedQuantity > 1
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    radius: 8,
                    child: Text(
                      cartProductsProvider[index].orderedQuantity.toString(),
                      style: TextStyle(
                          fontSize: response.setFontSize(10),
                          color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
