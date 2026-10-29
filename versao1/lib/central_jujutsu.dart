import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CentralJujutsu extends StatefulWidget {
  const CentralJujutsu({super.key});

  @override
  State<CentralJujutsu> createState() => _CentralJujutsuState();
}

class _CentralJujutsuState extends State<CentralJujutsu> {
  final usuario = FirebaseAuth.instance.currentUser!;
  final missoes = FirebaseFirestore.instance.collection('missoes_feiticeiros');
  final controleTitulo = TextEditingController();
  int grau = 1;

  Future<void> cadastrarMissao() async {
    final titulo = controleTitulo.text.trim();
    if (titulo.isEmpty) return;
    await missoes.add({
      'titulo': titulo,
      'grau': grau,
      'concluida': false,
      'usuarioId': FirebaseAuth.instance.currentUser!.uid,
    });
    controleTitulo.clear();
  }

  @override
  void dispose() {
    controleTitulo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Jujutsu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: usuario.photoURL != null ? NetworkImage(usuario.photoURL!) : null,
              child: usuario.photoURL == null ? const Icon(Icons.person, size: 40) : null,
            ),
            const SizedBox(height: 8),
            const Text('Bem-vindo,'),
            Text(
              usuario.displayName ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(usuario.email ?? ''),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controleTitulo,
                    decoration: const InputDecoration(labelText: 'Título da missão'),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: grau,
                  items: [1, 2, 3, 4]
                      .map((valor) => DropdownMenuItem(value: valor, child: Text('Grau $valor')))
                      .toList(),
                  onChanged: (valor) => setState(() => grau = valor!),
                ),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: cadastrarMissao, child: const Text('Cadastrar')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: missoes.where('usuarioId', isEqualTo: usuario.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final documentos = snapshot.data!.docs;
                  if (documentos.isEmpty) {
                    return const Center(child: Text('Nenhuma missão cadastrada.'));
                  }
                  return ListView.builder(
                    itemCount: documentos.length,
                    itemBuilder: (context, indice) {
                      final documento = documentos[indice];
                      final dados = documento.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: Checkbox(
                          value: dados['concluida'],
                          onChanged: (valor) => documento.reference.update({'concluida': valor}),
                        ),
                        title: Text(dados['titulo']),
                        subtitle: Text('Grau ${dados['grau']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => documento.reference.delete(),
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
    );
  }
}
