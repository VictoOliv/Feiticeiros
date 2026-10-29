import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  Future<void> entrarComGoogle() async {
    await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ESCOLA JUJUTSU',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Acesso restrito para feiticeiros'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: entrarComGoogle,
              child: const Text('ENTRAR COM GOOGLE'),
            ),
          ],
        ),
      ),
    );
  }
}
