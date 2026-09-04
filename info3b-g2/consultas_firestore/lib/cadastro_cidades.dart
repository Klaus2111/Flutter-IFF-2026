import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastroCidades extends StatefulWidget {
  const CadastroCidades({super.key});

  @override
  State<CadastroCidades> createState() => _CadastroCidadesState();
}

class _CadastroCidadesState extends State<CadastroCidades> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Controllers para os campos de entrada
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _populacaoController = TextEditingController();
  bool _eCapital = false;
  final TextEditingController _bairrosController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _estadoController.dispose();
    _paisController.dispose();
    _populacaoController.dispose();
    _bairrosController.dispose();
    super.dispose();
  }

  Future<void> _registrarCidade() async {
    if (_formKey.currentState!.validate()) {
      try {
        await firestore.collection('cidades').add({
          'nome': _nomeController.text,
          'estado': _estadoController.text.isNotEmpty
              ? _estadoController.text
              : null,
          'pais': _paisController.text,
          'capital': _eCapital,
          'populacao': int.parse(_populacaoController.text),
          'bairros': _bairrosController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
        });
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cidade registrada com sucesso!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _eCapital = false;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cidade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Insira um nome' : null,
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: _paisController,
                  decoration: const InputDecoration(labelText: 'País'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Insira um país' : null,
                ),
                TextFormField(
                  controller: _populacaoController,
                  decoration: const InputDecoration(labelText: 'População'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira a população';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Insira um número válido';
                    }
                    return null;
                  },
                ),
                SwitchListTile(
                  title: const Text('É Capital'),
                  value: _eCapital,
                  onChanged: (value) {
                    setState(() {
                      _eCapital = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _bairrosController,
                  decoration: const InputDecoration(
                    labelText: 'Bairros (separe com vírgula)',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _registrarCidade,
                  child: const Text('Registrar cidade'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
