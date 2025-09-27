import 'package:flutter/material.dart';

class CartItemModel {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
    required this.imageUrl,
  });
}

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.watch)),
        title: Text(title),
        subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
        trailing: Text('x$quantity'),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double iconSize;

  const RatingBar({super.key, required this.rating, this.maxRating = 5, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating.round()
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: iconSize,
        );
      }),
    );
  }
}
