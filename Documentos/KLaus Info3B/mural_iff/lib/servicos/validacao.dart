String? validarTexto(String? valor, String nome, int minimo, int maximo) {
  final texto = (valor ?? '').trim();
  if (texto.length < minimo) {
    return '$nome: escreva pelo menos $minimo caracteres.';
  }
  if (texto.length > maximo) return '$nome: use no máximo $maximo caracteres.';
  return null;
}

String? validarEmail(String? valor) {
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch((valor ?? '').trim())) {
    return 'Informe um e-mail válido.';
  }
  return null;
}

String? validarSenha(String? valor, {required bool cadastro}) {
  if (valor == null || valor.isEmpty) return 'Informe sua senha.';
  if (cadastro && valor.length < 6) return 'Use pelo menos 6 caracteres.';
  return null;
}
