import 'package:flutter/material.dart';

import 'cadastro_cidades.dart';
import 'consulta_cidades.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Cidades')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroCidades(),
                  ),
                );
              },
              child: const Text('Cadastro'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsultaCidades(),
                  ),
                );
              },
              child: const Text('Consultas'),
            ),
          ],
        ),
      ),
    );
  }
}
