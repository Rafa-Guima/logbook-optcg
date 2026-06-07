import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/../models/card_model.dart'; // Ajuste o caminho se necessário
import '/../widgets/card_item_widget.dart'; // Ajuste o caminho se necessário

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  bool _showFilters = false;
  String _searchQuery = '';
  final Set<String> _selectedColors = {};
  final Set<String> _selectedRarities = {};
  double _priceMax = 500.0;

  final Map<String, Color> _colorMap = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Purple': Colors.purple,
    'Black': Colors.black,
    'Yellow': Colors.yellow,
  };

  // Adicionado o 'L' para Leader
  final List<String> _rarities = ['L', 'C', 'UC', 'R', 'SR', 'SEC'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Cartas'),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_alt_off : Icons.filter_alt),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nome da carta (Ex: Luffy)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          
          // Menu de Filtros Animado
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _showFilters
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cor', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: _colorMap.entries.map((entry) {
                            final isSelected = _selectedColors.contains(entry.key);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedColors.remove(entry.key);
                                  } else {
                                    _selectedColors.add(entry.key);
                                  }
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isSelected
                                      ? [const BoxShadow(color: Colors.white54, blurRadius: 4)]
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Raridade', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _rarities.map((rarity) {
                            final isSelected = _selectedRarities.contains(rarity);
                            return FilterChip(
                              label: Text(rarity),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedRarities.add(rarity);
                                  } else {
                                    _selectedRarities.remove(rarity);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Text('Preço Máximo: R\$ ${_priceMax.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          value: _priceMax,
                          min: 0,
                          max: 500,
                          divisions: 50,
                          label: 'R\$ ${_priceMax.toStringAsFixed(0)}',
                          onChanged: (value) {
                            setState(() {
                              _priceMax = value;
                            });
                          },
                        ),
                        const Divider(height: 32),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          // Lista de Cartas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cards').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma carta encontrada.'));
                }

                final cards = snapshot.data!.docs.map((doc) {
                  return CardModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).where((card) {
                  
                  // 1. Filtro de Nome
                  if (_searchQuery.isNotEmpty &&
                      !card.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
                    return false;
                  }
                  
                  // 2. Filtro de Cor (Nova lógica corrigida)
                  if (_selectedColors.isNotEmpty) {
                    bool hasMatchingColor = false;
                    for (String selectedColor in _selectedColors) {
                      // Verifica se a string da cor da carta contém a cor selecionada (ex: "Red/Green" contém "Red")
                      if (card.color.any((c) => c.toLowerCase().contains(selectedColor.toLowerCase()))) {
                        hasMatchingColor = true;
                        break;
                      }
                    }
                    if (!hasMatchingColor) return false;
                  }
                  
                  // 3. Filtro de Raridade (Flexível para pegar variações como "Leader")
                  if (_selectedRarities.isNotEmpty) {
                    bool hasMatchingRarity = false;
                    for (String selectedRarity in _selectedRarities) {
                      if (card.rarity.toUpperCase().contains(selectedRarity.toUpperCase())) {
                        hasMatchingRarity = true;
                        break;
                      }
                    }
                    if (!hasMatchingRarity) return false;
                  }
                  
                  // 4. Filtro de Preço
                  if (card.priceMid > _priceMax) {
                    return false;
                  }
                  
                  return true;
                }).toList();

                if (cards.isEmpty) {
                  return const Center(child: Text('Nenhuma carta corresponde aos filtros.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return GestureDetector(
                      onTap: () => context.push('/card_detail', extra: card),
                      child: CardItemWidget(card: card),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}