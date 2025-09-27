// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/models/app_state.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/product_list_screen.dart';
// import '/screens/cart_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/widgets/product_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/app_drawer.dart';
// import '../screens/search_screen.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Watch> featuredWatches = [
//     Watch(
//       id: '1',
//       name: 'Royal Chronograph',
//       brand: 'Patek Philippe',
//       price: 45999.99,
//       description: 'Exquisite Swiss craftsmanship with perpetual calendar',
//       images: ['https://th.bing.com/th/id/R.8cd1f1f973c81eaf0161d004dcf8c2d0?rik=M%2fyNvUN9m3Yd7Q&pid=ImgRaw&r=0'],
//       rating: 4.9,
//       reviewCount: 42,
//       features: ['18k white gold', 'Sapphire crystal', 'Hand-engraved'],
//       category: 'Luxury',
//     ),
//     Watch(
//       id: '2',
//       name: 'Submariner Pro',
//       brand: 'Rolex',
//       price: 12500.00,
//       description: 'Iconic diving watch with ceramic bezel',
//       images: [
//         'https://content.rolex.com/dam/2022-11/upright-bba-with-shadow/m126610ln-0001.png',
//       ],
//       rating: 4.8,
//       reviewCount: 128,
//       features: ['300m water resistant', 'Oystersteel', 'Chronometer'],
//       category: 'Diver',
//     ),
//     Watch(
//       id: '3',
//       name: 'Galaxy Watch 5',
//       brand: 'Samsung',
//       price: 349.99,
//       description: 'Advanced smartwatch with health monitoring',
//       images: [
//         'https://th.bing.com/th/id/R.935a20a2bb18bc790196f30cf55d07f3?rik=QOywkdQt%2fdxSnQ&riu=http%3a%2f%2fwww.meyers-watches.com%2fwp-content%2fuploads%2f2016%2f11%2fLBA-ANe.png&ehk=2bRo%2fQrVmsPRhBHvjx%2bwGHU%2bpsNctlcy98%2fLlySdTJ8%3d&risl=&pid=ImgRaw&r=0',
//       ],
//       rating: 4.5,
//       reviewCount: 342,
//       features: ['BioActive sensor', 'Sleep tracking', 'Fast charging'],
//       category: 'Smart',
//     ),
//     Watch(
//       id: '4',
//       name: 'Heritage Automatic',
//       brand: 'Jaeger-LeCoultre',
//       price: 12500.00,
//       description: 'Classic dress watch with exhibition case back',
//       images: [
//         'https://th.bing.com/th/id/R.b6216167a10cba483407a966dacbb8ee?rik=A9Yemyxnz9%2fqfA&pid=ImgRaw&r=0',
//       ],
//       rating: 4.7,
//       reviewCount: 56,
//       features: ['39mm case', '70h power reserve', 'Alligator strap'],
//       category: 'Classic',
//     ),
//     Watch(
//       id: '5',
//       name: 'Speedmaster Moonwatch',
//       brand: 'Omega',
//       price: 6300.00,
//       description: 'The first watch worn on the moon',
//       images: [
//         'https://pngimg.com/uploads/watches/watches_PNG9866.png',
//       ],
//       rating: 4.9,
//       reviewCount: 214,
//       features: ['Manual winding', 'Hesalite crystal', 'Moon history'],
//       category: 'Sports',
//     ),
//   ];

//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     _showAuthDialog(context);
//   //   });

//   //   // Auto-scroll banner
//   //   _startBannerTimer();
//   // }

//   @override
// void initState() {
//   super.initState();
//   _startBannerTimer();

//   // Check auth state when widget initializes
//   FirebaseAuth.instance.authStateChanges().listen((User? user) {
//     if (user == null && !context.read<AppState>().isLoggedIn) {
//       _showAuthDialog(context);
//     }
//   });
// }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients) {
//         if (_currentBannerIndex < 2) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   // void _showAuthDialog(BuildContext context) {
//   //   final isLoggedIn = context.read<AppState>().isLoggedIn;
//   //   if (!isLoggedIn) {
//   //     showDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       builder: (context) => const AuthDialog(),
//   //     );
//   //   }
//   // }
//   void _showAuthDialog(BuildContext context) {
//   final isLoggedIn = context.read<AppState>().isLoggedIn;
//   final auth = FirebaseAuth.instance;

