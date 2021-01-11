import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/widgets/products_checkout.dart';
import 'package:groceries_shopping_app/widgets/products_checkout_preview.dart';
import 'package:groceries_shopping_app/widgets/products_preview.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';

var response = ResponseUI();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isCartExpanded = false;
  double currentCartScreenFactor = 0.89;
  double currentMainScreenFactor = 0.045;
  double animationValue = 1;
  double transformAnimationValue = 0;
  double cartCheckoutTransitionValue = 0;
  AnimationController _animationController;
  Animation transformAnimation;
  Animation _animation;
  Animation cartCheckoutTransitionAnimation;
  Animation mainBoardAnimation;
  Animation cartBoardAnimation;
  AnimationStatus currentAnimationStatus;
  CurvedAnimation curvedAnimation;
  CurvedAnimation cartCheckoutCurvedAnimation;
  CurvedAnimation mainBoardCurvedAnimation;
  CurvedAnimation cartBoardCurvedAnimation;
  Duration _duration;
  Curve _curve;

  @override
  void initState() {
    super.initState();
    _duration = Duration(milliseconds: 700);
    _curve = Curves.decelerate;
    /**
     * Main Animation Controller
     */
    _animationController = AnimationController(vsync: this, duration: _duration);
    /**
     * Animations Curves
     */
    curvedAnimation = CurvedAnimation(parent: _animationController, curve: _curve);
    cartCheckoutCurvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInExpo);
    mainBoardCurvedAnimation = CurvedAnimation(parent: _animationController, curve: _curve);
    cartBoardCurvedAnimation = CurvedAnimation(parent: _animationController, curve: Interval(0.3, 1, curve: _curve));
    /**
     * Animations
     */
    _animation = Tween<double>(begin: 1, end: 0).animate(curvedAnimation);
    transformAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    cartCheckoutTransitionAnimation = Tween<double>(begin: 0, end: 1).animate(cartCheckoutCurvedAnimation);
    mainBoardAnimation = Tween<double>(begin: 0.045, end: 0.825).animate(mainBoardCurvedAnimation);
    cartBoardAnimation = Tween<double>(begin: 0.89, end: 0.12).animate(cartBoardCurvedAnimation);
    /**
     * Animations Listners
     */
    _animation.addStatusListener((AnimationStatus status) {
      setState(() => currentAnimationStatus = status);
    });
    _animation.addListener(() {
      setState(() {
        animationValue = _animation.value;
      });
    });
    transformAnimation.addListener(() {
      setState(() {
        transformAnimationValue = transformAnimation.value;
      });
    });
    cartCheckoutTransitionAnimation.addListener(() {
      setState(() {
        cartCheckoutTransitionValue = cartCheckoutTransitionAnimation.value * 80;
      });
    });
    mainBoardAnimation.addListener(() {
      setState(() {
        currentMainScreenFactor = mainBoardAnimation.value;
      });
    });
    cartBoardAnimation.addListener(() {
      setState(() {
        currentCartScreenFactor = cartBoardAnimation.value;
      });
    });
  }

  void _animateCartCheckout() {
    switch (currentAnimationStatus) {
      case AnimationStatus.completed:
        _animationController.reverse();
        setState(() => isCartExpanded = false);
        break;
      case AnimationStatus.reverse:
        _animationController.forward();
        setState(() => isCartExpanded = true);
        break;
      default:
        setState(() => isCartExpanded = true);
        _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProductsProvider = Provider.of<ProductsOperationsController>(context).cart;
    final totalPriceProvider = Provider.of<ProductsOperationsController>(context).totalCost;
    Provider.of<ProductsOperationsController>(context, listen: false).onCheckOut(
      onCheckOutCallback: _animateCartCheckout,
    );

    final disableCartTauch = !isCartExpanded && cartProductsProvider.length < 4;

    return SwipeGestureRecognizer(
      onSwipeUp: () {
        _animateCartCheckout();
        Provider.of<ProductsOperationsController>(context, listen: false).returnTotalCost();
      },
      onSwipeDown: () => _animateCartCheckout(),
      child: Scaffold(
        backgroundColor: AppTheme.mainCartBackgroundColor,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: AppTheme.mainScaffoldBackgroundColor,
            elevation: 0,
            brightness: Brightness.light,
          ),
          preferredSize: Size.fromHeight(0),
        ),
        body: SafeArea(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              //cart
              //open = 0.12
              //closed = 0.92
              Positioned(
                bottom: -response.screenHeight * currentCartScreenFactor,
                left: 0,
                width: response.screenWidth,
                child: IgnorePointer(
                  ignoring: disableCartTauch,
                  child: Container(
                    height: response.screenHeight,
                    width: response.screenWidth,
                    child: ListView(
                      physics: !isCartExpanded ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        Container(
                          height: response.setHeight(80),
                          width: response.screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: response.setWidth(25)),
                          child: CartPreview(
                            transformAnimationValue: transformAnimationValue,
                            animationValue: animationValue,
                            cartProductsProvider: cartProductsProvider,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: response.setWidth(20)),
                          child: Container(
                            height: response.screenHeight * 0.85,
                            width: response.screenWidth,
                            // color: Colors.redAccent,
                            child: ProductsCheckout(
                              cartCheckoutTransitionValue: cartCheckoutTransitionValue,
                              cartProductsProvider: cartProductsProvider,
                              totalPriceProvider: totalPriceProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //main
              //open = 0.01
              //closed = 0.8
              Positioned(
                top: -response.screenHeight * currentMainScreenFactor,
                left: 0,
                width: response.screenWidth,
                child: Hero(
                  tag: 'detailsScreen',
                  child: Container(
                    height: response.screenHeight * 0.90,
                    width: response.screenWidth,
                    decoration: BoxDecoration(
                      color: AppTheme.mainScaffoldBackgroundColor,
                      // color: Colors.teal,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -response.screenHeight * currentMainScreenFactor,
                left: 0,
                width: response.screenWidth,
                child: IgnorePointer(
                  ignoring: isCartExpanded,
                  child: Container(
                    height: response.screenHeight * 0.90,
                    width: response.screenWidth,
                    child: ProductsPreview(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
