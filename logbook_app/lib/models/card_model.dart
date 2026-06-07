class CardModel {
  final String cardId; // e.g. OP01-001
  final String name;
  final String set;
  final List<String> color;
  final String rarity;
  final String cardNumber;
  final String imageUrl;
  final String? aaImageUrl;
  final double priceMin;
  final double priceMid;
  final double priceMax;
  final String ligaUrl;
  final DateTime? lastUpdated;

  CardModel({
    required this.cardId,
    required this.name,
    required this.set,
    required this.color,
    required this.rarity,
    required this.cardNumber,
    required this.imageUrl,
    this.aaImageUrl,
    this.priceMin = 0.0,
    this.priceMid = 0.0,
    this.priceMax = 0.0,
    required this.ligaUrl,
    this.lastUpdated,
  });

  factory CardModel.fromMap(Map<String, dynamic> map, String documentId) {
  return CardModel(
    cardId: documentId,
    name: map['name'] ?? '',
    set: map['set'] ?? '',
    color: List<String>.from(map['color'] ?? []),
    rarity: map['rarity'] ?? '',
    cardNumber: map['cardNumber'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
    priceMin: (map['priceMin'] as num?)?.toDouble() ?? 0.0,
    priceMid: (map['priceMid'] as num?)?.toDouble() ?? 0.0,
    priceMax: (map['priceMax'] as num?)?.toDouble() ?? 0.0,
    ligaUrl: map['ligaUrl'] ?? '',
  );
}

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'set': set,
      'color': color,
      'rarity': rarity,
      'cardNumber': cardNumber,
      'imageUrl': imageUrl,
      'aaImageUrl': aaImageUrl,
      'priceMin': priceMin,
      'priceMid': priceMid,
      'priceMax': priceMax,
      'ligaUrl': ligaUrl,
      'lastUpdated': lastUpdated,
    };
  }
}
