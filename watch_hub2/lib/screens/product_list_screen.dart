// import 'package:flutter/material.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/widgets/product_card.dart';

// class ProductListScreen extends StatelessWidget {
//   final String? category;

//   ProductListScreen({super.key, this.category});

//   // Temporary mock data - replace with Firebase data later
//   final List<Watch> watches = [
//     Watch(
//       id: '1',
//       name: 'Chronograph Classic',
//       brand: 'TAG Heuer',
//       price: 2999.99,
//       description: 'Premium chronograph watch with leather strap',
//       images: ['https://example.com/watch1.jpg'],
//       rating: 4.5,
//       reviewCount: 128,
//       features: ['Water resistant', 'Sapphire crystal', 'Automatic movement'],
//       category: 'Luxury',
//     ),

//     // Add more watches...
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final filteredWatches = category == null
//         ? watches
//         : watches.where((watch) => watch.category == category).toList();

//     return Scaffold(
//       appBar: AppBar(title: Text(category ?? 'All Watches')),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.7,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         itemCount: filteredWatches.length,
//         itemBuilder: (context, index) {
//           return ProductCard(
//             watch: filteredWatches[index],
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       ProductDetailScreen(watch: filteredWatches[index]),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// widgets/product_card.dart

// import 'package:flutter/material.dart';
// // import '/models/watch_model.dart';
// import '/widgets/rating_bar.dart';

// class ProductCard extends StatelessWidget {
//   final Map<String, dynamic> product; // Changed from 'Watch watch'
//   final VoidCallback onTap;

//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         color: Colors.grey[900],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 1,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   product['b_img'] ?? '',
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product['b_name'] ?? '',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${product['price'] ?? ''}',
//                     style: const TextStyle(color: Colors.amber),
//                   ),
//                   const SizedBox(height: 4),
//                   const RatingBar(rating: 4.5),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/widgets/product_card.dart';

// class ProductListScreen extends StatefulWidget {
//   final String? categoryId;

//   const ProductListScreen({super.key, this.categoryId});

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Watch>> _productsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _productsFuture = _fetchProducts();
//   }

//   Future<List<Watch>> _fetchProducts() async {
//     Query query = FirebaseFirestore.instance.collection('products');

//     if (widget.categoryId != null && widget.categoryId != 'All') {
//       query = query.where('category', isEqualTo: widget.categoryId);
//     }

//     final snapshot = await query.get();
//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>? ?? {};
//       return Watch.fromMap({...data, 'id': doc.id});
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.categoryId == null
//               ? 'All Products'
//               : '${widget.categoryId} Collection',
//         ),
//       ),
//       body: FutureBuilder<List<Watch>>(
//         future: _productsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final products = snapshot.data ?? [];

//           return products.isEmpty
//               ? const Center(child: Text('No products found'))
//               : GridView.builder(
//                   padding: const EdgeInsets.all(16),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.75,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                   ),
//                   itemCount: products.length,
//                   itemBuilder: (context, index) => ProductCard(
//                     watch: products[index],
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetailScreen(
//                             product: products[index].toMap(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/widgets/product_card.dart';


// class ProductListScreen extends StatefulWidget {
//   final String? categoryId;
//   final String? categoryName;
//   // final List<Map<String, dynamic>>? products;
//    final List<Watch>? products;

//   const ProductListScreen({
//     super.key,
//     this.products, 
//     this.categoryId,
//     // this.categoryName,
//      required this.categoryName,
//   });

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Watch>> _productsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _productsFuture = _fetchProducts();
//   }

//   Future<List<Watch>> _fetchProducts() async {
//   Query query = FirebaseFirestore.instance.collection('products');

//   // Debug print to verify filtering
//   debugPrint('Filtering by category: ${widget.categoryName}');

//   if (widget.categoryName != null && widget.categoryName != 'All') {
//     query = query.where('category', isEqualTo: widget.categoryName);
//   }

//   final snapshot = await query.get();
//   debugPrint('Found ${snapshot.docs.length} products');

//    return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>? ?? {};
//       return Watch.fromMap({...data, 'id': doc.id});
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryName ?? 'All Products'),
//       ),
//       body: FutureBuilder<List<Watch>>(
//         future: _productsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final products = snapshot.data ?? [];

//           if (products.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.search_off, size: 50, color: Colors.amber),
//                   Text(
//                     'No ${widget.categoryName ?? ''} watches found',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Back to Categories'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.7,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//             ),
//             itemCount: products.length,
//             itemBuilder: (context, index) => ProductCard(
//               watch: products[index],
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailScreen(
//                       product: products[index].toMap(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/watch_model.dart';
import '/screens/product_detail_screen.dart';
import '/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryId;
  final String categoryName;
  final List<Watch>? products;

  const ProductListScreen({
    super.key,
    this.products,
    this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Watch>> _productsFuture;
  bool _isLoading = true;
  List<Watch> _products = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.products != null) {
      // Use the provided products directly (from carousel selection)
      _products = widget.products!;
      _isLoading = false;
    } else {
      // Fetch products based on category
      _fetchProducts();
    }
  }

  Future<void> _fetchProducts() async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');

      if (widget.categoryId != null && widget.categoryName != 'All') {
        query = query.where('category', isEqualTo: widget.categoryName);
      } else if (widget.categoryName == 'Featured Products') {
        query = query.where('isFeatured', isEqualTo: true);
      }

      final snapshot = await query.get();

      setState(() {
        _products = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return Watch.fromMap({...data, 'id': doc.id});
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) => ProductCard(
        watch: _products[index],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                product: _products[index].toMap(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 50, color: Colors.amber),
          Text(
            'No ${widget.categoryName.toLowerCase()} watches found',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Categories'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _products.isEmpty
                  ? _buildEmptyState()
                  : _buildProductGrid(),
    );
  }
}