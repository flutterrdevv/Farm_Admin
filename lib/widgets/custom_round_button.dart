import 'package:flutter/material.dart';

import '../../helpers/constant.dart';

class CRoundButton extends StatelessWidget {
  const CRoundButton(
      {Key? key,
      required this.function,
      required this.text,
      this.active,
      this.textColor,
      this.height,
      this.width,
      this.fontSize,
      this.color,
      this.fontWeight})
      : super(key: key);
  final Function function;
  final String text;
  final bool? active;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        alignment: Alignment.center,
        width: width ?? 97,
        height: height ?? 32,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            color: active ?? true ? color ?? black : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: TextStyle(
              color: textColor ?? white,
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.normal),
        ),
      ),
    );
  }
}
