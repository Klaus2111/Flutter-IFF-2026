import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../componentes.dart';
import '../modelos/pergunta.dart';
import '../servicos/banco.dart';
import 'detalhes.dart';
import 'nova_pergunta.dart';

class TelaMural extends StatefulWidget {
  const TelaMural({super.key});
  @override
  State<TelaMural> createState() => _TelaMuralState();
}

class _TelaMuralState extends State<TelaMural> {
  final _banco = Banco();
  String _disciplina = 'Todas', _situacao = 'Todas';
  late Stream<QuerySnapshot<Map<String, dynamic>>> _consulta;
  @override
  void initState() {
    super.initState();
    _atualizarConsulta();
  }

  void _atualizarConsulta() {
    _consulta = _banco.observarPerguntas(
      _disciplina == 'Todas' ? null : _disciplina,
      _situacao == 'Todas' ? null : _situacao == 'Resolvidas',
    );
  }

  Future<void> _novaPergunta() async {
    final publicou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const TelaNovaPergunta()),
    );
    if (publicou == true && mounted) avisar(context, 'Dúvida publicada!');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.forum_outlined, color: verde),
          SizedBox(width: 10),
          Text('Mural IFF'),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Sair da conta',
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _novaPergunta,
      icon: const Icon(Icons.add),
      label: const Text('Publicar dúvida'),
    ),
    body: SafeArea(
      child: ConteudoCentral(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 14),
              Text(
                'Aprender fica melhor\nem comunidade.',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800, color: verde),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pergunte, compartilhe o que sabe e encontre respostas.',
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      key: ValueKey('disciplina-$_disciplina'),
                      initialValue: _disciplina,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Disciplina',
                      ),
                      items: ['Todas', ...disciplinas]
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() {
                        _disciplina = v!;
                        _atualizarConsulta();
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      key: ValueKey('situacao-$_situacao'),
                      initialValue: _situacao,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Situação'),
                      items: ['Todas', 'Abertas', 'Resolvidas']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() {
                        _situacao = v!;
                        _atualizarConsulta();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _consulta,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SingleChildScrollView(
                        child: MensagemVazia(
                          icone: Icons.cloud_off_outlined,
                          titulo: 'Não foi possível carregar',
                          texto: mensagemErroBanco(snapshot.error!),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const SingleChildScrollView(
                        child: MensagemVazia(
                          icone: Icons.chat_bubble_outline,
                          titulo: 'Nenhuma dúvida por aqui',
                          texto: 'Publique uma pergunta ou experimente outros filtros.',
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 96, top: 4),
                      itemCount: docs.length + 1,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == docs.length) {
                          return const Text(
                            'Até 100 dúvidas mais recentes deste filtro.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          );
                        }
                        final p = Pergunta.fromDocumento(docs[index]);
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFFDFE7E1)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TelaDetalhes(perguntaId: p.id),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(height: 12),
                                  Text(
                                    p.titulo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.texto,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '${p.autorNome} • ${formatarData(p.criadaEm)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