//   // Only show dialog if user is not logged in (check both AppState and FirebaseAuth)
//   if (!isLoggedIn && auth.currentUser == null) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const AuthDialog(),
//       );
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text(
//           'WATCH HUB',
//           style: TextStyle(
//             fontWeight: FontWeight.w300,
//             letterSpacing: 4.0,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               showSearch(context: context, delegate: SearchScreen());
//             },
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart, color: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//               Consumer<CartProvider>(
//                 builder: (context, cart, child) {
//                   final cartCount = cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
//                   if (cartCount == 0) return SizedBox.shrink();
//                   return Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       constraints: const BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 14,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         '$cartCount',
//                         style: const TextStyle(color: Colors.black, fontSize: 8),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // Hero Banner with Parallax Effect
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: size.height * 0.4,
//               child: Stack(
//                 children: [
//                   PageView(
//                     controller: _bannerController,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentBannerIndex = index;
//                       });
//                     },
//                     children: [
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?ixlib=rb-4.0.3',
//                         'SUMMER COLLECTION',
//                         'UP TO 40% OFF',
//                       ),
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1524805444758-089113d48a6d?ixlib=rb-4.0.3',
//                         'NEW ARRIVALS',
//                         'LUXURY TIMEPIECES',
//                       ),
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                         'LIMITED EDITION',
//                         'EXCLUSIVE MODELS',
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(3, (index) {
//                         return Container(
//                           width: 8,
//                           height: 8,
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _currentBannerIndex == index
//                                 ? Colors.amber
//                                 : Colors.white.withOpacity(0.5),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Featured Collections
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'CURATED COLLECTIONS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 160,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         _buildCollectionCard(
//                           context,
//                           'Luxury Timepieces',
//                           'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                           Colors.blueGrey[900]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Sport Watches',
//                           'https://images.unsplash.com/photo-1551818255-e6e10975bc17?ixlib=rb-4.0.3',
//                           Colors.brown[800]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Smart Wearables',
//                           'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-4.0.3',
//                           Colors.indigo[900]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Vintage Classics',
//                           'https://images.unsplash.com/photo-1539874754764-5a96559165b0?ixlib=rb-4.0.3',
//                           Colors.grey[800]!,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Featured Watches
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'FEATURED TIMEPIECES',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductListScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'VIEW ALL',
//                       style: TextStyle(color: Colors.amber),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => ProductCard(
//                   watch: featuredWatches[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailScreen(watch: featuredWatches[index]),
//                       ),
//                     );
//                   },
//                 ),
//                 childCount: featuredWatches.length,
//               ),
//             ),
//           ),

//           // Brands Section
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'OUR BRANDS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: GridView.count(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       crossAxisCount: 3,
//                       childAspectRatio: 2,
//                       mainAxisSpacing: 16,
//                       crossAxisSpacing: 16,
//                       children: [
//                         _buildBrandLogo(
//                           'Rolex',
//                           'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Patek Philippe',
//                           'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Omega',
//                           'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Jaeger-LeCoultre',
//                           'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                         _buildBrandLogo(
//                           'Samsung',
//                           'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
//                         ),
//                         _buildBrandLogo(
//                           'Audemars Piguet',
//                           'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Testimonials
//           SliverPadding(
//             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'CLIENT TESTIMONIALS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 200,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         _buildTestimonialCard(
//                           'Alex Johnson',
//                           'The Patek Philippe I purchased is absolutely stunning. The craftsmanship is unparalleled.',
//                           '⭐⭐⭐⭐⭐',
//                           'https://tse2.mm.bing.net/th/id/OIP.F6V_4Q0E2AJH03hlRQxT-wHaEK?rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                         _buildTestimonialCard(
//                           'Sarah Williams',
//                           'Excellent customer service and fast delivery. My new Rolex is perfect!',
//                           '⭐⭐⭐⭐⭐',
//                           'https://www.brewin.co.uk/wp-content/uploads/sites/10/2024/01/Giorgio-De-Lucia.jpg?w=2000',
//                         ),
//                         _buildTestimonialCard(
//                           'Michael Chen',
//                           'Great selection of luxury watches. Found exactly what I was looking for.',
//                           '⭐⭐⭐⭐',
//                           'https://tse1.mm.bing.net/th/id/OIP.LyA9PqrYUacVfp_wpJEnSAHaIQ?w=535&h=596&rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBannerItem(String imageUrl, String subtitle, String title) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ProductListScreen(category: 'Featured'),
//                   ),
//                 );
//               },
//               child: const Text('EXPLORE'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCollectionCard(
//     BuildContext context,
//     String title,
//     String imageUrl,
//     Color color,
//   ) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductListScreen(category: title),
//           ),
//         );
//       },
//       child: Container(
//         width: 140,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [color.withOpacity(0.8), Colors.transparent],
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Image.network(
//         logoUrl,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTestimonialCard(
//     String name,
//     String review,
//     String stars,
//     String avatarUrl,
//   ) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: NetworkImage(avatarUrl),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     stars,
//                     style: const TextStyle(color: Colors.amber, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             review,
//             style: const TextStyle(
//               fontSize: 14,
//               fontStyle: FontStyle.italic,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WatchSearch extends SearchDelegate<String> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear, color: Colors.white),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back, color: Colors.white),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final appState = Provider.of<AppState>(context, listen: false);
//     final allWatches = appState.allWatches.isNotEmpty
//         ? appState.allWatches
//         : (context
//                   .findAncestorStateOfType<_HomeScreenState>()
//                   ?.featuredWatches ??
//               []);
//     final results = allWatches.where(
//       (watch) =>
//           watch.name.toLowerCase().contains(query.toLowerCase()) ||
//           watch.brand.toLowerCase().contains(query.toLowerCase()),
//     );

//     return Container(
//       color: Colors.black,
//       child: ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           final watch = results.elementAt(index);
//           return ListTile(
//             leading: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Image.network(
//                 watch.images.isNotEmpty ? watch.images[0] : '',
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.watch, color: Colors.white),
//               ),
//             ),
//             title: Text(
//               watch.name,
//               style: const TextStyle(color: Colors.white),
//             ),
//             subtitle: Text(
//               watch.brand,
//               style: const TextStyle(color: Colors.white70),
//             ),
//             onTap: () {
//               close(context, '');
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductDetailScreen(watch: watch),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final appState = Provider.of<AppState>(context, listen: false);
//     final allWatches = appState.allWatches.isNotEmpty
//         ? appState.allWatches
//         : (context
//                   .findAncestorStateOfType<_HomeScreenState>()
//                   ?.featuredWatches ??
//               []);
//     final suggestions = query.isEmpty
//         ? allWatches.take(5).toList()
//         : allWatches
//               .where(
//                 (watch) =>
//                     watch.name.toLowerCase().contains(query.toLowerCase()) ||
//                     watch.brand.toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();

//     return Container(
//       color: Colors.black,
//       child: ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           final watch = suggestions[index];
//           return ListTile(
//             leading: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Image.network(
//                 watch.images.isNotEmpty ? watch.images[0] : '',
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.watch, color: Colors.white),
//               ),
//             ),
//             title: Text(
//               watch.name,
//               style: const TextStyle(color: Colors.white),
//             ),
//             subtitle: Text(
//               watch.brand,
//               style: const TextStyle(color: Colors.white70),
//             ),
//             onTap: () {
//               query = watch.name;
//               showResults(context);
//             },
//           );
//         },
//       ),
//     );
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     return ThemeData.dark().copyWith(
//       scaffoldBackgroundColor: Colors.black,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),
//       inputDecorationTheme: const InputDecorationTheme(
//         hintStyle: TextStyle(color: Colors.white54),
//         border: InputBorder.none,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/product_card.dart';
// import '/widgets/app_drawer.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/cart_screen.dart';
// import '/screens/search_screen.dart';
// import '/models/watch_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   List<Map<String, dynamic>> _products = [];
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _startBannerTimer();
//     _checkAuthState();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([
//         _fetchProducts(),
//         _fetchCategories(),
//       ]);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load data: ${e.toString()}';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _fetchProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .get();

//       if (snapshot.docs.isEmpty) {
//         throw Exception('No products found');
//       }

//       setState(() {
//         _products = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'b_name': data['b_name'] ?? 'Unnamed Product',
//             'b_desc': data['b_desc'] ?? 'No description',
//             'b_img': data['b_img'] ?? 'https://via.placeholder.com/150',
//             'price': data['price'] ?? 0.0,
//             'category': data['category'] ?? 'uncategorized',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load products: $e');
//     }
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _categories = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['category'] ?? 'Unnamed Category',
//             'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients && mounted) {
//         if (_currentBannerIndex < 2) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _checkAuthState() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null && mounted) {
//         _showAuthDialog();
//       }
//     });
//   }

//   void _showAuthDialog() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const AuthDialog(),
//       );
//     });
//   }

//   Widget _buildBannerItem(String imageUrl, String subtitle, String title) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text('SHOP NOW'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCollectionCard(String title, String imageUrl, Color color) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         width: 140,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [color.withOpacity(0.8), Colors.transparent],
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _buildProductItem(Map<String, dynamic> product) {
//   //   return ProductCard(
//   //     product: product,
//   //     onTap: () => Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => ProductDetailScreen(product: product),
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget _buildProductItem(Map<String, dynamic> product) {
//   final watch = Watch.fromMap(product);

//   return ProductCard(
//     watch: watch,
//     onTap: () => Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductDetailScreen(product: product),
//       ),
//     ),
//   );
// }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage ?? 'Unknown error occurred',
//             style: const TextStyle(color: Colors.white, fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.amber,
//               foregroundColor: Colors.black,
//             ),
//             onPressed: _initializeData,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingWidget() {
//     return const Center(
//       child: CircularProgressIndicator(color: Colors.amber),
//     );
//   }

//   Widget _buildContent() {
//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         // Banner Section
//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height * 0.4,
//             child: Stack(
//               children: [
//                 PageView(
//                   controller: _bannerController,
//                   onPageChanged: (index) {
//                     if (mounted) setState(() => _currentBannerIndex = index);
//                   },
//                   children: [
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?ixlib=rb-4.0.3',
//                       'SUMMER COLLECTION',
//                       'UP TO 40% OFF',
//                     ),
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1524805444758-089113d48a6d?ixlib=rb-4.0.3',
//                       'NEW ARRIVALS',
//                       'LUXURY PRODUCTS',
//                     ),
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                       'LIMITED EDITION',
//                       'EXCLUSIVE ITEMS',
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   left: 0,
//                   right: 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(3, (index) {
//                       return Container(
//                         width: 8,
//                         height: 8,
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: _currentBannerIndex == index
//                               ? Colors.amber
//                               : Colors.white.withOpacity(0.5),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Featured Collections
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//           sliver: SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'CURATED COLLECTIONS',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: 160,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       _buildCollectionCard(
//                         'Luxury Items',
//                         'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                         Colors.blueGrey[900]!,
//                       ),
//                       _buildCollectionCard(
//                         'Sports Gear',
//                         'https://images.unsplash.com/photo-1551818255-e6e10975bc17?ixlib=rb-4.0.3',
//                         Colors.brown[800]!,
//                       ),
//                       _buildCollectionCard(
//                         'Smart Devices',
//                         'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-4.0.3',
//                         Colors.indigo[900]!,
//                       ),
//                       _buildCollectionCard(
//                         'Vintage Classics',
//                         'https://images.unsplash.com/photo-1539874754764-5a96559165b0?ixlib=rb-4.0.3',
//                         Colors.grey[800]!,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Products Grid
//         if (_products.isNotEmpty)
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => _buildProductItem(_products[index]),
//                 childCount: _products.length,
//               ),
//             ),
//           ),

//         // Brands Section
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//           sliver: SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'OUR BRANDS',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 3,
//                     childAspectRatio: 2,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     children: [
//                       _buildBrandLogo('Nike', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Adidas', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Apple', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Samsung', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Sony', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Gucci', 'https://via.placeholder.com/150'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Image.network(
//         logoUrl,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text(
//           'PRODUCT HUB',
//           style: TextStyle(
//             fontWeight: FontWeight.w300,
//             letterSpacing: 4.0,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () => showSearch(
//               context: context,
//               delegate: SearchScreen(),
//             ),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart, color: Colors.white),
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const CartScreen()),
//                 ),
//               ),
//               Consumer<CartProvider>(
//                 builder: (context, cart, child) {
//                   final count = cart.items.length;
//                   if (count == 0) return const SizedBox.shrink();
//                   return Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       constraints: const BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 14,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         '$count',
//                         style: const TextStyle(color: Colors.black, fontSize: 8),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _errorMessage != null
//           ? _buildErrorWidget()
//           : _isLoading
//               ? _buildLoadingWidget()
//               : _buildContent(),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
// }///////////////////////////////////////////////222222
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/product_card.dart';
// import '/widgets/app_drawer.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/cart_screen.dart';
// import '/screens/search_screen.dart';
// import '/models/watch_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   List<Watch> _products = [];
//   List<Map<String, dynamic>> _categories = [];
//   Map<String, List<Watch>> _productsByCategory = {};
//   bool _isLoading = true;
//   String? _errorMessage;
//   String? _selectedCategory;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _startBannerTimer();
//     _checkAuthState();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([
//         _fetchProducts(),
//         _fetchCategories(),
//       ]);
//       _organizeProductsByCategory();
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load data: ${e.toString()}';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _fetchProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .get();

//       if (snapshot.docs.isEmpty) {
//         throw Exception('No products found');
//       }

//       setState(() {
//         _products = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return Watch.fromMap({
//             ...data,
//             'id': doc.id,
//           });
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load products: $e');
//     }
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _categories = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['category'] ?? 'Unnamed Category',
//             'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   void _organizeProductsByCategory() {
//     final productsByCategory = <String, List<Watch>>{};

//     // Add all categories first
//     for (var category in _categories) {
//       productsByCategory[category['name']] = [];
//     }

//     // Add uncategorized products
//     productsByCategory['All'] = [];

//     // Organize products
//     for (var product in _products) {
//       if (product.category != null && productsByCategory.containsKey(product.category)) {
//         productsByCategory[product.category]!.add(product);
//       } else {
//         productsByCategory['All']!.add(product);
//       }
//     }

//     setState(() {
//       _productsByCategory = productsByCategory;
//       _selectedCategory = _categories.isNotEmpty ? _categories.first['name'] : 'All';
//     });
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients && mounted) {
//         if (_currentBannerIndex < 2) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _checkAuthState() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null && mounted) {
//         _showAuthDialog();
//       }
//     });
//   }

//   void _showAuthDialog() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const AuthDialog(),
//       );
//     });
//   }

//   Widget _buildBannerItem(String imageUrl, String subtitle, String title) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text('SHOP NOW'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryChip(String categoryName, String imageUrl) {
//     final isSelected = _selectedCategory == categoryName;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedCategory = categoryName;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(right: 8),
//         child: Chip(
//           label: Text(categoryName),
//           avatar: CircleAvatar(
//             backgroundImage: NetworkImage(imageUrl),
//           ),
//           backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
//           labelStyle: TextStyle(
//             color: isSelected ? Colors.black : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductItem(Watch watch) {
//     return ProductCard(
//       watch: watch,
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProductDetailScreen(product: watch.toMap()),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage ?? 'Unknown error occurred',
//             style: const TextStyle(color: Colors.white, fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.amber,
//               foregroundColor: Colors.black,
//             ),
//             onPressed: _initializeData,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingWidget() {
//     return const Center(
//       child: CircularProgressIndicator(color: Colors.amber),
//     );
//   }

//   Widget _buildContent() {
//     final currentProducts = _selectedCategory != null
//         ? _productsByCategory[_selectedCategory] ?? []
//         : _products;

//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         // Banner Section
//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height * 0.4,
//             child: Stack(
//               children: [
//                 PageView(
//                   controller: _bannerController,
//                   onPageChanged: (index) {
//                     if (mounted) setState(() => _currentBannerIndex = index);
//                   },
//                   children: [
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?ixlib=rb-4.0.3',
//                       'SUMMER COLLECTION',
//                       'UP TO 40% OFF',
//                     ),
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1524805444758-089113d48a6d?ixlib=rb-4.0.3',
//                       'NEW ARRIVALS',
//                       'LUXURY PRODUCTS',
//                     ),
//                     _buildBannerItem(
//                       'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                       'LIMITED EDITION',
//                       'EXCLUSIVE ITEMS',
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   left: 0,
//                   right: 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(3, (index) {
//                       return Container(
//                         width: 8,
//                         height: 8,
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: _currentBannerIndex == index
//                               ? Colors.amber
//                               : Colors.white.withOpacity(0.5),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Category Selection
//         SliverToBoxAdapter(
//           child: SizedBox(
//             height: 60,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               children: [
//                 _buildCategoryChip('All', 'https://via.placeholder.com/150'),
//                 ..._categories.map((category) =>
//                   _buildCategoryChip(category['name'], category['cat_img']),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Products Grid
//         if (currentProducts.isNotEmpty)
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => _buildProductItem(currentProducts[index]),
//                 childCount: currentProducts.length,
//               ),
//             ),
//           ),
//         if (currentProducts.isEmpty)
//           const SliverToBoxAdapter(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'No products in this category',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),

//         // Featured Brands Section
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//           sliver: SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'OUR BRANDS',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 3,
//                     childAspectRatio: 2,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     children: [
//                       _buildBrandLogo('Nike', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Adidas', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Apple', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Samsung', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Sony', 'https://via.placeholder.com/150'),
//                       _buildBrandLogo('Gucci', 'https://via.placeholder.com/150'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Image.network(
//         logoUrl,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text(
//           'PRODUCT HUB',
//           style: TextStyle(
//             fontWeight: FontWeight.w300,
//             letterSpacing: 4.0,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () => showSearch(
//               context: context,
//               delegate: SearchScreen(),
//             ),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart, color: Colors.white),
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const CartScreen()),
//                 ),
//               ),
//               Consumer<CartProvider>(
//                 builder: (context, cart, child) {
//                   final count = cart.items.length;
//                   if (count == 0) return const SizedBox.shrink();
//                   return Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       constraints: const BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 14,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         '$count',
//                         style: const TextStyle(color: Colors.black, fontSize: 8),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _errorMessage != null
//           ? _buildErrorWidget()
//           : _isLoading
//               ? _buildLoadingWidget()
//               : _buildContent(),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
// }

//////////////////////////////2222222
///
///
library;


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/models/app_state.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/product_list_screen.dart';
// import '/screens/cart_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/widgets/product_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/app_drawer.dart';
// import '../screens/search_screen.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   List<Watch> _products = [];
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _authDialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _startBannerTimer();
//     _checkAuthState();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await Future.wait([
//         _fetchProducts(),
//         _fetchCategories(),
//       ]);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load data: ${e.toString()}';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _fetchProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .limit(4)  // Only fetch 4 for the featured section
//           .get();

//       setState(() {
//         _products = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return Watch.fromMap({
//             ...data,
//             'id': doc.id,
//           });
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load products: $e');
//     }
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _categories = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['category'] ?? 'Unnamed Category',
//             'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients && mounted) {
//         if (_currentBannerIndex < 2) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _checkAuthState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null && !_authDialogShown) {
//         _authDialogShown = true;
//         _showAuthDialog();
//       }
//     });
//   }

//   void _showAuthDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const AuthDialog(),
//     );
//   }

//   // ================== UI Components ==================
//   Widget _buildBannerItem(String imageUrl, String subtitle, String title) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [
//               Colors.black.withOpacity(0.8),
//               Colors.transparent,
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               subtitle,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text('EXPLORE'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildCollectionCard(String title, String imageUrl, String categoryId) {
//   //   return InkWell(
//   //     onTap: () {
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => ProductListScreen(
//   //             categoryId: categoryId,
//   //           ),
//   //         ),
//   //       );
//   //     },

//   ///////////
//   // Widget _buildCollectionCard(String title, String imageUrl, String categoryId) {
//   // return InkWell(
//   //   onTap: () {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => ProductListScreen(
//   //           categoryId: categoryId,
//   //           categoryName: title, // Pass both ID and name
//   //         ),
//   //       ),
//   //     );
//   //   },
//   //     child: Container(
//   //       width: 140,
//   //       margin: const EdgeInsets.only(right: 16),
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(12),
//   //         image: DecorationImage(
//   //           image: NetworkImage(imageUrl),
//   //           fit: BoxFit.cover,
//   //         ),
//   //       ),
//   //       child: Container(
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(12),
//   //           gradient: LinearGradient(
//   //             begin: Alignment.bottomCenter,
//   //             end: Alignment.topCenter,
//   //             colors: [
//   //               Colors.black.withOpacity(0.7),
//   //               Colors.transparent,
//   //             ],
//   //           ),
//   //         ),
//   //         padding: const EdgeInsets.all(12),
//   //         alignment: Alignment.bottomLeft,
//   //         child: Text(
//   //           title,
//   //           style: const TextStyle(
//   //             color: Colors.white,
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildCollectionCard(String title, String imageUrl, String categoryId) {
//   return InkWell(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProductListScreen(
//             categoryName: title, // For name-based filtering
//             categoryId: categoryId, // For ID-based filtering
//           ),
//         ),
//       );
//     },
//     child: Container(
//       width: 140,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [
//               Colors.black.withOpacity(0.7),
//               Colors.transparent,
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(12),
//         alignment: Alignment.bottomLeft,
//         child: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[100],
//       ),
//       child: Image.network(
//         logoUrl,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Error Loading Data',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage ?? 'An unknown error occurred',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _initializeData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingWidget() {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text('WATCH HUB'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: SearchScreen(),
//               );
//             },
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Consumer<CartProvider>(
//                   builder: (context, cart, child) {
//                     if (cart.items.isEmpty) return const SizedBox.shrink();
//                     return Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${cart.items.length}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _errorMessage != null
//           ? _buildErrorWidget()
//           : _isLoading
//               ? _buildLoadingWidget()
//               : CustomScrollView(
//                   slivers: [
//                     // Banner Section
//                     SliverToBoxAdapter(
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         child: Stack(
//                           children: [
//                             PageView(
//                               controller: _bannerController,
//                               onPageChanged: (index) {
//                                 setState(() {
//                                   _currentBannerIndex = index;
//                                 });
//                               },
//                               children: [
//                                 _buildBannerItem(
//                                   'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?ixlib=rb-4.0.3',
//                                   'SUMMER COLLECTION',
//                                   'UP TO 40% OFF',
//                                 ),
//                                 _buildBannerItem(
//                                   'https://images.unsplash.com/photo-1524805444758-089113d48a6d?ixlib=rb-4.0.3',
//                                   'NEW ARRIVALS',
//                                   'LUXURY TIMEPIECES',
//                                 ),
//                                 _buildBannerItem(
//                                   'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                                   'LIMITED EDITION',
//                                   'EXCLUSIVE MODELS',
//                                 ),
//                               ],
//                             ),
//                             Positioned(
//                               bottom: 20,
//                               left: 0,
//                               right: 0,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: List.generate(3, (index) {
//                                   return Container(
//                                     width: 8,
//                                     height: 8,
//                                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: _currentBannerIndex == index
//                                           ? Colors.white
//                                           : Colors.white.withOpacity(0.5),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Dynamic Categories Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'CURATED COLLECTIONS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             SizedBox(
//                               height: 160,
//                               child: _categories.isEmpty
//                                   ? const Center(child: CircularProgressIndicator())
//                                   : ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: [
//                                         // Optional "All" category
//                                         _buildCollectionCard(
//                                           'All',
//                                           'https://th.bing.com/th/id/R.1ad1f7c0dcf9465f8e62bebc5e21ed37?rik=v0eOQoEB4UasEg&pid=ImgRaw&r=0',
//                                           'All',
//                                         ),
//                                         // Firestore categories
//                                         ..._categories.map((category) => _buildCollectionCard(
//                                               category['name'],
//                                               category['cat_img'],
//                                               category['id'],
//                                             )),
//                                       ],
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Featured Products Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverToBoxAdapter(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'FEATURED TIMEPIECES',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProductListScreen(),
//                                   ),
//                                 );
//                               },
//                               child: const Text('VIEW ALL'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverGrid(
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 0.75,
//                           mainAxisSpacing: 16,
//                           crossAxisSpacing: 16,
//                         ),
//                         delegate: SliverChildBuilderDelegate(
//                           (context, index) => ProductCard(
//                             watch: _products[index],
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ProductDetailScreen(
//                                     product: _products[index].toMap(),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           childCount: _products.length,
//                         ),
//                       ),
//                     ),

//                     // Brands Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'OUR BRANDS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               child: GridView.count(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 crossAxisCount: 3,
//                                 childAspectRatio: 2,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                                 children: [
//                                   _buildBrandLogo(
//                                     'Rolex',
//                                     'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Patek Philippe',
//                                     'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Omega',
//                                     'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Jaeger-LeCoultre',
//                                     'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Samsung',
//                                     'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Audemars Piguet',
//                                     'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/product_list_screen.dart';
// import '/screens/cart_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/widgets/product_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/app_drawer.dart';
// import '../screens/search_screen.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   List<Watch> _products = [];
//   List<Map<String, dynamic>> _categories = [];
//   List<Map<String, dynamic>> _carouselItems = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _authDialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _startBannerTimer();
//     _checkAuthState();
//   }

//   Future<void> _initializeData() async {
//     setState(() => _isLoading = true);
//     try {
//       await Future.wait([
//         _fetchProducts(),
//         _fetchCategories(),
//         _fetchCarouselItems(),
//       ]);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load data. Please try again later.';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _fetchProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .where('isFeatured', isEqualTo: true)
//           .limit(4)
//           .get();

//       setState(() {
//         _products = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return Watch.fromMap({...data, 'id': doc.id});
//         }).toList();
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load featured products: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _categories = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['category'] ?? 'Unnamed Category',
//             'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load categories: ${e.toString()}';
//       });
//     }
//   }

// Future<void> _fetchCarouselItems() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('carousel_items')
//           .where('isActive', isEqualTo: true)
//           .orderBy('updatedAt', descending: true)
//           .limit(5)
//           .get();

//       if (snapshot.docs.isEmpty) {
//         setState(() => _carouselItems = [_createDefaultCarouselItem()]);
//         return;
//       }

//       // Fetch all products referenced in carousel items
//       final allProductIds = snapshot.docs
//           .expand((doc) => (doc.data()['productIds'] as List<dynamic>).cast<String>())
//           .toSet()
//           .toList();

//       final productsSnapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .where(FieldPath.documentId, whereIn: allProductIds)
//           .get();

//       final productsMap = {
//         for (var doc in productsSnapshot.docs) doc.id: doc.data()
//       };

//       setState(() {
//         _carouselItems = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'title': data['title'] ?? 'No Title',
//             'subtitle': data['subtitle'] ?? '',
//             'imageUrl': data['imageUrl'],
//             'products': (data['products'] as List<dynamic>?)?.map((product) {
//               return {
//                 ...product,
//                 'details': productsMap[product['id']] ?? {},
//               };
//             }).toList() ?? [],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       debugPrint('Error fetching carousel: $e');
//       setState(() => _carouselItems = [_createDefaultCarouselItem()]);
//     }
//   }

//   Map<String, dynamic> _createDefaultCarouselItem() {
//     return {
//       'title': 'Welcome to Our Store',
//       'subtitle': 'Discover Amazing Products',
//       'imageUrl': 'https://via.placeholder.com/800x400?text=Welcome+Banner',
//       'collectionId': 'featured'
//     };
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients && mounted && _carouselItems.length > 1) {
//         if (_currentBannerIndex < _carouselItems.length - 1) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _checkAuthState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null && !_authDialogShown) {
//         _authDialogShown = true;
//         _showAuthDialog();
//       }
//     });
//   }

//   void _showAuthDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const AuthDialog(),
//     );
//   }

//   void _handleExplore(String collectionId) {
//     final categoryName = collectionId == 'featured'
//         ? 'Featured Products'
//         : _categories.firstWhere(
//             (cat) => cat['id'] == collectionId,
//             orElse: () => {'name': 'Collection'},
//           )['name'];

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductListScreen(
//           categoryId: collectionId == 'featured' ? null : collectionId,
//           categoryName: categoryName,
//         ),
//       ),
//     );
//   }

//  Widget _buildBannerItem(Map<String, dynamic> item) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               item['imageUrl'],
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 color: Colors.grey[200],
//                 child: const Center(
//                   child: Icon(Icons.error, size: 50),
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 24,
//             right: 24,
//             bottom: 24,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['subtitle'],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   item['title'],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: () => _handleExplore(item['collectionId'] ?? 'featured'),
//                   child: const Text('EXPLORE'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _buildCollectionCard(String title, String imageUrl, String categoryId) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductListScreen(
//               categoryName: title,
//               categoryId: categoryId,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 140,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[100],
//       ),
//       child: Image.network(
//         logoUrl,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselSection() {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.4,
//         child: Stack(
//           children: [
//             PageView.builder(
//               controller: _bannerController,
//               itemCount: _carouselItems.length,
//               onPageChanged: (index) {
//                 setState(() => _currentBannerIndex = index);
//               },
//               itemBuilder: (context, index) {
//                 return _buildBannerItem(_carouselItems[index]);
//               },
//             ),
//             if (_carouselItems.length > 1)
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(_carouselItems.length, (index) {
//                     return Container(
//                       width: 8,
//                       height: 8,
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _currentBannerIndex == index
//                             ? Colors.white
//                             : Colors.white.withOpacity(0.5),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               _products.isEmpty ? Icons.info_outline : Icons.error_outline,
//               size: 64,
//               color: _products.isEmpty ? Colors.blue : Colors.red,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               _products.isEmpty ? 'No Featured Products' : 'Error Loading Data',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage ?? 'An unknown error occurred',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             if (_products.isEmpty) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Check back later for featured products',
//                 textAlign: TextAlign.center,
//               ),
//             ],
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _initializeData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingWidget() {
//     return const Center(child: CircularProgressIndicator());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text('WATCH HUB'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(context: context, delegate: SearchScreen());
//             },
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Consumer<CartProvider>(
//                   builder: (context, cart, child) {
//                     if (cart.items.isEmpty) return const SizedBox.shrink();
//                     return Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${cart.items.length}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _errorMessage != null
//           ? _buildErrorWidget()
//           : _isLoading
//               ? _buildLoadingWidget()
//               : CustomScrollView(
//                   slivers: [
//                     _buildCarouselSection(),

//                     // Dynamic Categories Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 24,
//                         horizontal: 16,
//                       ),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'CURATED COLLECTIONS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             SizedBox(
//                               height: 160,
//                               child: _categories.isEmpty
//                                   ? const Center(child: CircularProgressIndicator())
//                                   : ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: [
//                                         _buildCollectionCard(
//                                           'All',
//                                           'https://th.bing.com/th/id/R.1ad1f7c0dcf9465f8e62bebc5e21ed37?rik=v0eOQoEB4UasEg&pid=ImgRaw&r=0',
//                                           'All',
//                                         ),
//                                         ..._categories.map(
//                                           (category) => _buildCollectionCard(
//                                             category['name'],
//                                             category['cat_img'],
//                                             category['id'],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Featured Products Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverToBoxAdapter(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'FEATURED TIMEPIECES',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const ProductListScreen(
//                                       categoryId: null,
//                                       categoryName: 'Featured Products',
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: const Text('VIEW ALL'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: _products.isEmpty
//                           ? SliverToBoxAdapter(
//                               child: Container(
//                                 height: 200,
//                                 alignment: Alignment.center,
//                                 child: const Text('No featured products available'),
//                               ),
//                             )
//                           : SliverGrid(
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.75,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                               ),
//                               delegate: SliverChildBuilderDelegate(
//                                 (context, index) => ProductCard(
//                                   watch: _products[index],
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ProductDetailScreen(
//                                           product: _products[index].toMap(),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 childCount: _products.length,
//                               ),
//                             ),
//                     ),

//                     // Brands Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 32,
//                         horizontal: 16,
//                       ),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'OUR BRANDS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               child: GridView.count(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 crossAxisCount: 3,
//                                 childAspectRatio: 2,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                                 children: [
//                                   _buildBrandLogo(
//                                     'Rolex',
//                                     'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Patek Philippe',
//                                     'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Omega',
//                                     'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Jaeger-LeCoultre',
//                                     'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Samsung',
//                                     'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Audemars Piguet',
//                                     'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
// }

//////////////////////////////////cuurrent
///
///
///
///
///

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/watch_model.dart';

import '/screens/product_detail_screen.dart';
import '/screens/product_list_screen.dart';
import '/screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/app_drawer.dart';
import '../screens/search_screen.dart';
import '/widgets/auth_dialog.dart';
import '/providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  List<Watch> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _carouselItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _authDialogShown = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startBannerTimer();
    _checkAuthState();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _fetchProducts(),
        _fetchCategories(),
        _fetchCarouselItems(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data. Please try again later.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .limit(4)
          .get();

      setState(() {
        _products = snapshot.docs.map((doc) {
          final data = doc.data();
          return Watch.fromMap({...data, 'id': doc.id});
        }).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load featured products: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();

      setState(() {
        _categories = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['category'] ?? 'Unnamed Category',
            'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchCarouselItems() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('carousel_items')
          .where('isActive', isEqualTo: true)
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _carouselItems = [_createDefaultCarouselItem()];
        });
        return;
      }

      setState(() {
        _carouselItems = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'title': data['title'] ?? 'No Title',
            'subtitle': data['subtitle'] ?? '',
            'imageUrl':
                data['imageUrl'] ?? 'https://via.placeholder.com/800x400',
            'collectionId': data['collectionId'] ?? 'featured',
            'productIds': List<String>.from(data['selectedProductIds'] ?? []),
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching carousel: $e');
      setState(() {
        _carouselItems = [_createDefaultCarouselItem()];
      });
    }
  }

  Map<String, dynamic> _createDefaultCarouselItem() {
    return {
      'title': 'Welcome to Our Store',
      'subtitle': 'Discover Amazing Products',
      'imageUrl': 'https://via.placeholder.com/800x400?text=Welcome+Banner',
      'collectionId': 'featured',
    };
  }

  void _startBannerTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_bannerController.hasClients &&
          mounted &&
          _carouselItems.length > 1) {
        if (_currentBannerIndex < _carouselItems.length - 1) {
          _bannerController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _bannerController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startBannerTimer();
      }
    });
  }

  void _checkAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null && !_authDialogShown) {
        _authDialogShown = true;
        _showAuthDialog();
      }
    });
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AuthDialog(),
    );
  }

  void _handleExplore(String collectionId, List<String>? productIds) async {
    if (productIds != null && productIds.isNotEmpty) {
      // Fetch the specific products for this carousel
      final products = await _fetchProductsByIds(productIds);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListScreen(
            products: products,
            categoryName: 'Featured Collection',
          ),
        ),
      );
    } else {
      // Fallback to the existing category-based navigation
      final categoryName = collectionId == 'featured'
          ? 'Featured Products'
          : _categories.firstWhere(
              (cat) => cat['id'] == collectionId,
              orElse: () => {'name': 'Collection'},
            )['name'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListScreen(
            categoryId: collectionId == 'featured' ? null : collectionId,
            categoryName: categoryName,
          ),
        ),
      );
    }
  }

  Future<List<Watch>> _fetchProductsByIds(List<String> productIds) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      return snapshot.docs.map((doc) {
        return Watch.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error fetching products by IDs: $e');
      return [];
    }
  }

  Widget _buildBannerItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image with error handling
            Positioned.fill(
              child: Image.network(
                item['imageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.error, size: 50)),
                ),
              ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['subtitle'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _handleExplore(
                      item['collectionId'],
                      (item['productIds'] as List?)?.cast<String>(),
                    ),
                    child: const Text('EXPLORE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(
    String title,
    String imageUrl,
    String categoryId,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListScreen(categoryName: title, categoryId: categoryId),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(String brand, String logoUrl) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Image.network(
        logoUrl,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(
            brand.split(' ').first,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          children: [
            PageView.builder(
              controller: _bannerController,
              itemCount: _carouselItems.length,
              onPageChanged: (index) {
                setState(() => _currentBannerIndex = index);
              },
              itemBuilder: (context, index) {
                return _buildBannerItem(_carouselItems[index]);
              },
            ),
            if (_carouselItems.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_carouselItems.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBannerIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _products.isEmpty ? Icons.info_outline : Icons.error_outline,
              size: 64,
              color: _products.isEmpty ? Colors.blue : Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              _products.isEmpty ? 'No Featured Products' : 'Error Loading Data',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (_products.isEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Check back later for featured products',
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _initializeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true, // Centers the title
        title: const Text(
          'WATCH HUB',
          style: TextStyle(
            color: Colors.white, // White title text
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Drawer/Menu icon color
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen());
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    if (cart.items.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      body: _errorMessage != null
          ? _buildErrorWidget()
          : _isLoading
          ? _buildLoadingWidget()
          : CustomScrollView(
              slivers: [
                _buildCarouselSection(),

                // Dynamic Categories Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURATED COLLECTIONS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160,
                          child: _categories.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _buildCollectionCard(
                                      'All',
                                      'https://th.bing.com/th/id/R.1ad1f7c0dcf9465f8e62bebc5e21ed37?rik=v0eOQoEB4UasEg&pid=ImgRaw&r=0',
                                      'All',
                                    ),
                                    ..._categories.map(
                                      (category) => _buildCollectionCard(
                                        category['name'],
                                        category['cat_img'],
                                        category['id'],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Featured Products Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FEATURED TIMEPIECES',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                  categoryId: null,
                                  categoryName: 'Featured Products',
                                ),
                              ),
                            );
                          },
                          child: const Text('VIEW ALL'),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: _products.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: const Text('No featured products available'),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductCard(
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
                            childCount: _products.length,
                          ),
                        ),
                ),

                // Brands Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUR BRANDS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: [
                              _buildBrandLogo(
                                'Rolex',
                                'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
                              ),
                              _buildBrandLogo(
                                'Patek Philippe',
                                'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
                              ),
                              _buildBrandLogo(
                                'Omega',
                                'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
                              ),
                              _buildBrandLogo(
                                'Jaeger-LeCoultre',
                                'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
                              ),
                              _buildBrandLogo(
                                'Samsung',
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
                              ),
                              _buildBrandLogo(
                                'Audemars Piguet',
                                'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      // Add this at the bottom of your HomePage class (inside _HomePageState)
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.black,
      //   selectedItemColor: Colors.yellow[600],
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 0, // Home is selected by default
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.favorite),
      //     //   label: 'contact us',
      //     // ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.shopping_cart),
      //     //   label: 'Cart',
      //     // ),
      //   ],
      //   onTap: (index) {
      //     switch (index) {
      //       case 0: // Home
      //         // Already on home, do nothing or maybe refresh
      //         break;
      //       // case 1: // Search
      //       //   showSearch(context: context, delegate: SearchScreen());
      //       //   break;
      //       // case 2: // Wishlist
      //       //   Navigator.push(
      //       //     context,
      //       //     MaterialPageRoute(builder: (context) => const ContactScreen()),
      //       //   );
      //       //   break;
      //       // case 3: // Cart
      //       //   Navigator.push(
      //       //     context,
      //       //     MaterialPageRoute(builder: (context) => const CartScreen()),
      //       //   );
      //         break;
      //       case 4: // Profile
      //         final user = FirebaseAuth.instance.currentUser;
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) =>
      //                 user != null ? const ProfileScreen() : const ProfileScreen(),
      //           ),
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/product_list_screen.dart';
// import '/screens/cart_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/widgets/product_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/widgets/app_drawer.dart';
// import '../screens/search_screen.dart';
// import '/widgets/auth_dialog.dart';
// import '/providers/cart_provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;

//   List<Watch> _products = [];
//   List<Map<String, dynamic>> _categories = [];
//   List<Map<String, dynamic>> _carouselItems = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _authDialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _startBannerTimer();
//     _checkAuthState();
//   }

//   Future<void> _initializeData() async {
//     setState(() => _isLoading = true);
//     try {
//       await Future.wait([
//         _fetchProducts(),
//         _fetchCategories(),
//         _fetchCarouselItems(),
//       ]);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load data. Please try again later.';
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _fetchProducts() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .where('isFeatured', isEqualTo: true)
//           .limit(4)
//           .get();

//       setState(() {
//         _products = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return Watch.fromMap({...data, 'id': doc.id});
//         }).toList();
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load featured products: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .get();

//       setState(() {
//         _categories = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'id': doc.id,
//             'name': data['category'] ?? 'Unnamed Category',
//             'cat_img': data['cat_img'] ?? 'https://via.placeholder.com/150',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load categories: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _fetchCarouselItems() async {
//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('carousel_items')
//           .where('isActive', isEqualTo: true)
//           .orderBy('updatedAt', descending: true)
//           .limit(5)
//           .get();

//       if (snapshot.docs.isEmpty) {
//         setState(() {
//           _carouselItems = [_createDefaultCarouselItem()];
//         });
//         return;
//       }

//       setState(() {
//         _carouselItems = snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'id': doc.id,
//             'title': data['title'] ?? 'No Title',
//             'subtitle': data['subtitle'] ?? '',
//             'imageUrl': data['imageUrl'] ?? 'https://via.placeholder.com/800x400',
//             'collectionId': data['collectionId'] ?? 'featured',
//           };
//         }).toList();
//       });
//     } catch (e) {
//       debugPrint('Error fetching carousel: $e');
//       setState(() {
//         _carouselItems = [_createDefaultCarouselItem()];
//       });
//     }
//   }

//   Map<String, dynamic> _createDefaultCarouselItem() {
//     return {
//       'title': 'Welcome to Our Store',
//       'subtitle': 'Discover Amazing Products',
//       'imageUrl': 'https://via.placeholder.com/800x400?text=Welcome+Banner',
//       'collectionId': 'featured'
//     };
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients && mounted && _carouselItems.length > 1) {
//         if (_currentBannerIndex < _carouselItems.length - 1) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _checkAuthState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null && !_authDialogShown) {
//         _authDialogShown = true;
//         _showAuthDialog();
//       }
//     });
//   }

//   void _showAuthDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const AuthDialog(),
//     );
//   }

//   void _handleExplore(String collectionId) {
//     final categoryName = collectionId == 'featured'
//         ? 'Featured Products'
//         : _categories.firstWhere(
//             (cat) => cat['id'] == collectionId,
//             orElse: () => {'name': 'Collection'},
//           )['name'];

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductListScreen(
//           categoryId: collectionId == 'featured' ? null : collectionId,
//           categoryName: categoryName,
//         ),
//       ),
//     );
//   }

//   Widget _buildBannerItem(Map<String, dynamic> item) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: Stack(
//         children: [
//           // Background image with error handling
//           Positioned.fill(
//             child: Image.network(
//               item['imageUrl'],
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 color: Colors.grey[200],
//                 child: const Center(
//                   child: Icon(Icons.error, size: 50),
//                 ),
//               ),
//             ),
//           ),

//           // Gradient overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//                 ),
//               ),
//             ),
//           ),

//           // Content
//           Positioned(
//             left: 24,
//             right: 24,
//             bottom: 24,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['subtitle'],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   item['title'],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: () => _handleExplore(item['collectionId']),
//                   child: const Text('EXPLORE'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   Widget _buildCollectionCard(String title, String imageUrl, String categoryId) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductListScreen(
//               categoryName: title,
//               categoryId: categoryId,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 140,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[100],
//       ),
//       child: Image.network(
//         logoUrl,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselSection() {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.4,
//         child: Stack(
//           children: [
//             PageView.builder(
//               controller: _bannerController,
//               itemCount: _carouselItems.length,
//               onPageChanged: (index) {
//                 setState(() => _currentBannerIndex = index);
//               },
//               itemBuilder: (context, index) {
//                 return _buildBannerItem(_carouselItems[index]);
//               },
//             ),
//             if (_carouselItems.length > 1)
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(_carouselItems.length, (index) {
//                     return Container(
//                       width: 8,
//                       height: 8,
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _currentBannerIndex == index
//                             ? Colors.white
//                             : Colors.white.withOpacity(0.5),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               _products.isEmpty ? Icons.info_outline : Icons.error_outline,
//               size: 64,
//               color: _products.isEmpty ? Colors.blue : Colors.red,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               _products.isEmpty ? 'No Featured Products' : 'Error Loading Data',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage ?? 'An unknown error occurred',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             if (_products.isEmpty) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Check back later for featured products',
//                 textAlign: TextAlign.center,
//               ),
//             ],
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _initializeData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingWidget() {
//     return const Center(child: CircularProgressIndicator());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text('WATCH HUB'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(context: context, delegate: SearchScreen());
//             },
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Consumer<CartProvider>(
//                   builder: (context, cart, child) {
//                     if (cart.items.isEmpty) return const SizedBox.shrink();
//                     return Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${cart.items.length}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _errorMessage != null
//           ? _buildErrorWidget()
//           : _isLoading
//               ? _buildLoadingWidget()
//               : CustomScrollView(
//                   slivers: [
//                     _buildCarouselSection(),

//                     // Dynamic Categories Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 24,
//                         horizontal: 16,
//                       ),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'CURATED COLLECTIONS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             SizedBox(
//                               height: 160,
//                               child: _categories.isEmpty
//                                   ? const Center(child: CircularProgressIndicator())
//                                   : ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: [
//                                         _buildCollectionCard(
//                                           'All',
//                                           'https://th.bing.com/th/id/R.1ad1f7c0dcf9465f8e62bebc5e21ed37?rik=v0eOQoEB4UasEg&pid=ImgRaw&r=0',
//                                           'All',
//                                         ),
//                                         ..._categories.map(
//                                           (category) => _buildCollectionCard(
//                                             category['name'],
//                                             category['cat_img'],
//                                             category['id'],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Featured Products Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverToBoxAdapter(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'FEATURED TIMEPIECES',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const ProductListScreen(
//                                       categoryId: null,
//                                       categoryName: 'Featured Products',
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: const Text('VIEW ALL'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: _products.isEmpty
//                           ? SliverToBoxAdapter(
//                               child: Container(
//                                 height: 200,
//                                 alignment: Alignment.center,
//                                 child: const Text('No featured products available'),
//                               ),
//                             )
//                           : SliverGrid(
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.75,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                               ),
//                               delegate: SliverChildBuilderDelegate(
//                                 (context, index) => ProductCard(
//                                   watch: _products[index],
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ProductDetailScreen(
//                                           product: _products[index].toMap(),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 childCount: _products.length,
//                               ),
//                             ),
//                     ),

//                     // Brands Section
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 32,
//                         horizontal: 16,
//                       ),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'OUR BRANDS',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               child: GridView.count(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 crossAxisCount: 3,
//                                 childAspectRatio: 2,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                                 children: [
//                                   _buildBrandLogo(
//                                     'Rolex',
//                                     'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Patek Philippe',
//                                     'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Omega',
//                                     'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Jaeger-LeCoultre',
//                                     'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Samsung',
//                                     'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
//                                   ),
//                                   _buildBrandLogo(
//                                     'Audemars Piguet',
//                                     'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }
// }

////////////////////////////
///
///
///
///
///
///// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/models/watch_model.dart';
// import '/models/app_state.dart';
// import '/screens/product_detail_screen.dart';
// import '/screens/product_list_screen.dart';
// import '/screens/cart_screen.dart';
// import '/widgets/product_card.dart';
// import '/widgets/app_drawer.dart';
// import '../screens/search_screen.dart';
// import '/widgets/auth_dialog.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Watch> featuredWatches = [
//     Watch(
//       id: '1',
//       name: 'Royal Chronograph',
//       brand: 'Patek Philippe',
//       price: 45999.99,
//       description: 'Exquisite Swiss craftsmanship with perpetual calendar',
//       images: ['https://th.bing.com/th/id/R.8cd1f1f973c81eaf0161d004dcf8c2d0?rik=M%2fyNvUN9m3Yd7Q&pid=ImgRaw&r=0'],
//       rating: 4.9,
//       reviewCount: 42,
//       features: ['18k white gold', 'Sapphire crystal', 'Hand-engraved'],
//       category: 'Luxury',
//     ),
//     Watch(
//       id: '2',
//       name: 'Submariner Pro',
//       brand: 'Rolex',
//       price: 12500.00,
//       description: 'Iconic diving watch with ceramic bezel',
//       images: [
//         'https://content.rolex.com/dam/2022-11/upright-bba-with-shadow/m126610ln-0001.png',
//       ],
//       rating: 4.8,
//       reviewCount: 128,
//       features: ['300m water resistant', 'Oystersteel', 'Chronometer'],
//       category: 'Diver',
//     ),
//     Watch(
//       id: '3',
//       name: 'Galaxy Watch 5',
//       brand: 'Samsung',
//       price: 349.99,
//       description: 'Advanced smartwatch with health monitoring',
//       images: [
//         'https://th.bing.com/th/id/R.935a20a2bb18bc790196f30cf55d07f3?rik=QOywkdQt%2fdxSnQ&riu=http%3a%2f%2fwww.meyers-watches.com%2fwp-content%2fuploads%2f2016%2f11%2fLBA-ANe.png&ehk=2bRo%2fQrVmsPRhBHvjx%2bwGHU%2bpsNctlcy98%2fLlySdTJ8%3d&risl=&pid=ImgRaw&r=0',
//       ],
//       rating: 4.5,
//       reviewCount: 342,
//       features: ['BioActive sensor', 'Sleep tracking', 'Fast charging'],
//       category: 'Smart',
//     ),
//     Watch(
//       id: '4',
//       name: 'Heritage Automatic',
//       brand: 'Jaeger-LeCoultre',
//       price: 12500.00,
//       description: 'Classic dress watch with exhibition case back',
//       images: [
//         'https://th.bing.com/th/id/R.b6216167a10cba483407a966dacbb8ee?rik=A9Yemyxnz9%2fqfA&pid=ImgRaw&r=0',
//       ],
//       rating: 4.7,
//       reviewCount: 56,
//       features: ['39mm case', '70h power reserve', 'Alligator strap'],
//       category: 'Classic',
//     ),
//     Watch(
//       id: '5',
//       name: 'Speedmaster Moonwatch',
//       brand: 'Omega',
//       price: 6300.00,
//       description: 'The first watch worn on the moon',
//       images: [
//         'https://pngimg.com/uploads/watches/watches_PNG9866.png',
//       ],
//       rating: 4.9,
//       reviewCount: 214,
//       features: ['Manual winding', 'Hesalite crystal', 'Moon history'],
//       category: 'Sports',
//     ),
//   ];

//   final PageController _bannerController = PageController();
//   int _currentBannerIndex = 0;
//   bool _authDialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     _startBannerTimer();
    
//     // Check auth status after first frame is rendered
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         final isLoggedIn = context.read<AppState>().isLoggedIn;
//         if (!isLoggedIn && !_authDialogShown) {
//           _showAuthDialog(context);
//           _authDialogShown = true;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     super.dispose();
//   }

//   void _startBannerTimer() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (_bannerController.hasClients) {
//         if (_currentBannerIndex < 2) {
//           _bannerController.nextPage(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         } else {
//           _bannerController.animateToPage(
//             0,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//         }
//         _startBannerTimer();
//       }
//     });
//   }

//   void _showAuthDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const AuthDialog(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text(
//           'WATCH HUB',
//           style: TextStyle(
//             fontWeight: FontWeight.w300,
//             letterSpacing: 4.0,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               showSearch(context: context, delegate: SearchScreen());
//             },
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart, color: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CartScreen()),
//                   );
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   constraints: const BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Text(
//                     '3',
//                     style: TextStyle(color: Colors.black, fontSize: 8),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // Hero Banner with Parallax Effect
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: size.height * 0.4,
//               child: Stack(
//                 children: [
//                   PageView(
//                     controller: _bannerController,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentBannerIndex = index;
//                       });
//                     },
//                     children: [
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?ixlib=rb-4.0.3',
//                         'SUMMER COLLECTION',
//                         'UP TO 40% OFF',
//                       ),
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1524805444758-089113d48a6d?ixlib=rb-4.0.3',
//                         'NEW ARRIVALS',
//                         'LUXURY TIMEPIECES',
//                       ),
//                       _buildBannerItem(
//                         'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                         'LIMITED EDITION',
//                         'EXCLUSIVE MODELS',
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(3, (index) {
//                         return Container(
//                           width: 8,
//                           height: 8,
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _currentBannerIndex == index
//                                 ? Colors.amber
//                                 : Colors.white.withOpacity(0.5),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Featured Collections
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'CURATED COLLECTIONS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 160,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         _buildCollectionCard(
//                           context,
//                           'Luxury Timepieces',
//                           'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3',
//                           Colors.blueGrey[900]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Sport Watches',
//                           'https://images.unsplash.com/photo-1551818255-e6e10975bc17?ixlib=rb-4.0.3',
//                           Colors.brown[800]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Smart Wearables',
//                           'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-4.0.3',
//                           Colors.indigo[900]!,
//                         ),
//                         _buildCollectionCard(
//                           context,
//                           'Vintage Classics',
//                           'https://images.unsplash.com/photo-1539874754764-5a96559165b0?ixlib=rb-4.0.3',
//                           Colors.grey[800]!,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Featured Watches
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'FEATURED TIMEPIECES',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductListScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'VIEW ALL',
//                       style: TextStyle(color: Colors.amber),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => ProductCard(
//                   watch: featuredWatches[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailScreen(watch: featuredWatches[index]),
//                       ),
//                     );
//                   },
//                 ),
//                 childCount: featuredWatches.length,
//               ),
//             ),
//           ),

//           // Brands Section
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'OUR BRANDS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: GridView.count(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       crossAxisCount: 3,
//                       childAspectRatio: 2,
//                       mainAxisSpacing: 16,
//                       crossAxisSpacing: 16,
//                       children: [
//                         _buildBrandLogo(
//                           'Rolex',
//                           'https://th.bing.com/th/id/R.25cc7d7a8e086efc0e8f54275bb53cbf?rik=kXaJ9fnwX%2ftCVw&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Patek Philippe',
//                           'https://th.bing.com/th/id/R.f6bc605bc73030bd861f66fa7a4a0d2a?rik=nzAJQqX13IHewA&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Omega',
//                           'https://th.bing.com/th/id/R.8179eb282d902c1b76808bce4c6110b8?rik=lzCG2YQ5zI1gBQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f0576%2f4867%2f7034%2fcollections%2flogo-omega-sa-watch-jewellery-png-favpng-EyzrquB5FFgVgb3bdJBUnE824.jpg%3fv%3d1642633830&ehk=tkIkn6bTC1Lfpt7tiGgfNPbOMu6meGzBkRWNUbrRAzo%3d&risl=&pid=ImgRaw&r=0',
//                         ),
//                         _buildBrandLogo(
//                           'Jaeger-LeCoultre',
//                           'https://tse3.mm.bing.net/th/id/OIP.myfnI68enxYi_X0GWVMebAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                         _buildBrandLogo(
//                           'Samsung',
//                           'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/2560px-Samsung_Logo.svg.png',
//                         ),
//                         _buildBrandLogo(
//                           'Audemars Piguet',
//                           'https://th.bing.com/th/id/R.1a34234e848b472f79c69c0fb996ff11?rik=9m6OgdurcdKXXA&pid=ImgRaw&r=0',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Testimonials
//           SliverPadding(
//             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'CLIENT TESTIMONIALS',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 200,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         _buildTestimonialCard(
//                           'Alex Johnson',
//                           'The Patek Philippe I purchased is absolutely stunning. The craftsmanship is unparalleled.',
//                           '⭐⭐⭐⭐⭐',
//                           'https://tse2.mm.bing.net/th/id/OIP.F6V_4Q0E2AJH03hlRQxT-wHaEK?rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                         _buildTestimonialCard(
//                           'Sarah Williams',
//                           'Excellent customer service and fast delivery. My new Rolex is perfect!',
//                           '⭐⭐⭐⭐⭐',
//                           'https://www.brewin.co.uk/wp-content/uploads/sites/10/2024/01/Giorgio-De-Lucia.jpg?w=2000',
//                         ),
//                         _buildTestimonialCard(
//                           'Michael Chen',
//                           'Great selection of luxury watches. Found exactly what I was looking for.',
//                           '⭐⭐⭐⭐',
//                           'https://tse1.mm.bing.net/th/id/OIP.LyA9PqrYUacVfp_wpJEnSAHaIQ?w=535&h=596&rs=1&pid=ImgDetMain&o=7&rm=3',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBannerItem(String imageUrl, String subtitle, String title) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               subtitle,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//                 letterSpacing: 2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ProductListScreen(category: 'Featured'),
//                   ),
//                 );
//               },
//               child: const Text('EXPLORE'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCollectionCard(
//     BuildContext context,
//     String title,
//     String imageUrl,
//     Color color,
//   ) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductListScreen(category: title),
//           ),
//         );
//       },
//       child: Container(
//         width: 140,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [color.withOpacity(0.8), Colors.transparent],
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBrandLogo(String brand, String logoUrl) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Image.network(
//         logoUrl,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => Center(
//           child: Text(
//             brand.split(' ').first,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTestimonialCard(
//     String name,
//     String review,
//     String stars,
//     String avatarUrl,
//   ) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: NetworkImage(avatarUrl),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     stars,
//                     style: const TextStyle(color: Colors.amber, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             review,
//             style: const TextStyle(
//               fontSize: 14,
//               fontStyle: FontStyle.italic,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }