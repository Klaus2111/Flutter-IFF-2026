import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Listagem extends StatefulWidget {
  const Listagem({super.key});

  @override
  State<Listagem> createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  List<Map<String, dynamic>> docs = [];

  @override
  void initState() {
    super.initState();
    carregarLista();
  }

  Future carregarLista() async {
    final db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection('pessoas').get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> a = {
          "nome": doc['nome'],
          "email": doc["email"],
          "idade": doc["idade"],
        };
        docs.add(a);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listagem")),
      body: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(5),
            color: Colors.green[100],
            child: ListTile(
              contentPadding: const EdgeInsets.all(5),
              title: Text(docs[index]['nome']),
              subtitle: Text(docs[index]['email']),
              trailing: Text("Idade: ${docs[index]['idade']}"),
            ),
          );
        },
      ),
    );
  }
}
