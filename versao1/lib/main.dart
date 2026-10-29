import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'central_jujutsu.dart';
import 'firebase_options.dart';
import 'tela_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppJujutsu());
}

class AppJujutsu extends StatelessWidget {
  const AppJujutsu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escola Jujutsu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data == null) {
            return const TelaLogin();
          }
          return const CentralJujutsu();
        },
      ),
    );
  }
}
