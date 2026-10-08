import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'componentes.dart';
import 'telas/login.dart';
import 'telas/mural.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MuralApp());
  } catch (_) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: MensagemVazia(
                icone: Icons.settings_outlined,
                titulo: 'Conexão ainda não configurada',
                texto: 'Configure o Firebase deste projeto e abra o aplicativo novamente. Consulte o README.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MuralApp extends StatelessWidget {
  const MuralApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mural IFF',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: verde),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F9F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F9F7),
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    // A tela acompanha a sessão do Firebase sem gerenciador de estado externo.
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == null ? const TelaLogin() : const TelaMural();
      },
    ),
  );
}
