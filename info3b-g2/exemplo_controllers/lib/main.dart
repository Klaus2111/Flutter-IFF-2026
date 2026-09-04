import 'package:flutter/material.dart';
import 'principal.dart';
import 'calculo_media.dart';
import 'creditos.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exemplo Controllers",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      routes: <String, WidgetBuilder>{
        '/CalculoMedia': (BuildContext context) => CalculoMedia(),
        '/Creditos': (BuildContext context) => Creditos(),
      },
      home: Principal(),
    );
  }
}
