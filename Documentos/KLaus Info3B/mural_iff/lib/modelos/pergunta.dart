import 'package:cloud_firestore/cloud_firestore.dart';

const disciplinas = [
  'Programação',
  'Banco de Dados',
  'Redes',
  'Matemática',
  'Português',
  'Física',
  'Química',
  'Biologia',
  'Outras',
];

// Um objeto representa um documento da coleção perguntas.
class Pergunta {
  final String id, titulo, texto, disciplina, autorId, autorNome;
  final bool resolvida;
  final DateTime? criadaEm;
  Pergunta.fromDocumento(DocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
      titulo = doc.data()!['titulo'] as String,
      texto = doc.data()!['texto'] as String,
      disciplina = doc.data()!['disciplina'] as String,
      autorId = doc.data()!['autorId'] as String,
      autorNome = doc.data()!['autorNome'] as String,
      resolvida = doc.data()!['resolvida'] as bool,
      criadaEm = (doc.data()!['criadaEm'] as Timestamp?)?.toDate();
}

String formatarData(DateTime? data) {
  if (data == null) return 'Enviando...';
  String dois(int n) => n.toString().padLeft(2, '0');
  return '${dois(data.day)}/${dois(data.month)}/${data.year} às ${dois(data.hour)}:${dois(data.minute)}';
}
