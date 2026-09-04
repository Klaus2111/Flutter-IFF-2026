import 'package:exemplo_mensagens/exemplo_alert_dialog.dart';
import 'package:exemplo_mensagens/exemplo_snackbar.dart';
import 'package:exemplo_mensagens/exemplo_tooltip.dart';
import 'package:flutter/material.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Mensagens")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExemploTooltip()),
                );
              },
              child: Text("ToolTip"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExemploSnackbar()),
                );
              },
              child: Text("SnackBar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExemploAlertDialog()),
                );
              },
              child: Text("AlertDialog"),
            ),
            ElevatedButton(onPressed: () {}, child: Text("SimpleDialog")),
          ],
        ),
      ),
    );
  }
}
