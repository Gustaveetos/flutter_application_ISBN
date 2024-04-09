import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiISBN {
  static Future<Map<String, dynamic>> getLivro(int isbn) async {
    final List<String> provedores = ["mercado-editorial", "open-library", "google-books", "cbl"];
    final List<Map<String, dynamic>> resultados = [];

    for (final provedor in provedores) {
      final url = 'https://brasilapi.com.br/api/isbn/v1/$isbn?provider=$provedor';

      final resposta = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (resposta.statusCode == 200) {
        final data = json.decode(resposta.body) as Map<String, dynamic>;
        resultados.add(data);
      } else {
        throw Exception('Erro ao buscar o livro do provedor. Código de status: ${resposta.statusCode}');
      }
    }

    final resultadoFinal = <String, dynamic>{};
    for (final resultado in resultados) {
      resultadoFinal.addAll(resultado);
    }

    return resultadoFinal;
  }
}
