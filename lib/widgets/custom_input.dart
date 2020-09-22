import 'package:electronic_app/constants.dart';
import 'package:flutter/material.dart';
class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final bool isPassword;
  CustomInput({this.hintText,this.onChanged,this.onSubmitted,this.focusNode,this.isPassword});
  @override
  Widget build(BuildContext context) {
    bool _isPassword =isPassword ?? false;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0
      ),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F2),
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: TextField(
        obscureText: _isPassword,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText??"HintText",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0
          )
        ),
        style: Constants.regularDarkTest,
      ),
    );
  }
}
