import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'dart:collection';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/widgets/checkout_card.dart';
import 'package:groceries_shopping_app/widgets/delivery_card.dart';
import 'package:provider/provider.dart';

class ProductsCheckout extends StatelessWidget {
  const ProductsCheckout({
    Key key,
    @required this.cartCheckoutTransitionValue,
    @required this.cartProductsProvider,
    @required this.totalPriceProvider,
  }) : super(key: key);

  final double cartCheckoutTransitionValue;
  final UnmodifiableListView<Product> cartProductsProvider;
  final double totalPriceProvider;

  @override
  Widget build(BuildContext context) {
    var finalTotalCost = totalPriceProvider == 0
        ? 0
        : (totalPriceProvider > 40
            ? totalPriceProvider
            : totalPriceProvider + 5);
    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.loose,
      children: <Widget>[
        Positioned(
          top: -cartCheckoutTransitionValue,
          left: 0,
          child: Text(
            "Cart",
            style: TextStyle(
              fontSize: response.setFontSize(35),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: response.setHeight(80 - cartCheckoutTransitionValue),
          child: Container(
            height: response.setHeight(240 + cartCheckoutTransitionValue),
            width: double.infinity,
            // color: Colors.teal,
            child: ListView.builder(
              itemCount: cartProductsProvider.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(cartProductsProvider[index].picPath),
                  onDismissed: (direction) {
                    Provider.of<ProductsOperationsController>(context,
                            listen: false)
                        .deleteFromCart(index);
                    Provider.of<ProductsOperationsController>(context,
                            listen: false)
                        .returnTotalCost();
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            " Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            width: response.setHeight(20),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: Checkout(
                      cartProductsProvider: cartProductsProvider, index: index),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: response.setHeight(40),
          right: 0,
          child: Container(
            // color: AppTheme.mainCartBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DeliveryCard(totalPriceProvider: totalPriceProvider),
                SizedBox(height: response.setHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Total:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: response.setFontSize(25),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "\$${finalTotalCost..toStringAsExponential(3)}",
                      style: TextStyle(
                        color: Colors.white.withAlpha(240),
                        fontWeight: FontWeight.bold,
                        fontSize: response.setFontSize(35),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: response.setHeight(50)),
                Container(
                  height: response.setHeight(55),
                  decoration: BoxDecoration(
                      color: AppTheme.mainOrangeColor,
                      borderRadius:
                          BorderRadius.circular(response.setHeight(50))),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: response.setFontSize(16),
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: response.setHeight(20)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
