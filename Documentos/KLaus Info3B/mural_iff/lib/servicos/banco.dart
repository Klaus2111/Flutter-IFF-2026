import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modelos/pergunta.dart';

class Banco {
  final perguntas = FirebaseFirestore.instance.collection('perguntas');

  // As duas consultas com filtros são executadas no Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>> observarPerguntas(
    String? disciplina,
    bool? resolvida,
  ) {
    Query<Map<String, dynamic>> consulta = perguntas;
    if (disciplina != null) {
      consulta = consulta.where('disciplina', isEqualTo: disciplina);
    }
    if (resolvida != null) {
      consulta = consulta.where('resolvida', isEqualTo: resolvida);
    }
    return consulta
        .orderBy('criadaEm', descending: true)
        .limit(100)
        .snapshots();
  }

  Future<void> publicar(String titulo, String texto, String disciplina) async {
    final usuario = FirebaseAuth.instance.currentUser!;
    await perguntas.add({
      'titulo': titulo.trim(),
      'texto': texto.trim(),
      'disciplina': disciplina,
      'autorId': usuario.uid,
      'autorNome': usuario.displayName ?? 'Estudante',
      'resolvida': false,
      'criadaEm': FieldValue.serverTimestamp(),
    });
  }

  // Subcoleção: perguntas / ID_DA_PERGUNTA / respostas.
  CollectionReference<Map<String, dynamic>> respostas(String id) =>
      perguntas.doc(id).collection('respostas');
  Future<void> responder(String id, String texto) async {
    final usuario = FirebaseAuth.instance.currentUser!;
    await respostas(id).add({
      'texto': texto.trim(),
      'autorId': usuario.uid,
      'autorNome': usuario.displayName ?? 'Estudante',
      'criadaEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> alterarSituacao(Pergunta p) =>
      perguntas.doc(p.id).update({'resolvida': !p.resolvida});
}

String mensagemErroBanco(Object erro) {
  if (erro is FirebaseException) {
    if (erro.code == 'permission-denied') {
      return 'Sem permissão. Confira seu login e as regras do banco.';
    }
    if (erro.code == 'failed-precondition') {
      return 'Este filtro precisa de um índice do Firestore. Consulte a configuração do projeto.';
    }
    if (erro.code == 'unavailable') {
      return 'Sem conexão com o banco. Tente novamente.';
    }
  }
  return 'Não foi possível concluir. Confira sua conexão e tente novamente.';
}
