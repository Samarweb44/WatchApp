// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/app_state.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/widgets/product_card.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final wishlist = context.watch<AppState>().wishlist;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Wishlist'),
//       ),
//       body: wishlist.isEmpty
//           ? const Center(
//               child: Text('Your wishlist is empty'),
//             )
//           : GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: wishlist.length,
//               itemBuilder: (context, index) {
//                 return ProductCard(
//                   watch: wishlist[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailScreen(
//                           watch: wishlist[index],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/app_state.dart';
// import '/screens/product_detail_screen.dart';
// import '/widgets/product_card.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final wishlist = context.watch<AppState>().wishlist;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'YOUR WISHLIST',
//           style: TextStyle(
//             color: Colors.amber,
//             fontSize: 20,
//             letterSpacing: 2,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete_outline, color: Colors.amber, size: 28),
//             onPressed: () {
//               context.read<AppState>().clearWishlist();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text(
//                     'Wishlist cleared',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   backgroundColor: Colors.amber,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: wishlist.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.favorite_border, color: Colors.amber, size: 60),
//                   const SizedBox(height: 20),
//                   Text(
//                     'YOUR WISHLIST IS EMPTY',
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 18,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Start adding your favorite products',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 12,
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       'BROWSE PRODUCTS',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.75,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: wishlist.length,
//                 itemBuilder: (context, index) {
//                   final product = wishlist[index];
//                   return ProductCard(
//                     watch: product, // ✅ Now passes Watch object
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetailScreen(
//                             product: product
//                                 .toMap(), // <-- only if ProductDetailScreen expects Map
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/app_state.dart';
import '/screens/product_detail_screen.dart';
import '/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<AppState>().wishlist;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'YOUR WISHLIST',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.amber, size: 28),
            onPressed: () async {
              await context.read<AppState>().clearWishlist(); // ✅ Also clears from Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Wishlist cleared',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.amber,
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
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, color: Colors.amber, size: 60),
                  const SizedBox(height: 20),
                  Text(
                    'YOUR WISHLIST IS EMPTY',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Start adding your favorite products',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'BROWSE PRODUCTS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlist[index];
                  return ProductCard(
                    watch: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: product.toMap(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
