import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String status = '';

  @override
  void initState() {
    super.initState();
    User.verificaUsuario().then((value) {
      if (value != null) Navigator.pushNamed(context, '/tela1');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("logo.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
        appBar: AppBar(
          title: const Text('Pesquisa Livro Brasil'),
        ),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: const Image(
                    image: AssetImage('logo.png'),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.zero),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  height: 200,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        controller: userController,
                        decoration: const InputDecoration(
                            label: Text('Usuario:'),
                            hintText: 'Digite seu e-mail',
                            icon: Icon(Icons.accessibility_new)),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text('Senha:'),
                            hintText: 'Digite sua senha',
                            icon: Icon(Icons.key)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String username = userController.text;
                          String pass = passwordController.text;
                          DateTime agora = DateTime.now();
                          String dataFormatada =
                              DateFormat('dd-mm-yy').format(agora);
                          User user = User(username, pass, dataFormatada);
                          user.autentica().then(
                            (value) {
                              if (value['resposta'] == 'ok') {
                                user.insereUsuario().then((value) {
                                  if (value > 0) {
                                    Navigator.pushNamed(context, '/tela2');
                                  }
                                });
                              } else {
                                setState(() {
                                  status = value['motivo']!;
                                });
                              }
                            },
                          );
                        },
                        child: const Text('Login'),
                      ),
                      Text(
                        status,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
