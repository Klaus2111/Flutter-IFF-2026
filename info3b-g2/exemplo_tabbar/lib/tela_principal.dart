import 'package:flutter/material.dart';
import 'checkbox_demo.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text("Exemplo de Componentes"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.check_box)),
              Tab(icon: Icon(Icons.looks_one)),
              Tab(icon: Icon(Icons.radio_button_checked)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: CheckboxDemo()),
            Center(child: Text("Tela do Stepper")),
            Center(child: Text("Tela do RadioButton")),
          ],
        ),
      ),
    );
  }
}
