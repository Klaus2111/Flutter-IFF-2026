import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../componentes.dart';
import '../servicos/preferencias.dart';
import '../servicos/validacao.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController(),
      _email = TextEditingController(),
      _senha = TextEditingController();
  bool _cadastro = false,
      _lembrar = false,
      _ocultar = true,
      _carregando = false;
  late final Future<void> _preferencias;
  @override
  void initState() {
    super.initState();
    _preferencias = _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final email = await Preferencias.lerEmail();
    if (!mounted) return;
    _email.text = email;
    _lembrar = email.isNotEmpty;
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _carregando = true);
    try {
      await Preferencias.salvarEmail(_email.text, _lembrar);
      final auth = FirebaseAuth.instance;
      final nome = _nome.text.trim();
      if (_cadastro) {
        final credencial = await auth.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _senha.text,
        );
        await credencial.user!.updateDisplayName(nome);
      } else {
        await auth.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _senha.text,
        );
      }
    } on FirebaseAuthException catch (erro) {
      final mensagens = {
        'email-already-in-use': 'Este e-mail já tem cadastro. Use Entrar.',
        'invalid-credential': 'E-mail ou senha incorretos.',
        'wrong-password': 'E-mail ou senha incorretos.',
        'user-not-found': 'E-mail ou senha incorretos.',
        'invalid-email': 'O e-mail informado não é válido.',
        'weak-password': 'Escolha uma senha com pelo menos 6 caracteres.',
        'network-request-failed': 'Confira sua conexão com a internet.',
        'too-many-requests':
            'Muitas tentativas. Aguarde um pouco e tente de novo.',
        'operation-not-allowed':
            'Ative o login por e-mail e senha no Firebase.',
      };
      if (mounted) {
        avisar(
          context,
          mensagens[erro.code] ?? 'Não foi possível entrar. Tente novamente.',
        );
      }
    } catch (_) {
      if (mounted) {
        avisar(context, 'Não foi possível concluir o acesso. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: FutureBuilder<void>(
        future: _preferencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: AutofillGroup(
                  child: Form(
                    key: _formulario,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.forum_outlined,
                            size: 48,
                            color: verde,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Mural IFF',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: verde,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sua dúvida pode ajudar mais alguém.',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          _cadastro
                              ? 'Crie sua conta'
                              : 'Vamos estudar juntos?',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        if (_cadastro) ...[
                          TextFormField(
                            controller: _nome,
                            enabled: !_carregando,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Seu nome',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            autofillHints: const [AutofillHints.name],
                            validator: (v) => validarTexto(v, 'Nome', 2, 60),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(
                          controller: _email,
                          enabled: !_carregando,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          autofillHints: const [AutofillHints.email],
                          autocorrect: false,
                          validator: validarEmail,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _senha,
                          enabled: !_carregando,
                          obscureText: _ocultar,
                          autofillHints: [
                            _cadastro
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _ocultar
                                  ? 'Mostrar senha'
                                  : 'Ocultar senha',
                              onPressed: () =>
                                  setState(() => _ocultar = !_ocultar),
                              icon: Icon(
                                _ocultar
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (v) =>
                              validarSenha(v, cadastro: _cadastro),
                          onFieldSubmitted: (_) {
                            if (!_carregando) _entrar();
                          },
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Lembrar meu e-mail'),
                          value: _lembrar,
                          onChanged: _carregando
                              ? null
                              : (v) => setState(() => _lembrar = v!),
                        ),
                        FilledButton(
                          onPressed: _carregando ? null : _entrar,
                          child: Text(
                            _carregando
                                ? 'Aguarde...'
                                : (_cadastro
                                      ? 'Criar conta'
                                      : 'Entrar no mural'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _carregando
                              ? null
                              : () => setState(() {
                                  _cadastro = !_cadastro;
                                  _formulario.currentState?.reset();
                                  _senha.clear();
                                }),
                          child: Text(
                            _cadastro
                                ? 'Já tenho conta. Entrar'
                                : 'Ainda não tenho conta. Cadastrar',
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Projeto estudantil • IFF Itaperuna',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
