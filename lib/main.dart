import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';
import 'local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Response(
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
      create: (BuildContext context) => ProductsOperationsController(),
    );
  }
}
