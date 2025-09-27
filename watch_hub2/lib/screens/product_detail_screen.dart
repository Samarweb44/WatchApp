// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/models/app_state.dart';
// // import '/providers/cart_provider.dart';
// import '/widgets/rating_bar.dart';
// import '/widgets/add_to_cart_button.dart';
// import '/screens/cart_screen.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Watch watch;

//   const ProductDetailScreen({super.key, required this.watch});

//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     final isInWishlist = appState.isInWishlist(watch);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 350,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 children: [
//                   Image.network(
//                     watch.images[0],
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                       Center(child: Icon(Icons.watch, size: 100, color: Colors.yellow[600])),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       // gradient: LinearGradient(
//                       //   begin: Alignment.bottomCenter,
//                       //   end: Alignment.topCenter,
//                       //   colors: [
//                       //     Colors.black.withOpacity(0.9),
//                       //     Colors.transparent,
//                       //   ],
//                       // ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             pinned: true,
//             backgroundColor: const Color.fromARGB(255, 80, 80, 80),
//             iconTheme: const IconThemeData(color: Colors.white),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   isInWishlist ? Icons.favorite : Icons.favorite_border,
//                   color: isInWishlist ? Colors.red : Colors.yellow[600],
//                   size: 28,
//                 ),
//                 onPressed: () {
//                   appState.toggleWishlist(watch);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         isInWishlist ? 'Removed from wishlist' : 'Added to wishlist',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       duration: const Duration(seconds: 1),
//                       backgroundColor: const Color.fromARGB(255, 105, 86, 2),
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Brand and Name
//                   Text(
//                     watch.brand.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.yellow[600],
//                       letterSpacing: 2,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     watch.name,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       height: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Rating and Price
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           RatingBar(rating: watch.rating),
//                           const SizedBox(width: 10),
//                           Text(
//                             '${watch.rating} (${watch.reviewCount})',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[400],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         '\$${watch.price.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.yellow[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),

//                   // Description
//                   Text(
//                     'DESCRIPTION',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.yellow[600],
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     watch.description,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[300],
//                       height: 1.6,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Features
//                   Text(
//                     'FEATURES',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.yellow[600],
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: watch.features.map((feature) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.check_circle,
//                             color: Colors.yellow[600],
//                             size: 20,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               feature,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[300],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )).toList(),
//                   ),
//                   const SizedBox(height: 20),

//                   // Additional Images
//                   if (watch.images.length > 1) ...[
//                     Text(
//                       'GALLERY',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.yellow[600],
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       height: 120,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: watch.images.length,
//                         itemBuilder: (context, index) => Container(
//                           width: 160,
//                           margin: const EdgeInsets.only(right: 15),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             image: DecorationImage(
//                               image: NetworkImage(watch.images[index]),
//                               fit: BoxFit.cover,
//                             ),
//                             border: Border.all(
//                               color: Colors.yellow[600]!.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.black,
//           border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Row(
//           children: [
//             // Cart Icon
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.yellow[600]!, width: 1.5),
//               ),
//               child: IconButton(
//                 icon: Icon(Icons.shopping_cart, color: Colors.yellow[600]),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const CartScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 15),

