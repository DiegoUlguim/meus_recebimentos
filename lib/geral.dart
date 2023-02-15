import 'dart:ui';

import 'package:flutter/material.dart';

import 'model/conta_model.dart';

const String MENU = '/menu';
const String HOME = '/home';
const String TOTAIS = '/totais';
const String CADASTRO_CONTA = '/cadastroConta';
const String ALTERA_CONTA = '/alteraConta';
const String CADASTRO_LOGIN = '/';


Color retornaCorConta(Conta conta){
  Color cor = Colors.orange;
  if(conta.pago==1){
    cor=Colors.green;
  }

  return cor;
}
String retornaDataVisualFormat(DateTime data){
  return data.day.toString().padLeft(2, '0')
      +"/"+data.month.toString().padLeft(2, '0')
      +"/"+data.year.toString().padLeft(2, '0');
}
String removeMarcara(String valor){
  valor = valor.replaceAll("R\$", "");
  valor = valor.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll("/", "").replaceAll(".", "").replaceAll(" ", "").trim();
  return valor;
}