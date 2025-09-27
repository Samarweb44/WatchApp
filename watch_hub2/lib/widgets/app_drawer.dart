// // lib/widgets/app_drawer.dart
// import 'package:flutter/material.dart';
// import '/screens/cart_screen.dart';
// import '/screens/wishlist_screen.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Text(
//               'Watch Hub',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.favorite),
//             title: const Text('Wishlist'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const WishlistScreen(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.shopping_cart),
//             title: const Text('Cart'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CartScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // lib/widgets/app_drawer.dart
// import 'package:flutter/material.dart';
// import '/screens/cart_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '/screens/wishlist_screen.dart';
// import '/screens/auth_screen.dart'; // Make sure to import your AuthScreen

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

// @override
// Widget build(BuildContext context) {
//   final user = FirebaseAuth.instance.currentUser;

//   return Drawer(
//     backgroundColor: Colors.black,
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         // Header with user info
//         Container(
//           height: 200,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.black, Colors.grey[900]!],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 bottom: 50,
//                 left: 20,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'WATCH',
//                       style: TextStyle(
//                         color: Colors.yellow[600],
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                     Text(
//                       'HUB',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 left: 20,
//                 child: user != null
//                     ? Text(
//                         'Logged in as:\n${user.email ?? user.uid}',
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 12,
//                         ),
//                       )
//                     : Text(
//                         'Guest User',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//               ),
//               Positioned(
//                 top: 40,
//                 right: 20,
//                 child: Icon(
//                   Icons.watch,
//                   color: Colors.yellow[600]!.withOpacity(0.3),
//                   size: 80,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Navigation items
//         _buildDrawerItem(
//           context: context,
//           icon: Icons.home,
//           title: 'Home',
//           onTap: () => Navigator.pop(context),
//         ),
//         _buildDivider(),
//         _buildDrawerItem(
//           context: context,
//           icon: Icons.favorite,
//           title: 'Wishlist',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const WishlistScreen()),
//           ),
//         ),
//         _buildDivider(),
//         _buildDrawerItem(
//           context: context,
//           icon: Icons.shopping_cart,
//           title: 'Cart',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const CartScreen()),
//           ),
//         ),
//         _buildDivider(),
//         _buildDrawerItem(
//           context: context,
//           icon: user != null ? Icons.logout : Icons.login,
//           title: user != null ? 'Logout' : 'Login/Signup',
//           onTap: () {
//             if (user != null) {
//               FirebaseAuth.instance.signOut();
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logged out successfully')),
//               );
//             } else {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AuthScreen()),
//               );
//             }
//           },
//         ),
//         _buildDivider(),

//         // Footer
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text(
//             'Premium Watches Collection',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }



//   Widget _buildDivider() {
//     return Divider(
//       color: Colors.yellow[600]!.withOpacity(0.2),
//       height: 1,
//       thickness: 1,
//       indent: 20,
//       endIndent: 20,
//     );
//   }

//   Widget _buildDrawerItem({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: Colors.yellow[600],
//         size: 26,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: Icon(
//         Icons.chevron_right,
//         color: Colors.yellow[600]!.withOpacity(0.5),
//       ),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       hoverColor: Colors.yellow[600]!.withOpacity(0.1),
//     );
//   }
// }


// // lib/widgets/app_drawer.dart
// // lib/widgets/app_drawer.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/screens/cart_screen.dart';
// import '/screens/wishlist_screen.dart';
// import '/screens/auth_screen.dart';
// import '/screens/profile_screen.dart';
// // import '/screens/order_tracking_screen.dart';
// import '/screens/user_notifications_screen.dart'; // Add this import

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Drawer(
//       backgroundColor: Colors.black,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // Header with user info (existing code remains the same)
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black, Colors.grey[900]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: 50,
//                   left: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'WATCH',
//                         style: TextStyle(
//                           color: Colors.yellow[600],
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                       Text(
//                         'HUB',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: 20,
//                   child: user != null
//                       ? Text(
//                           'Logged in as:\n${user.email ?? user.uid}',
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 12,
//                           ),
//                         )
//                       : Text(
//                           'Guest User',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                 ),
//                 Positioned(
//                   top: 40,
//                   right: 20,
//                   child: Icon(
//                     Icons.watch,
//                     color: Colors.yellow[600]!.withOpacity(0.3),
//                     size: 80,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Navigation items
//           _buildDrawerItem(
//             context: context,
//             icon: Icons.home,
//             title: 'Home',
//             onTap: () => Navigator.pop(context),
//           ),
//           _buildDivider(),
//           if (user != null) ...[
//             _buildDrawerItem(
//               context: context,
//               icon: Icons.person,
//               title: 'My Profile',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()),
//               ),
//             ),
//             _buildDivider(),
//             _buildDrawerItem(
//               context: context,
//               icon: Icons.notifications,
//               title: 'Notifications',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CleanOrderTrackingScreen()),
//               ),
//             ),
//             _buildDivider(),
//             // _buildDrawerItem(
//             //   context: context,
//             //   icon: Icons.local_shipping,
//             //   title: 'Track Order',
//             //   onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
//             //   ),
//             // ),
//             // _buildDivider(),
//           ],
//           _buildDrawerItem(
//             context: context,
//             icon: Icons.favorite,
//             title: 'Wishlist',
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const WishlistScreen()),
//             ),
//           ),
//           _buildDivider(),
//           _buildDrawerItem(
//             context: context,
//             icon: Icons.shopping_cart,
//             title: 'Cart',
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const CartScreen()),
//             ),
//           ),
//           _buildDivider(),
//           _buildDrawerItem(
//             context: context,
//             icon: user != null ? Icons.logout : Icons.login,
//             title: user != null ? 'Logout' : 'Login/Signup',
//             onTap: () {
//               if (user != null) {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Logged out successfully')),
//                 );
//               } else {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AuthScreen()),
//                 );
//               }
//             },
//           ),
//           _buildDivider(),

//           // Footer (existing code remains the same)
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               'Premium Watches Collection',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(
//       color: Colors.yellow[600]!.withOpacity(0.2),
//       height: 1,
//       thickness: 1,
//       indent: 20,
//       endIndent: 20,
//     );
//   }

//   Widget _buildDrawerItem({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: Colors.yellow[600],
//         size: 26,
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: Icon(
//         Icons.chevron_right,
//         color: Colors.yellow[600]!.withOpacity(0.5),
//       ),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       hoverColor: Colors.yellow[600]!.withOpacity(0.1),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/feedback_screen.dart';
import '/screens/cart_screen.dart';
import '/screens/wishlist_screen.dart';
import '/screens/auth_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/contact_screen.dart';
import '/screens/user_notifications_screen.dart';
import '/screens/subscription_screen.dart';  // <-- Import your subscription screen here

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header (unchanged)
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WATCH',
                        style: TextStyle(
                          color: Colors.yellow[600],
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'HUB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: user != null
                      ? Text(
                          'Logged in as:\n${user.email ?? user.uid}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          'Guest User',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Icon(
                    Icons.watch,
                    color: Colors.yellow[600]!.withOpacity(0.3),
                    size: 80,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items (some unchanged)

          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _buildDivider(),
          if (user != null) ...[
            _buildDrawerItem(
              context: context,
              icon: Icons.person,
              title: 'My Profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            _buildDivider(),
            _buildDrawerItem(
              context: context,
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderTrackingScreen()),
              ),
            ),
            _buildDivider(),
          ],
          _buildDrawerItem(
            context: context,
            icon: Icons.favorite,
            title: 'Wishlist',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistScreen()),
            ),
          ),
          _buildDivider(),
           _buildDrawerItem(
            context: context,
            icon: Icons.feedback,
            title: 'Feedback',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackScreen()),
            ),
          ),
          _buildDivider(),

          // New Subscription item added here:
          _buildDrawerItem(
            context: context,
            icon: Icons.subscriptions,
            title: 'Subscription',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionScreen(),
              ),
            ),
          ),
          _buildDivider(),

          _buildDrawerItem(
            context: context,
            icon: Icons.shopping_cart,
            title: 'Cart',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
          ),
          _buildDivider(),
            _buildDrawerItem(
            context: context,
            icon: Icons.contact_mail,
            title: 'Contact Us',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            ),
          ),
          _buildDivider(),
          _buildDrawerItem(
            context: context,
            icon: user != null ? Icons.logout : Icons.login,
            title: user != null ? 'Logout' : 'Login/Signup',
            onTap: () {
              if (user != null) {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
          _buildDivider(),

          // Footer (unchanged)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Premium Watches Collection',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.yellow[600]!.withOpacity(0.2),
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.yellow[600],
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.yellow[600]!.withOpacity(0.5),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Colors.yellow[600]!.withOpacity(0.1),
    );
  }
}
