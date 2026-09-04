import 'package:flutter/material.dart';
import 'contato.dart';
import 'database.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key, this.contatoSelecionado});

  final Map? contatoSelecionado;

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final Database db = Database();
  TextEditingController nomeCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController telefoneCtrl = TextEditingController();

  String? id;

  @override
  void initState() {
    super.initState();
    id = widget.contatoSelecionado!['id'].toString();
    nomeCtrl.text = widget.contatoSelecionado!['nome'].toString();
    emailCtrl.text = widget.contatoSelecionado!['email'].toString();
    telefoneCtrl.text = widget.contatoSelecionado!['telefone'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dados do Contato")),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: telefoneCtrl,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
            ElevatedButton(
              onPressed: () {
                Database db = Database();
                if (widget.contatoSelecionado!['id'] == null) {
                  db.incluir(
                    Contato(
                      nome: nomeCtrl.text,
                      email: emailCtrl.text,
                      telefone: telefoneCtrl.text,
                    ),
                  );
                } else {
                  db.editar(
                    id!,
                    Contato(
                      nome: nomeCtrl.text,
                      email: emailCtrl.text,
                      telefone: telefoneCtrl.text,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text("Gravar"),
            ),
          ],
        ),
      ),
    );
  }
}