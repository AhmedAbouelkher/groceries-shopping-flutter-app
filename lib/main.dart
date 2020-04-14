import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Response(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
      create: (BuildContext context) => ProductsOperationsController(),
    );
  }
}
