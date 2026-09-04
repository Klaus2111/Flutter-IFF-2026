import 'package:flutter/material.dart';

class Creditos extends StatelessWidget {
  const Creditos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créditos")),
      body: Padding(
        padding: EdgeInsets.only(top: 200, bottom: 200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Desenvolvedor: Leandro Foly"),
              Text("Copyright 2022 LeFoly Sistemas"),
              Text("Todos os direitos reservados"),
            ],
          ),
        ),
      ),
    );
  }
}
