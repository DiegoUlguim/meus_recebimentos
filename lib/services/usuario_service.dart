import 'package:meusrecebimentos/model/usuario_model.dart';
import 'package:meusrecebimentos/persistence/db.dart';

class UsuarioService{
  static Future<List<Usuario>> getAllUsuario() async{
    final sql = '''SELECT * FROM ${DatabaseCreator.usuarioTable}''';
    final data = await db.rawQuery(sql);
    List<Usuario> usuarios = List();

    for (final node in data){
      final usuario = Usuario.fromJson(node);
      usuarios.add(usuario);
    }
    return usuarios;
  }

  static Future<Usuario> getUsuario(int id) async{
    final sql = '''SELECT * FROM ${DatabaseCreator.usuarioTable}
   WHERE ${DatabaseCreator.id} == $id''';
    final data =await db.rawQuery(sql);

    final usuario = Usuario.fromJson(data[0]);
    return usuario;
  }

  static Future<void> addUsuario(Usuario usuario) async{
    final sql = '''INSERT INTO ${DatabaseCreator.usuarioTable}
   (
      ${DatabaseCreator.nome},
      ${DatabaseCreator.senha}
   )
   VALUES
   (
      '${usuario.nome}',
      '${usuario.senha}'
   )''';

    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add Usuario', sql,null,result);
  }

  static Future<void> deleteUsuario(int id) async{
    final sql = '''DELETE FROM ${DatabaseCreator.usuarioTable}
   WHERE ${DatabaseCreator.id} == ${id}''';

    final result = await db.rawDelete(sql);
    DatabaseCreator.databaseLog('Delete Usuario', sql,null,result);
  }

  static Future<void> updateUsuario(Usuario usuario) async{
    final sql = '''UPDATE ${DatabaseCreator.usuarioTable}
   SET 
    ${DatabaseCreator.nome} = '${usuario.nome}',
    ${DatabaseCreator.senha} = '${usuario.senha}'
    WHERE ${DatabaseCreator.id} = ${usuario.id}''';

    final result = await db.rawUpdate(sql);
    DatabaseCreator.databaseLog('Update Usuario', sql,null,result);
  }

  static Future<int> usuarioCount() async{
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.usuarioTable}''');

    int count = data[0].values.elementAt(0);
    return count;
  }

}