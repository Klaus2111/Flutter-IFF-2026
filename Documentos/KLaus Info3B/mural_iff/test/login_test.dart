import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mural_iff/telas/login.dart';

void main() {
  testWidgets(
    'Login cabe em tela pequena e valida cadastro antes de conectar',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: TelaLogin()));
      await tester.pumpAndSettle();
      expect(find.text('Mural IFF'), findsOneWidget);
      await tester.ensureVisible(find.text('Ainda não tenho conta. Cadastrar'));
      await tester.tap(find.text('Ainda não tenho conta. Cadastrar'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Criar conta'));
      await tester.tap(find.text('Criar conta'));
      await tester.pumpAndSettle();
      expect(find.text('Informe um e-mail válido.'), findsOneWidget);
      expect(
        find.text('Nome: escreva pelo menos 2 caracteres.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
