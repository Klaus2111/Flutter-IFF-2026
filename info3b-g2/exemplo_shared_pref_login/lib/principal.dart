import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatelessWidget {
  final String nome;

  const Principal({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    Future<void> efetuarLogoff() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("usuario");
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Sistema")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Bem-vindo, $nome!", style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: efetuarLogoff,
              child: Text("Efetuar Logoff"),
            ),
          ],
        ),
      ),
    );
  }
}
