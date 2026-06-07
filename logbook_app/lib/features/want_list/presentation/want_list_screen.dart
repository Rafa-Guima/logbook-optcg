import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../../models/card_model.dart';

class WantListScreen extends ConsumerStatefulWidget {
  const WantListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WantListScreen> createState() => _WantListScreenState();
}

class _WantListScreenState extends ConsumerState<WantListScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _sortDescending = true;
  
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _updateQuantity(String cardId, int currentQuantity, int change) async {
    final newQuantity = currentQuantity + change;
    
    if (newQuantity <= 0) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('wantList').doc(cardId).delete();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carta removida da lista')));
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('wantList').doc(cardId).update({'quantity': newQuantity});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Want List')),
        body: const Center(child: Text("Faça login para ver sua Want List")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar carta...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              )
            : const Text('Want List'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: Icon(_sortDescending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () => setState(() => _sortDescending = !_sortDescending),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('wantList')
            .orderBy('addedAt', descending: _sortDescending)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final wantListDocs = snapshot.data!.docs;
          
          if (wantListDocs.isEmpty) {
            return const Center(child: Text('Sua Want List está vazia.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${wantListDocs.length} cartas', style: const TextStyle(color: Colors.grey)),
                    const Text('Valor Total: R\$ --', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: wantListDocs.length,
                  itemBuilder: (context, index) {
                    final wantListData = wantListDocs[index].data() as Map<String, dynamic>;
                    final cardId = wantListDocs[index].id;
                    final quantity = wantListData['quantity'] ?? 1;
                    final targetPrice = wantListData['targetPrice']?.toDouble() ?? 0.0;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('cards').doc(cardId).get(),
                      builder: (context, cardSnapshot) {
                        if (!cardSnapshot.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                        if (!cardSnapshot.data!.exists) return const SizedBox();

                        final cardData = cardSnapshot.data!.data() as Map<String, dynamic>;
                        final card = CardModel.fromMap(cardData, cardId);

                        if (_searchQuery.isNotEmpty && !card.name.toLowerCase().contains(_searchQuery)) {
                          return const SizedBox();
                        }

                        final bool isAlertTriggered = targetPrice > 0 && card.priceMid <= targetPrice;

                        return GestureDetector(
                          onTap: () => context.push('/card_detail', extra: card),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A), // surface-container-low do design
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          card.imageUrl,
                                          width: 80,
                                          height: 112,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80, height: 112, color: Colors.grey[800],
                                            child: const Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              card.name,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${card.set} • ${card.cardNumber}',
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Text(
                                                  'R\$ ${card.priceMid.toStringAsFixed(2)}',
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                                ),
                                                const SizedBox(width: 8),
                                                if (targetPrice > 0)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFD5E3FF),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.track_changes, size: 14, color: Color(0xFF001B3C)),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          'Alvo: R\$ ${targetPrice.toStringAsFixed(2)}',
                                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF001B3C)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                                                  onPressed: () => _updateQuantity(cardId, quantity, -1),
                                                  constraints: const BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                                                  onPressed: () => _updateQuantity(cardId, quantity, 1),
                                                  constraints: const BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isAlertTriggered)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(12)),
                                      ),
                                      child: const Text('QUEDA DE PREÇO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push('/search'); 
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}