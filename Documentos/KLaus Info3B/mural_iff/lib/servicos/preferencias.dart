import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  // Somente o e-mail e a preferência são guardados. Nunca salvamos a senha.
  static Future<String> lerEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('lembrarEmail') ?? false)
        ? (prefs.getString('email') ?? '')
        : '';
  }

  static Future<void> salvarEmail(String email, bool lembrar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lembrarEmail', lembrar);
    if (lembrar) {
      await prefs.setString('email', email.trim());
    } else {
      await prefs.remove('email');
    }
  }
}
