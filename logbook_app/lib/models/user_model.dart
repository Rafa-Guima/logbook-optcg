class UserModel {
  final String uid;
  final String nickname;
  final String email;
  final String? avatarUrl;
  final DateTime? lastNicknameChange;
  final bool collectionPublic;
  final List<CollectionItem> collection;
  final List<WantListItem> wantlist;

  UserModel({
    required this.uid,
    required this.nickname,
    required this.email,
    this.avatarUrl,
    this.lastNicknameChange,
    this.collectionPublic = false,
    this.collection = const [],
    this.wantlist = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      lastNicknameChange: map['lastNicknameChange'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastNicknameChange'].millisecondsSinceEpoch)
          : null,
      collectionPublic: map['collectionPublic'] ?? false,
      collection: List<CollectionItem>.from(
        (map['collection'] ?? []).map((x) => CollectionItem.fromMap(x)),
      ),
      wantlist: List<WantListItem>.from(
        (map['wantlist'] ?? []).map((x) => WantListItem.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'avatarUrl': avatarUrl,
      'lastNicknameChange': lastNicknameChange,
      'collectionPublic': collectionPublic,
      'collection': collection.map((x) => x.toMap()).toList(),
      'wantlist': wantlist.map((x) => x.toMap()).toList(),
    };
  }
}

class CollectionItem {
  final String cardId;
  final int quantity;

  CollectionItem({
    required this.cardId,
    required this.quantity,
  });

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return CollectionItem(
      cardId: map['cardId'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'quantity': quantity,
    };
  }
}

class WantListItem {
  final String cardId;
  final int desiredQuantity;
  final bool alertActive;
  final double lastKnownMinPrice;

  WantListItem({
    required this.cardId,
    required this.desiredQuantity,
    this.alertActive = false,
    this.lastKnownMinPrice = 0.0,
  });

  factory WantListItem.fromMap(Map<String, dynamic> map) {
    return WantListItem(
      cardId: map['cardId'] ?? '',
      desiredQuantity: map['desiredQuantity']?.toInt() ?? 0,
      alertActive: map['alertActive'] ?? false,
      lastKnownMinPrice: map['lastKnownMinPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'desiredQuantity': desiredQuantity,
      'alertActive': alertActive,
      'lastKnownMinPrice': lastKnownMinPrice,
    };
  }
}
