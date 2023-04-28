import 'package:flutter/material.dart';

import '../helpers/constant.dart';

class BorderedTextField extends StatelessWidget {
  final String hintText;
  // final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  final textController;

  const BorderedTextField(
      {super.key,
      required this.hintText,
      // required this.onChanged,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.autoFocus = false,
      this.textCapitalization = TextCapitalization.none,
      this.textController});

  @override
  Widget build(BuildContext context) {
    Color color = notWhite;

    return TextField(
      controller: textController,
      // onChanged: onChanged,
      obscureText: obscureText,
      autofocus: autoFocus,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(color: black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 50, maxWidth: 50),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Image.asset(
            'assets/messages/stickers.png',
            height: 20,
            width: 20,
          ),
        ),
        hintText: hintText,
        hintStyle:
            TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: grey),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(17)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(17)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(17)),
      ),
    );
  }
}