//             // Add to Cart Button
//             Expanded(
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.yellow[600],
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: AddToCartButton(
//                   watchId: watch.id,
//                   name: watch.name,
//                   price: watch.price,
//                   imageUrl: watch.images.isNotEmpty ? watch.images[0] : '',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/models/app_state.dart';
// // import '/providers/cart_provider.dart';
// import '/widgets/rating_bar.dart';
// import '/widgets/add_to_cart_button.dart';
// import '/screens/cart_screen.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     // final appState = Provider.of<AppState>(context);
//     // final isInWishlist = appState.isInWishlist(product);
//     final appState = Provider.of<AppState>(context);
//     final watch = Watch.fromMap(product);
//     final isInWishlist = appState.isInWishlist(watch);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 350,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     product['b_img'] ?? '',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => const Center(
//                       child: Icon(
//                         Icons.broken_image,
//                         size: 100,
//                         color: Colors.amber,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           // Colors.black.withOpacity(0.9),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             pinned: true,
//             backgroundColor: Colors.grey[900],
//             iconTheme: const IconThemeData(color: Colors.white),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   isInWishlist ? Icons.favorite : Icons.favorite_border,
//                   color: isInWishlist ? Colors.red : Colors.amber,
//                   size: 28,
//                 ),
//                 onPressed: () {
//                   // appState.toggleWishlist(product);
//                   appState.toggleWishlist(Watch.fromMap(product));
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         !isInWishlist
//                             ? 'Added to wishlist'
//                             : 'Removed from wishlist',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       duration: const Duration(seconds: 1),
//                       backgroundColor: Colors.amber[800],
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     (product['b_name'] ?? '').toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.amber,
//                       letterSpacing: 2,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     product['b_name'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       height: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           const RatingBar(rating: 4.5),
//                           const SizedBox(width: 10),
//                           Text(
//                             '4.5 (42)',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[400],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         '\$${product['price'] ?? '0'}',
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.amber,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'DESCRIPTION',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.amber,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     product['b_desc'] ?? '',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[300],
//                       height: 1.6,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'FEATURES',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.amber,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildFeatureItem('High-quality materials'),
//                       _buildFeatureItem('Premium craftsmanship'),
//                       _buildFeatureItem('Durable construction'),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'GALLERY',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.amber,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 3,
//                       itemBuilder: (context, index) => Container(
//                         width: 160,
//                         margin: const EdgeInsets.only(right: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           image: DecorationImage(
//                             image: NetworkImage(product['b_img'] ?? ''),
//                             fit: BoxFit.cover,
//                           ),
//                           border: Border.all(
//                             color: Colors.amber.withOpacity(0.3),
//                             width: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.black,
//           border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.amber, width: 1.5),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.shopping_cart, color: Colors.amber),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: AddToCartButton(
//                   watchId: product['id'] ?? '',
//                   name: product['b_name'] ?? '',
//                   price: (product['price'] ?? 0).toDouble(),
//                   imageUrl: product['b_img'] ?? '',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureItem(String feature) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.check_circle, color: Colors.amber, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               feature,
//               style: TextStyle(fontSize: 16, color: Colors.grey[300]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/watch_model.dart';
import '/models/app_state.dart';
import '/widgets/rating_bar.dart';
import '/widgets/add_to_cart_button.dart';
import '/screens/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final watch = Watch.fromMap(product);
    final appState = Provider.of<AppState>(context);
    final isInWishlist = appState.isInWishlist(watch);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    watch.displayImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.amber,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(
                          Icons.watch,
                          size: 100,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            backgroundColor: Colors.grey[900],
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : Colors.amber,
                  size: 28,
                ),
                onPressed: () {
                  appState.toggleWishlist(watch);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isInWishlist
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.amber[800],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    watch.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    watch.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingBar(rating: watch.rating),
                          const SizedBox(width: 10),
                          Text(
                            '${watch.rating.toStringAsFixed(1)} (${watch.reviewCount})',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        watch.formattedPrice,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    watch.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (watch.features.isNotEmpty) ...[
                    const Text(
                      'FEATURES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: watch.features
                          .map((feature) => _buildFeatureItem(feature))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                  if (watch.allImages.length > 1) ...[
                    const Text(
                      'GALLERY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: watch.allImages.length,
                        itemBuilder: (context, index) => Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(watch.allImages[index]),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.amber),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: SizedBox(
                height: 50,
                 child: AddToCartButton(
                  watchId: product['id'] ?? '',
                  name: product['b_name'] ?? '',
                  price: (product['price'] ?? 0).toDouble(),
                  imageUrl: product['b_img'] ?? '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
