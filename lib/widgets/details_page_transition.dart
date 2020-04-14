import 'package:flutter/material.dart';

class DetailsPageRoute extends PageRouteBuilder {
  var route;
  DetailsPageRoute({@required this.route})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => route,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}
