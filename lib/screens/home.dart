import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceries_shopping_app/app_theme.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/widgets/products_checkout.dart';
import 'package:groceries_shopping_app/widgets/products_checkout_preview.dart';
import 'package:groceries_shopping_app/widgets/products_preview.dart';
import 'package:provider/provider.dart';
import '../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation transformAnimation;
  late final Animation _animation;
  late final Animation cartCheckoutTransitionAnimation;
  late final Animation mainBoardAnimation;
  late final Animation cartBoardAnimation;
  AnimationStatus? currentAnimationStatus;
  late final CurvedAnimation curvedAnimation;
  late final CurvedAnimation cartCheckoutCurvedAnimation;
  late final CurvedAnimation mainBoardCurvedAnimation;
  late final CurvedAnimation cartBoardCurvedAnimation;
  final Duration _duration = const Duration(milliseconds: 700);
  final Curve _curve = Curves.decelerate;
  bool isCartExpanded = false;
  double currentCartScreenFactor = 0.89;
  double currentMainScreenFactor = 0.045;
  double animationValue = 1;
  double transformAnimationValue = 0;
  double cartCheckoutTransitionValue = 0;

  @override
  void initState() {
    super.initState();
    /**
     * Main Animation Controller
     */
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    /**
     * Animations Curves
     */
    curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: _curve);
    cartCheckoutCurvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInExpo);
    mainBoardCurvedAnimation =
        CurvedAnimation(parent: _animationController, curve: _curve);
    cartBoardCurvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Interval(0.3, 1, curve: _curve));
    /**
     * Animations
     */
    _animation = Tween<double>(begin: 1, end: 0).animate(curvedAnimation);
    transformAnimation =
        Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    cartCheckoutTransitionAnimation =
        Tween<double>(begin: 0, end: 1).animate(cartCheckoutCurvedAnimation);
    mainBoardAnimation = Tween<double>(begin: 0.045, end: 0.825)
        .animate(mainBoardCurvedAnimation);
    cartBoardAnimation =
        Tween<double>(begin: 0.89, end: 0.12).animate(cartBoardCurvedAnimation);
    /**
     * Animations Listeners
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
        cartCheckoutTransitionValue =
            cartCheckoutTransitionAnimation.value * 80;
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
    final size = MediaQuery.of(context).size;
    final cartProductsProvider =
        Provider.of<ProductsOperationsController>(context).cart;
    final totalPriceProvider =
        Provider.of<ProductsOperationsController>(context).totalCost;
    Provider.of<ProductsOperationsController>(context, listen: false)
        .onCheckOut(
      onCheckOutCallback: _animateCartCheckout,
    );

    final disableCartTouch = !isCartExpanded && cartProductsProvider.length < 4;

    return GestureDetector(
      onTapDown: (_) => _animateCartCheckout(),
      onTapUp: (_) {
        _animateCartCheckout();
        Provider.of<ProductsOperationsController>(context, listen: false)
            .returnTotalCost();
      },
      child: Scaffold(
        backgroundColor: AppTheme.mainCartBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: AppTheme.mainScaffoldBackgroundColor,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        body: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              //cart
              //open = 0.12
              //closed = 0.92
              Positioned(
                bottom: -size.height * currentCartScreenFactor,
                left: 0,
                width: size.width,
                child: IgnorePointer(
                  ignoring: disableCartTouch,
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: ListView(
                      physics: !isCartExpanded
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        Container(
                          height: response.setHeight(80),
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: response.setWidth(25)),
                          child: CartPreview(
                            transformAnimationValue: transformAnimationValue,
                            animationValue: animationValue,
                            cartProductsProvider: cartProductsProvider,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: response.setWidth(20)),
                          child: SizedBox(
                            height: size.height * 0.85,
                            width: size.width,
                            // color: Colors.redAccent,
                            child: ProductsCheckout(
                              cartCheckoutTransitionValue:
                                  cartCheckoutTransitionValue,
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
                top: -size.height * currentMainScreenFactor,
                left: 0,
                width: size.width,
                child: Hero(
                  tag: 'detailsScreen',
                  child: Container(
                    height: size.height * 0.90,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: AppTheme.mainScaffoldBackgroundColor,
                      // color: Colors.teal,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -size.height * currentMainScreenFactor,
                left: 0,
                width: size.width,
                child: IgnorePointer(
                  ignoring: isCartExpanded,
                  child: SizedBox(
                    height: size.height * 0.90,
                    width: size.width,
                    child: const ProductsPreview(),
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
    _animationController.dispose();
    super.dispose();
  }
}
