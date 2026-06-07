import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../../models/card_model.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  final CardModel card;

  const CardDetailScreen({Key? key, required this.card}) : super(key: key);

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  User? get user => FirebaseAuth.instance.currentUser;
  bool _isWishlist = false;

  @override
  void initState() {
    super.initState();
    _registrarVisualizacao();
    _checkWishlistStatus();
  }

  Future<void> _checkWishlistStatus() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid)
        .collection('wishlist').doc(widget.card.cardId).get();
    if (mounted) setState(() => _isWishlist = doc.exists);
  }

  Future<void> _addToCollection() async {
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('collection').doc(widget.card.cardId);
    
    final doc = await docRef.get();
    if (doc.exists) {
      docRef.update({'quantity': FieldValue.increment(1)});
    } else {
      docRef.set({'quantity': 1, 'addedAt': FieldValue.serverTimestamp()});
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Adicionado à coleção!")));
  }

  Future<void> _toggleWishlist() async {
    if (user == null) return;
    
    // O nome da coleção deve ser idêntico ao que a tela de WantList lê
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('wantList') // Corrigido para 'wantList'
        .doc(widget.card.cardId);
    
    if (_isWishlist) {
      await docRef.delete();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Removido da lista de desejos")));
    } else {
      // Adicionamos com 'quantity: 1' para ser compatível com a lógica da sua tela de WantList
      await docRef.set({
        'addedAt': FieldValue.serverTimestamp(),
        'quantity': 1 
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Adicionado à lista de desejos!")));
    }
    setState(() => _isWishlist = !_isWishlist);
  }

  Future<void> _registrarVisualizacao() async {
    if (user == null) return;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final doc = await userRef.get();
    List<String> recentes = [];
    if (doc.exists && doc.data() != null && doc.data()!.containsKey('recentlyViewed')) {
      recentes = List<String>.from(doc.data()!['recentlyViewed']);
    }
    recentes.remove(widget.card.cardId);
    recentes.insert(0, widget.card.cardId);
    if (recentes.length > 5) recentes = recentes.sublist(0, 5);
    userRef.set({'recentlyViewed': recentes}, SetOptions(merge: true));
  }

  Future<void> _launchLigaUrl() async {
    final Uri url = Uri.parse(widget.card.ligaUrl);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.name),
        actions: [
          IconButton(
            icon: Icon(_isWishlist ? Icons.favorite : Icons.favorite_border, color: _isWishlist ? Colors.red : null),
            onPressed: _toggleWishlist,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _addToCollection,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(widget.card.imageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            Text(widget.card.name, style: Theme.of(context).textTheme.headlineSmall),
            Text('${widget.card.set} • ${widget.card.rarity} • ${widget.card.color.join(", ")}', 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPriceColumn('Mínimo', 'R\$ ${widget.card.priceMin.toStringAsFixed(2)}', AppColors.success),
                    _buildPriceColumn('Médio', 'R\$ ${widget.card.priceMid.toStringAsFixed(2)}', AppColors.warning),
                    _buildPriceColumn('Máximo', 'R\$ ${widget.card.priceMax.toStringAsFixed(2)}', AppColors.error),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _launchLigaUrl,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Ver Fonte Oficial'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}