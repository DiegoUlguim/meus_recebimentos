import 'package:flutter/material.dart';
import 'package:meus_recebimentos/geral.dart';
import 'package:meus_recebimentos/main.dart';
import 'package:meus_recebimentos/model/usuario_model.dart';
import 'package:meus_recebimentos/services/usuario_service.dart';
// import 'package:toast/toast.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CadastroUsuarioPageState createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {

  final txtNome = TextEditingController();
  final txtSenha = TextEditingController();

  String _validaCadastro(){
    if(usuarioAcessado==null)
      if(txtNome.text.trim()=="") {
        return "Favor informar o nome de usuário!";
      }

    if(txtSenha.text.trim()==""){
      return "Favor informar a senha!";
    }
    return "";

  }

  Future<void> _adicionaUsuario() async{
    String mens = _validaCadastro();
    if(mens!=""){
      // Toast.show(mens, context,duration: 3);
      return;
    }

    if(usuarioAcessado==null){
      Usuario usuario = Usuario(
          txtNome.text.trim(),
          txtSenha.text
      );
      await UsuarioService.addUsuario(usuario);
      // Toast.show("Cadastro de Usuario realizado com sucesso!", context,duration: 3);
      Navigator.popAndPushNamed(context, MENU);
    }else if(usuarioAcessado.senha==txtSenha.text){
      // Toast.show("Bem Vindo, " + usuarioAcessado!.nome + "!", context,duration: 3);
      Navigator.popAndPushNamed(context, MENU);
    }else{}
      // Toast.show('Senha Incorreta!', context,duration: 3);
  }
  Future<void> _buscaUsuario() async{
    List<Usuario> usuarios;
    var res = await UsuarioService.getAllUsuario();

    usuarios = res.cast<Usuario>();
    if (usuarios.isNotEmpty){
      setState(() {
        usuarioAcessado = usuarios?.first;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _buscaUsuario();
  }
  Widget buildText(String label, BuildContext context, {
    IconData icon,
    TextEditingController campoText,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,var funcao,double width})
  {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 10.0,left: 10.0),

      child: TextField(
        controller: campoText,
        keyboardType: textInputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
        ),
        onChanged: funcao,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_forward_ios,size: 30,color: Colors.black,),
        onPressed: _adicionaUsuario,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/2.5,
              padding: const EdgeInsets.only(left: 40),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: const <Widget>[
                        Text(
                          'Olá',
                          style: TextStyle(fontSize: 50,color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          usuarioAcessado==null?'':usuarioAcessado.nome.toUpperCase(),
                          style: const TextStyle(fontSize: 50,color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
            Container(
//              width: MediaQuery.of(context).size.width/1.2,
//              height: MediaQuery.of(context).size.height/3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(15)
                ),
                color: Colors.white,
              ),
              //color: Colors.white,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Visibility(visible: usuarioAcessado==null,child:buildText('Nome', context,campoText: txtNome),),
                  buildText('Senha', context,campoText: txtSenha,textInputType: TextInputType.number,obscureText: true),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

