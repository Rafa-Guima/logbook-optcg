import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../core/constants/app_colors.dart'; // Importando suas constantes

class CardItemWidget extends StatelessWidget {
  final CardModel card;

  const CardItemWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.borderRadiusCard),
              ),
              child: Image.network(
                card.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image, size: 50));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingBase * 2), // Usando spacingBase
            child: Column(
              children: [
                Text(
                  card.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${card.cardNumber} | ${card.rarity}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${card.priceMin.toStringAsFixed(2)} - R\$ ${card.priceMax.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}