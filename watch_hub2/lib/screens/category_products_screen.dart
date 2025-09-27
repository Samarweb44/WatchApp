import 'package:flutter/material.dart';
import '/models/watch_model.dart';
import '/screens/product_detail_screen.dart';
import '/widgets/product_card.dart';


class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final List<Watch> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.amber),
                  const SizedBox(height: 16),
                  Text(
                    'No products in $categoryName',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final watch = products[index];
                return ProductCard(
                  watch: watch,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: watch.toMap()),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}