import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'listagem_cidades.dart';

class ConsultaCidades extends StatefulWidget {
  const ConsultaCidades({super.key});

  @override
  State<ConsultaCidades> createState() => _ConsultaCidadesState();
}

class _ConsultaCidadesState extends State<ConsultaCidades> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();

  @override
  void dispose() {
    _paisController.dispose();
    _bairroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplos de Consulta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => obterTodas(context),
              child: const Text('Obter todas as Cidades'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paisController,
                    decoration: const InputDecoration(labelText: "País"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      filtrarPorPais(context, _paisController.text),
                  child: const Text('Filtrar por país'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => obterTresMaisPopulosas(context),
              child: const Text('Obter as 3 cidades mais populosas'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bairroController,
                    decoration: const InputDecoration(labelText: "Bairro"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      filtrarPorBairroEcapital(context, _bairroController.text),
                  child: const Text('Filtrar por bairro e se é capital'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método genérico para executar qualquer consulta Firestore
  Future<void> _executarConsulta(
    BuildContext context,
    Query<Map<String, dynamic>> query,
  ) async {
    final snapshot = await query.get();
    if (!context.mounted) return;

    final List<Map<String, dynamic>> cidades = snapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();
    listarCidades(context, cidades);
  }

  // Navega para a tela de listagem de cidades
  void listarCidades(
    BuildContext context,
    List<Map<String, dynamic>> cidades,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListagemCidades(cidades: cidades),
      ),
    );
  }

  void obterTodas(BuildContext context) {
    _executarConsulta(context, firestore.collection('cidades'));
  }

  void filtrarPorPais(BuildContext context, String pais) {
    _executarConsulta(
      context,
      firestore.collection('cidades').where('pais', isEqualTo: pais),
    );
  }

  void obterTresMaisPopulosas(BuildContext context) {
    _executarConsulta(
      context,
      firestore
          .collection('cidades')
          .orderBy('populacao', descending: true)
          .limit(3),
    );
  }

  void filtrarPorBairroEcapital(BuildContext context, String bairro) {
    _executarConsulta(
      context,
      firestore
          .collection('cidades')
          .where('bairros', arrayContains: bairro)
          .where('capital', isEqualTo: true),
    );
  }
}
