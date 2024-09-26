import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/app_theme.dart';
import 'package:groceries_shopping_app/widgets/illustration_container.dart';
import 'package:provider/provider.dart';

import '../product_provider.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with AfterLayoutMixin<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (context.mounted) {
          awesomeDialog(context);
        }
      },
    );
  }

  int _randomGeneratedCode() {
    Random random = Random();
    return random.nextInt(10000000);
  }

  AwesomeDialog awesomeDialog(BuildContext context) {
    return AwesomeDialog(
      btnOkColor: Theme.of(context).primaryColor,
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      autoHide: const Duration(minutes: 10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your order has been placed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('Check your E-mail for confirmation.'),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                "Your Order Number is \n#${_randomGeneratedCode()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: IllustrationContainer(
                  path: AppTheme.checkingOutSVG,
                  reduceSizeByHalf: true,
                ),
              ),
            ),
          ],
        ),
      ),
      // btnOk: _buildFancyButtonOk,
      onDismissCallback: (_) {
        Provider.of<ProductsOperationsController>(context, listen: false)
            .clearCart();
        Navigator.pop(context);
      },
    )..show();
  }
}
