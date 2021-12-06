import 'package:flutter/material.dart';
import "package:flutter/painting.dart";

 Widget buildText( { String text ,TextStyle textStyle, Color color , double fontSize, FontWeight fontWeight}) {
  return Text(text, style: TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontSize: fontSize,
  ));
}

Widget buildButton({String text ,TextStyle textStyle, Color color ,
  IconData icon, double width, double height,ShapeBorder shape, VoidCallback onPressed}) {
  return MaterialButton(
      onPressed:onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: color),),
          Icon(icon),
        ],
      ),
      minWidth: width,
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.pink),
      )
  );
}

Widget buildTextField({TextInputType keyboardType,TextStyle style,TextAlignVertical textAlignVertical,
  TextEditingController controller, String hintText, TextStyle hintStyle, Widget suffixIcon,
  Widget prefixIcon,InputBorder inputBorder, InputBorder focusedBorder,EdgeInsetsGeometry contentPadding }) {
  return TextFormField(
    textAlignVertical: textAlignVertical,
    style: style,
    keyboardType: keyboardType,
    controller: controller,
    decoration:InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
  );
}

