import 'package:flutter/material.dart';

Widget textFormatDropDown(String text){
  return Container(
    width: 1000,
    margin: const EdgeInsets.only(bottom: 5),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.black12),
      ),
    ),
    child: Text(text),
  );
}
Widget buildText(String label, BuildContext context, {
  IconData icon,
  TextEditingController campoText,
  TextInputType textInputType = TextInputType.text,
  bool obscureText = false,var funcao, double width})
{
  return Container(
    width: width,
    margin: const EdgeInsets.only(right: 10.0,left: 10.0),
    child: TextField(
      controller: campoText,
      keyboardType: textInputType,
      obscureText: obscureText,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: funcao,
    ),
  );
}