import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';

class ProductsOperationsController extends ChangeNotifier {
  List<Product> _productsInStock = [
    Product(
        name: 'Fusilo ketchup Toglile',
        picPath: 'assets/ketchup.png',
        price: '\$9.95',
        weight: '550g'),
    Product(
        name: 'Togliatelle Rice Organic',
        picPath: 'assets/rice.png',
        price: '\$7.99',
        weight: '500g'),
    Product(
        name: 'Organic Potatos',
        picPath: 'assets/potatoes.png',
        price: '\$4.99',
        weight: '1000g'),
    Product(
        name: 'Desolve Milk',
        picPath: 'assets/milk.png',
        price: '\$9.99',
        weight: '550g'),
    Product(
        name: 'Fusilo Pasta Toglile',
        picPath: 'assets/pasta.png',
        price: '\$7.99',
        weight: '500g'),
    Product(
        name: 'Organic Flour',
        picPath: 'assets/flour.png',
        price: '\$10.95',
        weight: '250g'),
  ];

  List<Product> _shoppingCart = [];
  VoidCallback onCheckOutCallback;

  void onCheckOut({VoidCallback onCheckOutCallback}) {
    this.onCheckOutCallback = onCheckOutCallback;
  }

  UnmodifiableListView<Product> get productsInStock {
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView<Product> get cart {
    return UnmodifiableListView(_shoppingCart);
  }

  void addProductToCart(int index, {int bulkOrder = 0}) {
    bool inCart = false;
    int indexInCard = 0;
    if (_shoppingCart.length != 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        if (_shoppingCart[i].name == _productsInStock[index].name &&
            _shoppingCart[i].picPath == _productsInStock[index].picPath) {
          indexInCard = i;
          inCart = true;
          break;
        }
      }
    }
    if (inCart == false) {
      _shoppingCart.add(
        Product(
          name: _productsInStock[index].name,
          picPath: _productsInStock[index].picPath,
          price: _productsInStock[index].price,
          weight: _productsInStock[index].weight,
          orderedQuantity:
              _productsInStock[index].orderedQuantity + (bulkOrder - 1),
        ),
      );
      notifyListeners();
    } else {
      _shoppingCart[indexInCard].makeOrder(bulkOrder: bulkOrder);
      notifyListeners();
    }
  }

  double _totalCost = 0.00;
  void returnTotalCost() {
    if (_totalCost == 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\$', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    } else {
      _totalCost = 0.0;
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\$', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    }
  }

  void deleteFromCart(int index) {
    _shoppingCart.removeAt(index);
    notifyListeners();
  }

  double get totalCost {
    return double.parse(_totalCost.toStringAsExponential(3));
  }

  void clearCart() {
    _shoppingCart.clear();
    onCheckOutCallback();
    notifyListeners();
  }
}
