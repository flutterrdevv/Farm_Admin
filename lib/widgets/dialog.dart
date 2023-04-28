import 'package:flutter/material.dart';

import '../helpers/constant.dart';

class CustomDialogButton extends StatelessWidget {
  const CustomDialogButton(
      {super.key,
      required this.function,
      required this.name,
      required this.fontWeight,
      required this.textSize});
  final Function function;
  final String name;
  final double textSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        function();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: black, borderRadius: BorderRadius.circular(10)),
        height: 32,
        width: 90,
        child: Text(
          name,
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Future<dynamic> dialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String firstButton,
    required String secondButton,
    required Function firstFunction,
    required Function secondFunction,
    required double firstButtonTextSize,
    required FontWeight firstButTextWeight,
    required double secondButtonTextSize,
    double? leftPadding,
    required FontWeight secondButtonTextWeight}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(color: black.withOpacity(0.6), fontSize: 12),
            ),
          )
        ],
      ),
      actions: <Widget>[
        CustomDialogButton(
          name: firstButton,
          function: () {
            firstFunction();
          },
          fontWeight: firstButTextWeight,
          textSize: firstButtonTextSize,
        ),
        CustomDialogButton(
          name: secondButton,
          function: () {
            secondFunction();
          },
          textSize: secondButtonTextSize,
          fontWeight: secondButtonTextWeight,
        ),
      ],
    ),
  );
}
