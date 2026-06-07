import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../../models/card_model.dart'; 

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('LogBook', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const MainDrawer(),
      
      // 1º Stream: Fica ouvindo o documento do usuário para saber as cartas recentes
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, userSnapshot) {
          
          List<String> recentIds = [];
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            final data = userSnapshot.data!.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('recentlyViewed')) {
              recentIds = List<String>.from(data['recentlyViewed']);
            }
          }

          // 2º Stream: Busca as cartas no banco de dados
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cards').snapshots(),
            builder: (context, cardsSnapshot) {
              if (cardsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!cardsSnapshot.hasData || cardsSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhuma carta no banco de dados.'));
              }

              // Converte tudo para a sua model
              final allCards = cardsSnapshot.data!.docs.map((doc) {
                return CardModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              }).toList();

              // Filtra as Vistas Recentemente mantendo a ordem correta (FIFO)
              List<CardModel> recentCards = [];
              for (String id in recentIds) {
                try {
                  recentCards.add(allCards.firstWhere((c) => c.cardId == id));
                } catch (e) {
                  // Se a carta foi deletada do banco, ignora
                }
              }

              // Organiza "Em Alta" (Maiores Preços)
              List<CardModel> sortedByPriceDesc = List.from(allCards)..sort((a, b) => b.priceMid.compareTo(a.priceMid));
              final trendingUp = sortedByPriceDesc.take(3).toList();

              // Organiza "Em Baixa" (Menores Preços)
              List<CardModel> sortedByPriceAsc = List.from(allCards)..sort((a, b) => a.priceMid.compareTo(b.priceMid));
              final trendingDown = sortedByPriceAsc.take(3).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carousel: last 5 cards viewed
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Vistos Recentemente', style: Theme.of(context).textTheme.titleLarge),
                    ),
                    if (recentCards.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Você ainda não visualizou nenhuma carta.', style: TextStyle(color: AppColors.textSecondary)),
                      )
                    else
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recentCards.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final card = recentCards[index];
                            return GestureDetector(
                              onTap: () => context.push('/card_detail', extra: card),
                              child: Card(
                                margin: const EdgeInsets.only(right: 16),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  width: 140,
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    card.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // Em Alta hoje
                    if (trendingUp.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text('Em Alta hoje 🔺', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trendingUp.length,
                        itemBuilder: (context, index) {
                          final card = trendingUp[index];
                          return ListTile(
                            leading: Image.network(card.imageUrl, width: 40, height: 60, fit: BoxFit.contain),
                            title: Text(card.name),
                            subtitle: Text('R\$ ${card.priceMid.toStringAsFixed(2)}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                              child: const Text('+15%', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                            ),
                            onTap: () => context.push('/card_detail', extra: card),
                          );
                        },
                      ),
                    ],

                    // Em Baixa hoje
                    if (trendingDown.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text('Em Baixa hoje 🔻', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trendingDown.length,
                        itemBuilder: (context, index) {
                          final card = trendingDown[index];
                          return ListTile(
                            leading: Image.network(card.imageUrl, width: 40, height: 60, fit: BoxFit.contain),
                            title: Text(card.name),
                            subtitle: Text('R\$ ${card.priceMid.toStringAsFixed(2)}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                              child: const Text('-10%', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                            ),
                            onTap: () => context.push('/card_detail', extra: card),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ... MainDrawer continua idêntico ao que você mandou (pode colar ele aqui embaixo) ...

class MainDrawer extends ConsumerWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: AppColors.surfaceDark, 
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.backgroundDark),
            child: Row(
              children: [
                const CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.displayName ?? 'Jogador', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? 'Sem e-mail', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search, color: AppColors.textDark),
            title: const Text('Buscar Cartas', style: TextStyle(color: AppColors.textDark)),
            onTap: () {
              Navigator.pop(context);
              context.push('/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner, color: AppColors.textDark),
            title: const Text('Scanner', style: TextStyle(color: AppColors.textDark)),
            onTap: () {
              Navigator.pop(context);
              context.push('/scanner');
            },
          ),
          ListTile(
            leading: const Icon(Icons.collections_bookmark, color: AppColors.textDark),
            title: const Text('Minha Coleção', style: TextStyle(color: AppColors.textDark)),
            onTap: () {
              Navigator.pop(context);
              context.push('/collection');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: AppColors.textDark),
            title: const Text('Want List', style: TextStyle(color: AppColors.textDark)),
            onTap: () {
              Navigator.pop(context);
              context.push('/want_list');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.textDark),
            title: const Text('Configurações', style: TextStyle(color: AppColors.textDark)),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          const Divider(color: AppColors.textSecondary),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: AppColors.error),
            title: const Text('Sair', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              Navigator.pop(context); // Fecha o menu lateral
              await ref.read(authNotifierProvider.notifier).logout(); // Faz o logout no Firebase
              if (context.mounted) {
                context.go('/login'); // Redireciona para o ecrã de login
              }
            },
          ),
        ],
      ),
    );
  }
}