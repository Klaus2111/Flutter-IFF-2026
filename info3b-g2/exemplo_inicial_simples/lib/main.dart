import 'package:flutter/material.dart';
import 'tela1.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exemplo Inicial Simples",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(backgroundColor: Colors.green),
      ),
      home: Tela1(),
    );
  }
}
