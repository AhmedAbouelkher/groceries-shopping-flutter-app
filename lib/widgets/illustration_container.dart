import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IllustrationContainer extends StatelessWidget {
  final String path;
  final bool reduceSizeByHalf;
  const IllustrationContainer({
    super.key,
    required this.path,
    this.reduceSizeByHalf = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: MediaQuery.of(context).size.height *
          (reduceSizeByHalf ? 0.3 / 2 : 0.3),
      height: MediaQuery.of(context).size.height *
          (reduceSizeByHalf ? 0.3 / 2 : 0.3),
    );
  }
}
