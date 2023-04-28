import 'package:flutter/material.dart';

import '../../helpers/constant.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key,
      this.color,
      required this.iconImage,
      this.textColor,
      required this.function,
      this.height,
      this.iconSize,
      this.width})
      : super(key: key);
  final Color? color;
  final String iconImage;
  final Color? textColor;
  final double? width;
  final double? height;
  final Function function;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          function();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          height: height ?? 60,
          width: width ?? MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
              color: color ?? black, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Image.asset(
            iconImage,
            width: iconSize,
            color: white,
          )),
        ));
  }
}
