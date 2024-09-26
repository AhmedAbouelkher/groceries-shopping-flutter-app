import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/screens/product_details.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../utils.dart';

class ProductCard extends StatelessWidget {
  final int index;
  const ProductCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final productInfoProvider =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            DetailsPageRoute(route: ProductDetails(productIndex: index)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: response.setHeight(240),
        width: response.setWidth(170),
        decoration: BoxDecoration(
            color: AppTheme.secondaryScaffoldColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
            ]),
        child: Padding(
          padding: EdgeInsets.only(
            left: response.setWidth(15),
            right: response.setWidth(15),
            top: response.setWidth(20),
            bottom: response.setWidth(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //2.4
              Hero(
                tag: '${productInfoProvider[index].picPath}-path',
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    productInfoProvider[index].picPath,
                    scale: 2.4,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productInfoProvider[index].price,
                    style: TextStyle(
                      fontSize: response.setFontSize(24),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: response.setHeight(10)),
                  Text(
                    productInfoProvider[index].name,
                    style: TextStyle(
                      fontSize: response.setFontSize(15),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: response.setHeight(4)),
                  Text(
                    productInfoProvider[index].weight,
                    style: TextStyle(
                      fontSize: response.setFontSize(14),
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
