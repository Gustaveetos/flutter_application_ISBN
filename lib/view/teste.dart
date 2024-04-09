import 'package:flutter/material.dart';

class Teste extends StatefulWidget {
  const Teste({super.key});

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => {
          Navigator.popUntil(context, ModalRoute.withName('/')),
        },
        child: Text("Tela teste 1"),
      ),
    );
  }
}
