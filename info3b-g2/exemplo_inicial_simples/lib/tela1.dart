import 'package:flutter/material.dart';

class Tela1 extends StatelessWidget {
  const Tela1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo Inicial Simples"),
        //backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Olá Mundo", style: TextStyle(fontSize: 25)),
            ElevatedButton(
              onPressed: () {
                var snackBar = SnackBar(content: Text("Exemplo de SnackBar"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text("Clique-me"),
            ),
          ],
        ),
      ),
    );
  }
}
