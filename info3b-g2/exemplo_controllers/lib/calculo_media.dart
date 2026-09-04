import 'package:flutter/material.dart';

class CalculoMedia extends StatefulWidget {
  const CalculoMedia({super.key});

  @override
  State<CalculoMedia> createState() => _CalculoMediaState();
}

class _CalculoMediaState extends State<CalculoMedia> {
  TextEditingController valor1 = TextEditingController();
  TextEditingController valor2 = TextEditingController();
  double media = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela do Cálculo")),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Cálculo de Média"),
              TextField(
                controller: valor1,
                decoration: const InputDecoration(
                  labelText: "Valor 1",
                  hintText: "0.00",
                ),
              ),
              TextField(
                controller: valor2,
                decoration: const InputDecoration(
                  labelText: "Valor 2",
                  hintText: "0.00",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    media = _calcularMedia(
                      double.parse(valor1.text),
                      double.parse(valor2.text),
                    );
                  });
                },
                child: const Text("Calcular"),
              ),
              Text("Resultado : $media"),
            ],
          ),
        ),
      ),
    );
  }
}

double _calcularMedia(double v1, double v2) {
  return (v1 + v2) / 2;
}
