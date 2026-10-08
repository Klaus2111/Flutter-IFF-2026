import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../componentes.dart';
import '../modelos/pergunta.dart';
import '../servicos/banco.dart';
import '../servicos/validacao.dart';

class TelaDetalhes extends StatefulWidget {
  final String perguntaId;
  const TelaDetalhes({super.key, required this.perguntaId});
  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final _banco = Banco(), _form = GlobalKey<FormState>();
  final _resposta = TextEditingController();
  bool _enviando = false, _alterando = false;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _pergunta;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _respostas;
  @override
  void initState() {
    super.initState();
    _pergunta = _banco.perguntas.doc(widget.perguntaId).snapshots();
    _respostas = _banco
        .respostas(widget.perguntaId)
        .orderBy('criadaEm')
        .snapshots();
  }

  @override
  void dispose() {
    _resposta.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _enviando = true);
    try {
      await _banco.responder(widget.perguntaId, _resposta.text);
      if (mounted) {
        _resposta.clear();
        FocusScope.of(context).unfocus();
        avisar(context, 'Resposta enviada!');
      }
    } catch (erro) {
      if (mounted) avisar(context, mensagemErroBanco(erro));
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _mudarSituacao(Pergunta p) async {
    setState(() => _alterando = true);
    try {
      await _banco.alterarSituacao(p);
    } catch (erro) {
      if (mounted) avisar(context, mensagemErroBanco(erro));
    } finally {
      if (mounted) setState(() => _alterando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Conversa da dúvida')),
    body: SafeArea(
      child: ConteudoCentral(
        largura: 760,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _pergunta,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return MensagemVazia(
                icone: Icons.cloud_off_outlined,
                titulo: 'Erro ao carregar',
                texto: mensagemErroBanco(snapshot.error!),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.data!.exists) {
              return const MensagemVazia(
                icone: Icons.search_off,
                titulo: 'Dúvida não encontrada',
                texto: 'Volte ao mural e escolha outra publicação.',
              );
            }
            final p = Pergunta.fromDocumento(snapshot.data!);
            final souAutor =
                p.autorId == FirebaseAuth.instance.currentUser?.uid;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Etiqueta(p.disciplina),
                      Etiqueta(
                        p.resolvida ? 'Resolvida' : 'Aberta',
                        destaque: p.resolvida,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    p.titulo,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${p.autorNome} • ${formatarData(p.criadaEm)}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  SelectableText(
                    p.texto,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  if (souAutor) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _alterando ? null : () => _mudarSituacao(p),
                        icon: Icon(
                          p.resolvida
                              ? Icons.refresh
                              : Icons.check_circle_outline,
                        ),
                        label: Text(
                          p.resolvida
                              ? 'Reabrir dúvida'
                              : 'Marcar como resolvida',
                        ),
                      ),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  Text(
                    'Respostas da comunidade',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  // O StreamBuilder recebe as respostas novas sem precisar recarregar.
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _respostas,
                    builder: (context, respostas) {
                      if (respostas.hasError) {
                        return Text(mensagemErroBanco(respostas.error!));
                      }
                      if (!respostas.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (respostas.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Ainda não há respostas. Compartilhe uma explicação ou uma dica.',
                          ),
                        );
                      }
                      return Column(
                        children: respostas.data!.docs.map((doc) {
                          final r = doc.data();
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFDFE7E1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['autorNome'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: verde,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SelectableText(r['texto'] as String),
                                const SizedBox(height: 10),
                                Text(
                                  formatarData(
                                    (r['criadaEm'] as Timestamp?)?.toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _resposta,
                          enabled: !_enviando,
                          minLines: 3,
                          maxLines: 8,
                          maxLength: 2000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Sua contribuição',
                            hintText:
                                'Explique seu raciocínio e ajude um colega.',
                            alignLabelWithHint: true,
                          ),
                          validator: (v) =>
                              validarTexto(v, 'Resposta', 2, 2000),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: _enviando ? null : _enviar,
                          icon: const Icon(Icons.reply_outlined),
                          label: Text(
                            _enviando ? 'Enviando...' : 'Enviar resposta',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
