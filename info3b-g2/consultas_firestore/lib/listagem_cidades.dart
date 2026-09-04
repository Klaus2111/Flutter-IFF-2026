import 'package:flutter/material.dart';

class ListagemCidades extends StatelessWidget {
  final List<Map<String, dynamic>> cidades;

  const ListagemCidades({super.key, required this.cidades});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem de Cidades')),
      body: ListView.builder(
        itemCount: cidades.length,
        itemBuilder: (context, index) {
          var cidade = cidades[index];
          return ListTile(
            title: Text(cidade['nome'] ?? 'Sem nome'),
            subtitle: Text(
              'País: ${cidade['pais'] ?? 'Desconhecido'}, População: ${cidade['populacao'] ?? 'N/A'}',
            ),
          );
        },
      ),
    );
  }
}
