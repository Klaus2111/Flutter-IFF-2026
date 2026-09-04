import 'package:flutter/material.dart';

class ExemploSnackbar extends StatelessWidget {
  const ExemploSnackbar({super.key});

  @override
  Widget build(BuildContext context) {
    mostrarMensagem() {
      SnackBar msg = SnackBar(
        content: Text("Exemplo de SnackBar"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.purple,
        action: SnackBarAction(
          label: "Fechar",
          onPressed: () {
            print("Snackbar pressionado");
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(msg);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Exemplo SnackBar")),
      body: Center(
        child: ElevatedButton(
          onPressed: mostrarMensagem,
          child: Text("Snackbar"),
        ),
      ),
    );
  }
}
