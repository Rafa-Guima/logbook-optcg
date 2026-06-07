import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../../models/card_model.dart'; // Ajuste o caminho se necessário

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Coleção')),
      body: userId == null 
          ? const Center(child: Text("Faça login para ver sua coleção"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users').doc(userId).collection('collection').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final docs = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final cardId = docs[index].id;
                    final quantity = data['quantity'] ?? 1;

                    // Aqui buscamos os detalhes da carta direto no GridView
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('cards').doc(cardId).get(),
                      builder: (context, cardSnapshot) {
                        if (!cardSnapshot.hasData) return Container(color: Colors.grey[800]);
                        
                        final cardData = cardSnapshot.data!.data() as Map<String, dynamic>;
                        final card = CardModel.fromMap(cardData, cardId);

                        return GestureDetector(
                          onTap: () => context.push('/card_detail', extra: card),
                          child: Stack(
                            children: [
                              Image.network(cardData['imageUrl'], fit: BoxFit.cover),
                              Positioned(
                                bottom: 4, right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: Text('x$quantity', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                            onLongPress: () {
                            // Lógica para remover ou decrementar
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remover da coleção?'),
                                content: const Text('Deseja remover esta carta da sua coleção?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection('users')
                                          .doc(userId).collection('collection').doc(cardId).delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Remover', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}