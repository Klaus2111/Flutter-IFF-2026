import 'package:flutter/material.dart';

class ExemploTooltip extends StatelessWidget {
  const ExemploTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Tooltip")),
      body: Center(
        child: Tooltip(
          message: "Sou uma Tooltip",
          child: Text("Passe o mouse sobre o texto para ver um Tooltip."),
        ),
      ),
    );
  }
}
