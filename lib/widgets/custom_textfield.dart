import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../helpers/constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.textInputAction,
      this.multiLines,
      this.callback})
      : super(key: key);
  final String hint;
  final String label;
  final String? multiLines;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final Function(bool)? callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
          keyboardType:
              multiLines != null ? TextInputType.multiline : TextInputType.text,
          maxLines: multiLines != null ? null : 1,
          expands: multiLines != null ? true : false,
          cursorColor: black,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey.withOpacity(0.5)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(16.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey.withOpacity(0.5)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey.withOpacity(0.5)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(16.0),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w400),
          ),
          style: const TextStyle(color: Colors.grey),
          controller: controller,
          textInputAction: textInputAction ?? TextInputAction.done,
          autovalidateMode: label == 'Email' ||
                  label == 'Password' ||
                  label == 'Name' ||
                  label == 'User Name'
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: label == 'Email'
              ? (email) => validate('email', email)
              : label == 'Password'
                  ? (password) => validate('password', password)
                  : null),
    );
  }

  validate(type, emailORpass) {
    if (type == 'email') {
      if (!EmailValidator.validate(emailORpass)) {
        callback!(false);
        return 'Enter a valid Email';
      } else {
        callback!(true);
        return null;
      }
    } else if (type == 'password') {
      if (emailORpass.length < 6) {
        callback!(false);
        return 'Enter min 6 characters';
      } else {
        callback!(true);
        return null;
      }
    }
  }
}
