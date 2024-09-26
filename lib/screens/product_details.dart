import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../utils.dart';

class ProductDetails extends StatefulWidget {
  final int productIndex;
  const ProductDetails({super.key, required this.productIndex});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<ProductDetails> {
  bool isFavorite = false;
  late final PreferenceUtils _utils;
  late final AnimationController animationController;
  late final Animation animation;
  late final Animation secondaryAnimation;
  bool isToPreview = false;
  double opacity = 1;
  int orderQuantity = 1;
  bool temp = false;

  @override
  void initState() {
    super.initState();
    _utils = PreferenceUtils.getInstance();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.decelerate),
    );
    secondaryAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 1, curve: Curves.decelerate),
      ),
    );

    animation.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductsOperationsController>(context);
    var productProvider =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    return Scaffold(
      backgroundColor: AppTheme.mainScaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.mainScaffoldBackgroundColor,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Hero(
              tag: 'back-arrow',
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: response.setHeight(24),
              ),
            ),
            onPressed: () {
              setState(() => opacity = 0);
              Navigator.pop(context);
            }),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: InkWell(
        onTap: () {
          switch (temp) {
            case false:
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: []);
              setState(() {
                temp = true;
              });
              break;
            case true:
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.bottom]);
              setState(() {
                temp = false;
              });
              break;
          }
        },
        child: const SizedBox(height: 100, width: 100),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Hero(
            tag: 'detailsScreen',
            child: Container(
              height: response.screenHeight,
              width: response.screenWidth,
              decoration: BoxDecoration(
                color: AppTheme.mainScaffoldBackgroundColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Hero(
                    tag: isToPreview
                        ? '${productProvider[widget.productIndex].name}-name'
                        : '${productProvider[widget.productIndex].picPath}-path',
                    child: Image.asset(
                        productProvider[widget.productIndex].picPath,
                        scale: 0.8),
                  ),
                  Transform(
                    //0 < animation.value < 1
                    transform: Matrix4.translationValues(
                        0.0, -animation.value * response.setHeight(20), 0.0),
                    child: Opacity(
                      opacity: secondaryAnimation.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: response.setWidth(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: response.setHeight(20)),
                            Text(
                              productProvider[widget.productIndex].name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: response.setFontSize(40),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: response.setHeight(5)),
                            Text(
                              productProvider[widget.productIndex].weight,
                              style: TextStyle(
                                  fontSize: response.setFontSize(15),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: response.setHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ProductQuantity(
                                  orderQuantity: orderQuantity,
                                  minusOnTap: () =>
                                      setState(() => orderQuantity--),
                                  plusOnTap: () =>
                                      setState(() => orderQuantity++),
                                ),
                                Text(
                                  productProvider[widget.productIndex].price,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: response.setFontSize(40),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: response.setHeight(30)),
                            Text(
                              "About the Product",
                              style: TextStyle(
                                  fontSize: response.setFontSize(17),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: response.setHeight(5)),
                            Text(
                              productProvider[widget.productIndex].description,
                              style: TextStyle(
                                  fontSize: response.setFontSize(15),
                                  color: Colors.black87),
                            ),
                            SizedBox(height: response.setHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: response.setHeight(55),
                                  width: response.setWidth(55),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black12, width: 1)),
                                  child: Center(
                                    child: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        icon: FaIcon(isFavorite
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart),
                                        onPressed: () async {
                                          setState(
                                              () => isFavorite = !isFavorite);
                                          await _utils.saveValueWithKey<bool>(
                                              "${productProvider[widget.productIndex].name}-fav",
                                              isFavorite);
                                        }),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    provider.addProductToCart(
                                      widget.productIndex,
                                      bulkOrder: orderQuantity,
                                    );
                                    setState(() {
                                      isToPreview = true;
                                      opacity = 0;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      height: response.setHeight(55),
                                      width: response.setWidth(235),
                                      decoration: BoxDecoration(
                                          color: AppTheme.mainOrangeColor,
                                          borderRadius: BorderRadius.circular(
                                              response.setHeight(50))),
                                      child: Center(
                                        child: Text(
                                          "Add to cart",
                                          style: TextStyle(
                                            fontSize: response.setFontSize(18),
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: response.setHeight(25)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    animationController.forward();
    var value = _utils.getValueWithKey(
        "${Provider.of<ProductsOperationsController>(context, listen: false).productsInStock[widget.productIndex].name}-fav");
    if (value != null) {
      setState(() => isFavorite = value);
    }
  }
}

class ProductQuantity extends StatelessWidget {
  final int orderQuantity;
  final VoidCallback minusOnTap;
  final VoidCallback plusOnTap;

  const ProductQuantity({
    super.key,
    required this.orderQuantity,
    required this.minusOnTap,
    required this.plusOnTap,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: response.setFontSize(20),
    );
    return Container(
      height: response.setHeight(45),
      width: response.setWidth(100),
      padding: EdgeInsets.symmetric(horizontal: response.setWidth(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(response.setHeight(30)),
        border:
            Border.all(color: Colors.black38, width: response.setHeight(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IgnorePointer(
            ignoring: orderQuantity > 1 ? false : true,
            child: InkWell(
              onTap: minusOnTap,
              child: Text(
                "-",
                style: textStyle.copyWith(
                    color: orderQuantity > 1 ? Colors.black87 : Colors.black26,
                    fontSize: response.setFontSize(35),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Text(orderQuantity.toString(), style: textStyle),
          IgnorePointer(
            ignoring: orderQuantity < 50 ? false : true,
            child: InkWell(
              onTap: plusOnTap,
              child: Text(
                "+",
                style: textStyle.copyWith(
                  color: orderQuantity < 50 ? Colors.black87 : Colors.black26,
                  fontSize: response.setFontSize(24),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
