import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

class AddToCartButton extends StatelessWidget {
  final String watchId;
  final String name;
  final double price;
  final String imageUrl;

  const AddToCartButton({
    super.key,
    required this.watchId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Provider.of<CartProvider>(context, listen: false).addItem(
          watchId,
          name,
          price,
          imageUrl,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $name to cart!'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeSingleItem(watchId);
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.shopping_cart),
      label: const Text('ADD TO CART'),
    );
  }
}