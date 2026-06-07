import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/card_model.dart';

class CardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Busca uma carta pelo nome no Firestore
  Future<CardModel?> fetchCardByName(String name) async {
    try {
      final query = await _firestore.collection('cards')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // Usa o seu CardModel.fromMap para converter o documento do Firebase
        return CardModel.fromMap(query.docs.first.data(), query.docs.first.id);
      }
    } catch (e) {
      print("Erro ao buscar no Firebase: $e");
    }
    return null;
  }
}