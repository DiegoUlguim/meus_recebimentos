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