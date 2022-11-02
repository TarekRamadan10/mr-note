import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    Key? key,
    required this.controller,
    this.obscureText=false,
    this.cursorColor,
    this.validator,
    this.hintText,
    this.label,
    this.icon,
    this.iconColor,
    this.suffixIcon,
    this.prefixIcon,
    this.enabledBorder,
    this.focusedBorder,
    this.keyboardType,
    this.prefixIconColor,
    this.suffixIconColor,
    this.suffix,
    this.contentPadding,
    this.onFieldSubmitted,
    this.maxLines,
    this.cursorWidth,
    this.cursorHeight,
    this.hintStyle,
    this.fillColor,
    this.style,
    this.prefix,
    this.border,
    this.onChanged
  }) : super(key: key);

  TextEditingController? controller;
  TextInputType? keyboardType;
  bool obscureText;
  Color? cursorColor;
  String? Function(String?)? validator;
  String? hintText;
  Widget? label;
  Icon? icon;
  Color? iconColor;
  Icon? suffixIcon;
  Icon? prefixIcon;
  InputBorder? enabledBorder;
  InputBorder? focusedBorder;
  Color? prefixIconColor;
  Color? suffixIconColor;
  Widget? suffix;
  EdgeInsetsGeometry? contentPadding;
  void Function(String)? onFieldSubmitted;
  int? maxLines;
  double? cursorHeight;
  double? cursorWidth;
  TextStyle? hintStyle;
  Color? fillColor;
  TextStyle? style;
  Widget? prefix;
  InputBorder? border;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged:onChanged,
      style:style ,
      cursorWidth:cursorWidth??4.0,
      cursorHeight:cursorHeight ,
      maxLines:maxLines,
      onFieldSubmitted: onFieldSubmitted,
      controller:controller,
      keyboardType:keyboardType,
      obscureText:obscureText ,
      cursorColor :cursorColor ,
      validator: validator,
      decoration: InputDecoration(
        border: border,
        prefix:prefix,
        hintStyle:hintStyle,
        hintText: hintText,
        label:label,
        icon: icon,
        iconColor: iconColor,
        suffixIcon: suffixIcon,
        prefixIcon:prefixIcon,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        prefixIconColor: prefixIconColor,
        suffixIconColor:suffixIconColor  ,
        suffix:suffix,
        contentPadding: contentPadding,
        filled: true,
        fillColor:fillColor,
      ),
    );
  }
}
