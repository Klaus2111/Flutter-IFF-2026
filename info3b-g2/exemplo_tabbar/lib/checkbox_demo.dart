import 'package:flutter/material.dart';

class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({super.key});

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool _checkboxValue1 = false;
  bool _checkboxValue2 = false;
  bool _checkboxValue3 = false;

  String _escolha = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _checkboxValue1,
                  onChanged: (value) {
                    setState(() {
                      _checkboxValue1 = value!;
                    });
                  },
                ),
                Text("Checkbox 1"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _checkboxValue2,
                  onChanged: (value) {
                    setState(() {
                      _checkboxValue2 = value!;
                    });
                  },
                ),
                Text("Checkbox 2"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _checkboxValue3,
                  onChanged: (value) {
                    setState(() {
                      _checkboxValue3 = value!;
                    });
                  },
                ),
                Text("Checkbox 3"),
              ],
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mostrarEscolha();
                });
              },
              child: Text("Atualizar"),
            ),
            SizedBox(height: 50),
            Text(_escolha),
          ],
        ),
      ),
    );
  }

  void _mostrarEscolha() {
    List<String> selecionados = [];

    if (_checkboxValue1) {
      selecionados.add("CheckBox 1");
    }

    if (_checkboxValue2) {
      selecionados.add("CheckBox 2");
    }

    if (_checkboxValue3) {
      selecionados.add("CheckBox 3");
    }

    _escolha = selecionados.join(", ");
  }
}
