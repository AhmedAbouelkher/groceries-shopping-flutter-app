import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'dart:collection';
import '../utils.dart';

class Checkout extends StatelessWidget {
  const Checkout({
    super.key,
    required this.cartProductsProvider,
    required this.index,
  });

  final UnmodifiableListView<Product> cartProductsProvider;
  final int index;
  String _cost() {
    double totalCost =
        double.parse(cartProductsProvider[index].price.replaceAll('\$', '')) *
            cartProductsProvider[index].orderedQuantity;
    return totalCost.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(bottom: response.setHeight(20)),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: response.setWidth(22),
              child: Image.asset(
                cartProductsProvider[index].picPath,
                scale: 7,
              ),
            ),
            SizedBox(width: response.setWidth(15)),
            Text(
              '${cartProductsProvider[index].orderedQuantity}  x   ',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: response.setFontSize(12),
              ),
            ),
            SizedBox(
              width: size.width * 0.5,
              // color: Colors.red,
              child: Text(
                cartProductsProvider[index].name.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: response.setFontSize(16),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "\$${_cost()}",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white70,
                fontSize: response.setFontSize(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
