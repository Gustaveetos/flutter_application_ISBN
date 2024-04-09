import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/api/apibrasil.dart';

class Tela2 extends StatefulWidget {
  const Tela2({Key? key}) : super(key: key);

  @override
  _Tela2State createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  late Future<Map<String, dynamic>> _livroFuture;

  final TextEditingController isbnRestanteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _livroFuture = _buscarLivro();
  }

  Future<Map<String, dynamic>> _buscarLivro() async {
    final prefixo = '978';
    final isbnRestante = isbnRestanteController.text;
    final isbn = prefixo + isbnRestante;

    return ApiISBN.getLivro(int.tryParse(isbn) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Pesquisa Livro Brasil",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 53, 53, 53),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: isbnRestanteController,
                  maxLength: 10,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'ISBN (Formato 13 dígitos, após "978-")',
                    labelStyle: TextStyle(color: const Color.fromARGB(163, 255, 255, 255)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _livroFuture = _buscarLivro();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 34, 34, 34),
                  ),
                  child: Text('Buscar Livro'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _livroFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}',style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),));
                } else {
                  Map<String, dynamic> livro = snapshot.data!;
                  return Card(
                    child: ListTile(
                      title: Text(
                        livro['title'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Autor(es): ${_processarAutores(livro['authors'])}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Editora: ${livro['publisher'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ano: ${livro['year'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Páginas: ${livro['page_count'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sinopse: ${livro['synopsis'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _processarAutores(List<dynamic>? autores) {
    if (autores != null && autores.isNotEmpty) {
      return autores.join(', ');
    } else {
      return '';
    }
  }
}
