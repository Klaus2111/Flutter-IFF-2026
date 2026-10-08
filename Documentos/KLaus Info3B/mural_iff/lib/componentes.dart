import 'package:flutter/material.dart';

const verde = Color(0xFF176442);

class ConteudoCentral extends StatelessWidget {
  final Widget child;
  final double largura;
  const ConteudoCentral({super.key, required this.child, this.largura = 860});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: largura),
      child: child,
    ),
  );
}

class Etiqueta extends StatelessWidget {
  final String texto;
  final bool destaque;
  const Etiqueta(this.texto, {super.key, this.destaque = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: destaque ? const Color(0xFFDDEFE5) : const Color(0xFFF0F2F1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      texto,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: destaque ? verde : const Color(0xFF53615A),
      ),
    ),
  );
}

void avisar(BuildContext context, String texto) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));

class MensagemVazia extends StatelessWidget {
  final IconData icone;
  final String titulo, texto;
  const MensagemVazia({
    super.key,
    required this.icone,
    required this.titulo,
    required this.texto,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 48, color: verde),
        const SizedBox(height: 16),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(texto, textAlign: TextAlign.center),
      ],
    ),
  );
}
