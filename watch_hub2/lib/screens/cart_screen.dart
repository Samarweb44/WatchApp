// // lib/screens/cart_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/providers/cart_provider.dart';
// import '/widgets/cart_item.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//     final cartItems = cart.items;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Cart'),
//       ),
//       body: Column(
//         children: [
//           Card(
//             margin: const EdgeInsets.all(15),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const Spacer(),
//                   Chip(
//                     label: Text(
//                       '\$${cart.totalAmount.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryTextTheme.titleLarge?.color,
//                       ),
//                     ),
//                     backgroundColor: Theme.of(context).primaryColor,
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Implement checkout
//                     },
//                     child: Text(
//                       'CHECKOUT',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (ctx, i) => CartItemWidget(
//                 id: cartItems[i].id,
//                 watchId: cartItems[i].watchId,
//                 price: cartItems[i].price,
//                 quantity: cartItems[i].quantity,
//                 title: cartItems[i].name,
//                 imageUrl: cartItems[i].imageUrl,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/providers/cart_provider.dart';
// import '/widgets/cart_item.dart';
// import '/models/app_state.dart';
// import '/screens/checkout_screen.dart';


// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//     final cartItems = cart.items;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text(
//           'YOUR CART',
//           style: TextStyle(
//             color: Colors.white,
//             letterSpacing: 2.0,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           // Total and Checkout Card
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[800]!),
//             ),
//             child: Row(
//               children: [
//                 const Text(
//                   'TOTAL',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 const Spacer(),
//                 Chip(
//                   label: Text(
//                     '\$${cart.totalAmount.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   backgroundColor: Colors.amber,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     // Implement checkout
//                 //   },
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor: Colors.amber,
//                 //     foregroundColor: Colors.black,
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(20),
//                 //     ),
//                 //     padding: const EdgeInsets.symmetric(
//                 //       horizontal: 24,
//                 //       vertical: 12,
//                 //     ),
//                 //   ),
//                 //   child: const Text(
//                 //     'CHECKOUT',
//                 //     style: TextStyle(
//                 //       fontWeight: FontWeight.bold,
//                 //       letterSpacing: 1,
//                 //     ),
//                 //   ),
//                 // ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final isLoggedIn = Provider.of<AppState>(
//                       context,
//                       listen: false,
//                     ).isLoggedIn;
//                     if (isLoggedIn) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CheckoutScreen(),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please login to checkout'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       Navigator.pushNamed(context, '/auth');
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber,
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: const Text(
//                     'CHECKOUT',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Cart Items List
//           Expanded(
//             child: cartItems.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.shopping_cart_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Your cart is empty',
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Explore our collection',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber,
//                             foregroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                           ),
//                           child: const Text('SHOP NOW'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (ctx, i) => CartItemWidget(
//                       id: cartItems[i].id,
//                       watchId: cartItems[i].watchId,
//                       price: cartItems[i].price,
//                       quantity: cartItems[i].quantity,
//                       title: cartItems[i].name,
//                       imageUrl: cartItems[i].imageUrl,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';
import '/widgets/cart_item.dart';
import '/models/app_state.dart';
import '/screens/checkout_screen.dart';
import '/screens/auth_screen.dart'; // Make sure to import your auth screen

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'YOUR CART',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Total and Checkout Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final isLoggedIn = Provider.of<AppState>(
                      context,
                      listen: false,
                    ).isLoggedIn;
                    
                    if (isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ),
                      );
                    } else {
                      // Show login requirement message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please login to checkout'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      
                      // Navigate to auth screen and wait for result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                      
                      // If user successfully logged in, proceed to checkout
                      if (result == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Cart Items List
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore our collection',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('SHOP NOW'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) => CartItemWidget(
                      id: cartItems[i].id,
                      watchId: cartItems[i].watchId,
                      price: cartItems[i].price,
                      quantity: cartItems[i].quantity,
                      title: cartItems[i].name,
                      imageUrl: cartItems[i].imageUrl,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}