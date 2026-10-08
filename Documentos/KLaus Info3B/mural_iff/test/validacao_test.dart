import 'package:flutter_test/flutter_test.dart';
import 'package:mural_iff/servicos/validacao.dart';
import 'package:mural_iff/servicos/preferencias.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'Formulários recusam texto vazio, espaços e conteúdo acima do limite',
    () {
      expect(validarTexto('     ', 'Título', 5, 100), isNotNull);
      expect(validarTexto('Como funciona o for?', 'Título', 5, 100), isNull);
      expect(validarTexto('a' * 101, 'Título', 5, 100), isNotNull);
      expect(validarTexto('  abcde  ', 'Título', 5, 100), isNull);
    },
  );
  test('E-mail e senha recebem validação de cadastro', () {
    expect(validarEmail('aluno@exemplo.com'), isNull);
    expect(validarEmail('aluno @exemplo.com'), isNotNull);
    expect(validarEmail('email-incompleto'), isNotNull);
    expect(validarSenha('12345', cadastro: true), isNotNull);
    expect(validarSenha('123456', cadastro: true), isNull);
  });
  test('Desmarcar lembrar e-mail remove o endereço salvo', () async {
    SharedPreferences.setMockInitialValues({});
    await Preferencias.salvarEmail(' aluno@exemplo.com ', true);
    expect(await Preferencias.lerEmail(), 'aluno@exemplo.com');
    await Preferencias.salvarEmail('aluno@exemplo.com', false);
    expect(await Preferencias.lerEmail(), isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('email'), isFalse);
    expect(prefs.containsKey('senha'), isFalse);
  });
}
