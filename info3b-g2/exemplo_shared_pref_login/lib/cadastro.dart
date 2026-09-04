import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'principal.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController nomeCtrl = TextEditingController();

  Future<void> salvar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("usuario", nomeCtrl.text);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Principal(nome: nomeCtrl.text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Primeiro Acesso")),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: InputDecoration(labelText: "Seu Nome"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: salvar, child: const Text("Cadastrar")),
          ],
        ),
      ),
    );
  }
}
