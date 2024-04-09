import 'dart:convert';
import 'package:flutter_application_1/model/db/banco.dart';
import 'package:http/http.dart' as http;

class User {
  String username;
  String password;
  String ultimoLogin;

  User(this.username, this.password, this.ultimoLogin);

  Future<Map<String, dynamic>> autentica() async {
    final resposta = await http.post(
        Uri.parse('https://tarrafa.unimontes.br/aula/autentica'),
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'username': this.username, 'password': this.password}));

    return json.decode(resposta.body) as Map<String, dynamic>;
  }

  Future<int> insereUsuario() async {
    final bd = await Banco.instance.database;
    return bd.rawInsert(
        """INSERT OR REPLACE INTO user(usernome,password,ultimo_login)VALUES('${this.username}','${this.password}','${this.ultimoLogin}')""");
  }

  static Future<User?> verificaUsuario() async {
    final db = await Banco.instance.database;
    List<Map<String, Object?>> lista = await db.rawQuery('SELECT *from user');
    if (lista.isNotEmpty) {
      Map<String, Object?> uTemp = lista.first;
      User user = User(uTemp['username'].toString(),
          uTemp['password'].toString(), uTemp['ultimo_login'].toString());
      return user;
    }
    return null;
  }

  Future<int> removeUsuario() async {
    final db = await Banco.instance.database;
    return db.rawDelete("""DELETE FROM user where username = '${this.username}'
    """);
  }
}
