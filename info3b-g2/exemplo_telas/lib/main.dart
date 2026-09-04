import 'package:flutter/material.dart';
import 'primeira_tela.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exemplo Telas",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(backgroundColor: Colors.amber),
        scaffoldBackgroundColor: Colors.green,
      ),
      home: PrimeiraTela(),
    );
  }
}
