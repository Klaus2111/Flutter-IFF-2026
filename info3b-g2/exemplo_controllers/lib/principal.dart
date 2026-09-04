import 'package:flutter/material.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cálculo de Média")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/CalculoMedia");
              },
              child: Text("Cálculo"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/Creditos");
              },
              child: Text("Créditos"),
            ),
          ],
        ),
      ),
    );
  }
}
