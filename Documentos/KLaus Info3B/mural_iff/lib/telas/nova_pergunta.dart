import 'package:flutter/material.dart';

import '../componentes.dart';
import '../modelos/pergunta.dart';
import '../servicos/banco.dart';
import '../servicos/validacao.dart';

class TelaNovaPergunta extends StatefulWidget {
  const TelaNovaPergunta({super.key});
  @override
  State<TelaNovaPergunta> createState() => _TelaNovaPerguntaState();
}

class _TelaNovaPerguntaState extends State<TelaNovaPergunta> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController(), _texto = TextEditingController();
  String _disciplina = disciplinas.first;
  bool _enviando = false;
  @override
  void dispose() {
    _titulo.dispose();
    _texto.dispose();
    super.dispose();
  }

  Future<void> _publicar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _enviando = true);
    try {
      await Banco().publicar(_titulo.text, _texto.text, _disciplina);
      if (mounted) Navigator.pop(context, true);
    } catch (erro) {
      if (mounted) avisar(context, mensagemErroBanco(erro));
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Publicar dúvida')),
    body: SafeArea(
      child: ConteudoCentral(
        largura: 680,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Qual é a sua dúvida?',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: verde),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explique o que está estudando e o que já tentou. Assim fica mais fácil ajudar.',
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  initialValue: _disciplina,
                  decoration: const InputDecoration(labelText: 'Disciplina'),
                  items: disciplinas
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: _enviando
                      ? null
                      : (v) => setState(() => _disciplina = v!),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _titulo,
                  enabled: !_enviando,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ex.: Quando usar um laço for?',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => validarTexto(v, 'Título', 5, 100),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _texto,
                  enabled: !_enviando,
                  maxLength: 2000,
                  minLines: 6,
                  maxLines: 12,
                  decoration: const InputDecoration(
                    labelText: 'Descreva sua dúvida',
                    alignLabelWithHint: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => validarTexto(v, 'Descrição', 10, 2000),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _enviando ? null : _publicar,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(
                    _enviando ? 'Publicando...' : 'Publicar no mural',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
