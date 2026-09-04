import 'package:flutter/material.dart';

class ExemploAlertDialog extends StatelessWidget {
  const ExemploAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    mostrarMensagem() {
      AlertDialog msg = AlertDialog(
        title: Row(
          children: [Icon(Icons.alarm_on), Text("   Um Alert Dialog")],
        ),
        content: SizedBox(
          width: 250,
          height: 50,
          child: Center(child: Text("Exemplo de Alert Dialog")),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok, ciente"),
          ),
        ],
      );
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return msg;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Exemplo AlertDialog")),
      body: Center(
        child: ElevatedButton(
          onPressed: mostrarMensagem,
          child: Text("AlertDialog"),
        ),
      ),
    );
  }
}
