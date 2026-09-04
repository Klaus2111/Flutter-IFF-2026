import 'package:flutter/material.dart';
import 'segunda_tela.dart';

class PrimeiraTela extends StatelessWidget {
  const PrimeiraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Primeira Tela")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SegundaTela()),
            );
          },
          child: Text("Abrir rota (2a tela)"),
        ),
      ),
    );
  }
}
