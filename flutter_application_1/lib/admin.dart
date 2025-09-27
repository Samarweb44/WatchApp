// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/user_management_screen.dart';
// import 'category.dart';
// import 'firebase_options.dart';
// import 'orders.dart';
// import 'product_list.dart';
// import 'read_data.dart';
// import 'subscribers.dart';
// import 'wishlist.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }
// ///////homepage
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white),
//           bodySmall: TextStyle(color: Colors.white),
//         ),
//         appBarTheme: const AppBarTheme(
//           color: Color.fromARGB(255, 104, 193, 235),
//           iconTheme: IconThemeData(color: Colors.white),
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: AdminScreen(),
//     );
//   }
// }

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   int userCount = 0;
//   int productCount = 0;
//   int categoryCount = 0;
//   int orderCount = 0; // New variable for order count
//   Map<String, int> categoryBookCount =
//       {}; // To store the count of books per category
//   List<String> categoryIds =
//       []; // List to store category IDs for dynamic fetching
//   Map<String, String> categoryNames = {}; // To store category name by id

//   @override
//   void initState() {
//     super.initState();
//     fetchCounts();
//   }

//   // Fetch the count of users, books, categories, orders, and books in each category
//   void fetchCounts() async {
//     final userSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .get();
//     setState(() {
//       userCount = userSnapshot.docs.length;
//     });

//     final bookSnapshot = await FirebaseFirestore.instance
//         .collection('products_list')
//         .get();
//     setState(() {
//       productCount = bookSnapshot.docs.length;
//     });

//     final orderSnapshot = await FirebaseFirestore.instance
//         .collection('orders')
//         .get(); // Fetch orders count
//     setState(() {
//       orderCount = orderSnapshot.docs.length;
//     });

//     final categorySnapshot = await FirebaseFirestore.instance
//         .collection('categories')
//         .get();
//     setState(() {
//       categoryCount = categorySnapshot.docs.length;
//       categoryIds = categorySnapshot.docs
//           .map((doc) => doc.id)
//           .toList(); // Fetch category IDs
//     });

//     fetchCategoryCounts();
//     fetchCategoryNames();
//   }

//   void fetchCategoryCounts() async {
//     final bookSnapshot = await FirebaseFirestore.instance
//         .collection('products')
//         .get();
//     Map<String, int> categoryCounts = {};

//     for (var doc in bookSnapshot.docs) {
//       final categoryId =
//           doc['cat_id']; // Assuming 'cat_id' links to the category of the book

//       if (categoryCounts.containsKey(categoryId)) {
//         categoryCounts[categoryId] = categoryCounts[categoryId]! + 1;
//       } else {
//         categoryCounts[categoryId] = 1;
//       }
//     }

//     setState(() {
//       categoryBookCount = categoryCounts;
//     });
//   }

//   void fetchCategoryNames() async {
//     Map<String, String> names = {};
//     for (String categoryId in categoryIds) {
//       final categoryDoc = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(categoryId)
//           .get();
//       names[categoryId] = categoryDoc['category'];
//     }

//     setState(() {
//       categoryNames = names;
//     });
//   }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Admin Dashboard'),
//       backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//     ),
//     drawer: Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 4, 66, 85),
//             ),
//             child: Text(
//               'Admin Menu',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.people),
//             title: const Text('User Management'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const OrderManagementScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.shopping_cart),
//             title: const Text('Orders'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Orders()),
//               );
//             },
//           ),
//           // Add other navigation items as needed
//         ],
//       ),
//     ),

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Remove the banner section as requested
//             const SizedBox(height: 15),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildRectangularCard(
//                   imageUrl:
//                       'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325148/female_c88eyn.png', // Replace with your image URL
//                   title: 'Users',
//                   count: userCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl:
//                       'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325577/istockphoto-1340317860-612x612_ceo5bl.jpg', // Replace with your image URL
//                   title: 'Product_list',
//                   count: productCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl:
//                       'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325815/istockphoto-1413549071-612x612_rltnaz.jpg', // Replace with your image URL
//                   title: 'Categories',
//                   count: categoryCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl:
//                       'https://res.cloudinary.com/dlgodph8a/image/upload/v1741326764/images_e4d0kz.png', // Replace with your image URL
//                   title: 'Orders',
//                   count: orderCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//               ],
//             ),

//             // Second Row - Category Count Cards
//             Expanded(
//               child: GridView.builder(
//                 itemCount: categoryIds.length, // Dynamically load categories
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 20,
//                   childAspectRatio:
//                       2.1, // Adjusting aspect ratio for rectangular cards
//                 ),
//                 itemBuilder: (context, index) {
//                   String categoryId = categoryIds[index];
//                   String categoryName =
//                       categoryNames[categoryId] ?? 'Unknown Category';

//                   return InkWell(
//                     onTap: () {
//                       // Navigate to the books screen for the selected category
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BooksByCategoryScreen(
//                             categoryId: categoryId,
//                             catname: categoryName,
//                           ),
//                         ),
//                       );
//                     },
//                     child: _buildInfoCard(
//                       icon: Icons.category,
//                       title: 'Category: $categoryName',
//                       count: categoryBookCount[categoryId] ?? 0,
//                       gradientColors: [
//                         const Color.fromARGB(255, 255, 255, 255),
//                         const Color.fromARGB(255, 184, 230, 251),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRectangularCard({
//     required String imageUrl, // Accepting image URL
//     required String title,
//     required int count,
//     required Color color,
//   }) {
//     return Card(
//       color: color,
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Circular image
//             CircleAvatar(
//               radius: 30, // Adjust the size of the circular image
//               backgroundImage: NetworkImage(
//                 imageUrl,
//               ), // Use NetworkImage to load image from URL
//             ),
//             const SizedBox(height: 7),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '$count',
//               style: const TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to create regular cards (for category counts)
//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required int count,
//     required List<Color> gradientColors,
//   }) {
//     return Card(
//       elevation: gradientColors.isEmpty
//           ? 0
//           : 5, // Only add shadow to gradient cards
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: gradientColors.isEmpty
//               ? null
//               : LinearGradient(
//                   colors: gradientColors,
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//           borderRadius: BorderRadius.circular(19),
//           boxShadow: gradientColors.isEmpty
//               ? []
//               : [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.4),
//                     blurRadius: 6,
//                     spreadRadius: 2,
//                     offset: const Offset(4, 4),
//                   ),
//                 ],
//         ),
//         child: Center(
//           child: ListTile(
//             leading: Icon(icon, color: Colors.black, size: 32),
//             title: Text(
//               title,
//               style: const TextStyle(color: Colors.black, fontSize: 12),
//             ),
//             subtitle: Text(
//               count.toString(),
//               style: const TextStyle(color: Colors.black, fontSize: 28),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BooksByCategoryScreen extends StatelessWidget {
//   final String categoryId;
//   final String catname;
//   const BooksByCategoryScreen({
//     super.key,
//     required this.categoryId,
//     required this.catname,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Books in Category: $catname'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('products_list')
//             .where('cat_id', isEqualTo: categoryId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No books available in this category.'),
//             );
//           }
//           final books = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               var book = books[index];
//               return ListTile(
//                 title: Text(book['b_name']),
//                 subtitle: Text(book['b_desc']),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/contact_management_screen.dart';
import 'package:flutter_application_1/user_management_screen.dart';
import 'firebase_options.dart';
import 'orders.dart';
import 'subscribers.dart';
import 'wishlist.dart';
import 'read_data.dart';
import 'feedbacklist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          elevation: 0,
        ),
       cardTheme: const CardThemeData(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
),

      ),
      home: const AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int userCount = 0;
  int orderCount = 0;
  int subscriberCount = 0;
  int wishlistCount = 0;
  int feedbackCount = 0;
  int contactMessageCount = 0;
  int pendingMessagesCount = 0;
  String currentAdminEmail = 'Loading...';
  String currentAdminId = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchCounts();
    fetchCurrentAdminInfo();
    _setupMessageCountListener();
  }

  void _setupMessageCountListener() {
    FirebaseFirestore.instance.collection('contact_messages')
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .listen((snapshot) {
        setState(() {
          pendingMessagesCount = snapshot.size;
        });
      });
  }

  void fetchCurrentAdminInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(user.uid)
            .get();

        if (adminDoc.exists) {
          setState(() {
            currentAdminEmail = user.email ?? 'No email';
            currentAdminId = user.uid;
          });
        } else {
          await FirebaseAuth.instance.signOut();
          setState(() {
            currentAdminEmail = 'Not authorized';
            currentAdminId = 'Not authorized';
          });
        }
      } else {
        setState(() {
          currentAdminEmail = 'Not logged in';
          currentAdminId = 'Not logged in';
        });
      }
    } catch (e) {
      print('Error fetching admin info: $e');
      setState(() {
        currentAdminEmail = 'Error loading email';
        currentAdminId = 'Error loading ID';
      });
    }
  }

  void fetchCounts() async {
    try {
      final counts = await Future.wait([
        _getCollectionCount('users'),
        _getCollectionCount('orders'),
        _getCollectionCount('subscribers'),
        _getCollectionCount('wishlist'),
        _getCollectionCount('feedbacks'),
        _getCollectionCount('contact_messages'),
      ]);

      setState(() {
        userCount = counts[0];
        orderCount = counts[1];
        subscriberCount = counts[2];
        wishlistCount = counts[3];
        feedbackCount = counts[4];
        contactMessageCount = counts[5];
      });
    } catch (e) {
      print('Error fetching counts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<int> _getCollectionCount(String collectionName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error counting $collectionName: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminContactScreen()),
               ), ),
              if (pendingMessagesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      pendingMessagesCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchCounts();
              fetchCurrentAdminInfo();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),

      body: _buildBody(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Logged in as: ${currentAdminEmail.split('@')[0]}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        _buildDrawerItem(
          icon: Icons.people,
          title: 'Users',
          count: userCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FetchData()),
          ),
        ),
        _buildDrawerItem(
          icon: Icons.receipt,
          title: 'Orders',
          count: orderCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderManagementScreen()),
          ),
        ),
        _buildDrawerItem(
          icon: Icons.subscriptions,
          title: 'Subscribers',
          count: subscriberCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Subscribers()),
          ),
        ),
        _buildDrawerItem(
          icon: Icons.favorite,
          title: 'Wishlist',
          count: wishlistCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Wishlist()),
          ),
        ),
        _buildDrawerItem(
          icon: Icons.feedback,
          title: 'Feedback',
          count: feedbackCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackListScreen()),
          ),
        ),
        _buildDrawerItem(
          icon: Icons.contact_mail,
          title: 'Contact Messages',
          count: contactMessageCount,
          badgeCount: pendingMessagesCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminContactScreen()),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info, color: Colors.black),
          title: const Text('Admin Info'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: $currentAdminEmail'),
              Text('Admin ID: ${currentAdminId.substring(0, 8)}...'),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.black),
          title: const Text('Logout'),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    ),
  );
}


  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                icon: Icons.people,
                title: 'Users',
                count: userCount,
                color: Colors.amber[700]!,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FetchData())),
              ),
              _buildStatCard(
                icon: Icons.receipt,
                title: 'Orders',
                count: orderCount,
                color: Colors.black,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen())),
              ),
              _buildStatCard(
                icon: Icons.subscriptions,
                title: 'Subscribers',
                count: subscriberCount,
                color: Colors.amber[700]!,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Subscribers())),
              ),
              _buildStatCard(
                icon: Icons.favorite,
                title: 'Wishlist',
                count: wishlistCount,
                color: Colors.black,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Wishlist())),
              ),
              _buildStatCard(
                icon: Icons.feedback,
                title: 'Feedback',
                count: feedbackCount,
                color: Colors.amber[700]!,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackListScreen())),
              ),
              _buildStatCard(
                icon: Icons.contact_mail,
                title: 'Messages',
                count: contactMessageCount,
                badgeCount: pendingMessagesCount,
                color: Colors.black,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminContactScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int count,
    int badgeCount = 0,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeCount > 0)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    int badgeCount = 0,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'category.dart';
// import 'firebase_options.dart';
// import 'orders.dart';
// import 'product_list.dart';
// import 'read_data.dart';
// import 'subscribers.dart';
// import 'wishlist.dart';
// import 'feedbacklist_screen.dart'; 

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white),
//           bodySmall: TextStyle(color: Colors.white),
//         ),
//         appBarTheme: const AppBarTheme(
//           color: Color.fromARGB(255, 104, 193, 235),
//           iconTheme: IconThemeData(color: Colors.white),
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: const AdminScreen(),
//     );
//   }
// }

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   int userCount = 0;
//   int productCount = 0;
//   int categoryCount = 0;
//   int orderCount = 0;
//   List<String> categoryIds = [];
//   Map<String, int> categoryBookCount = {};
//   Map<String, String> categoryNames = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchCounts();
//   }

//   void fetchCounts() async {
//     final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
//     final bookSnapshot = await FirebaseFirestore.instance.collection('products_list').get();
//     final orderSnapshot = await FirebaseFirestore.instance.collection('orders').get();
//     final categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();

//     setState(() {
//       userCount = userSnapshot.docs.length;
//       productCount = bookSnapshot.docs.length;
//       orderCount = orderSnapshot.docs.length;
//       categoryCount = categorySnapshot.docs.length;
//       categoryIds = categorySnapshot.docs.map((doc) => doc.id).toList();
//     });

//     fetchCategoryCounts();
//     fetchCategoryNames();
//   }

//   void fetchCategoryCounts() async {
//     final bookSnapshot = await FirebaseFirestore.instance.collection('products').get();
//     Map<String, int> counts = {};

//     for (var doc in bookSnapshot.docs) {
//       final catId = doc['cat_id'];
//       counts[catId] = (counts[catId] ?? 0) + 1;
//     }

//     setState(() {
//       categoryBookCount = counts;
//     });
//   }

//   void fetchCategoryNames() async {
//     Map<String, String> names = {};
//     for (String catId in categoryIds) {
//       final doc = await FirebaseFirestore.instance.collection('categories').doc(catId).get();
//       names[catId] = doc['category'];
//     }

//     setState(() {
//       categoryNames = names;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Dashboard'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 15),
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               alignment: WrapAlignment.spaceEvenly,
//               children: [
//                 _buildRectangularCard(
//                   imageUrl: 'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325148/female_c88eyn.png',
//                   title: 'Users',
//                   count: userCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl: 'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325577/istockphoto-1340317860-612x612_ceo5bl.jpg',
//                   title: 'Product_list',
//                   count: productCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl: 'https://res.cloudinary.com/dlgodph8a/image/upload/v1741325815/istockphoto-1413549071-612x612_rltnaz.jpg',
//                   title: 'Categories',
//                   count: categoryCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl: 'https://res.cloudinary.com/dlgodph8a/image/upload/v1741326764/images_e4d0kz.png',
//                   title: 'Orders',
//                   count: orderCount,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                 ),
//                 _buildRectangularCard(
//                   imageUrl: 'https://cdn-icons-png.flaticon.com/512/10157/10157357.png',
//                   title: 'Feedback',
//                   count: 0,
//                   color: const Color.fromARGB(255, 4, 66, 85),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const FeedbackListScreen()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 itemCount: categoryIds.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 20,
//                   childAspectRatio: 2.1,
//                 ),
//                 itemBuilder: (context, index) {
//                   String catId = categoryIds[index];
//                   String catName = categoryNames[catId] ?? 'Unknown Category';
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BooksByCategoryScreen(
//                             categoryId: catId,
//                             catname: catName,
//                           ),
//                         ),
//                       );
//                     },
//                     child: _buildInfoCard(
//                       icon: Icons.category,
//                       title: 'Category: $catName',
//                       count: categoryBookCount[catId] ?? 0,
//                       gradientColors: [
//                         const Color.fromARGB(255, 255, 255, 255),
//                         const Color.fromARGB(255, 184, 230, 251),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRectangularCard({
//     required String imageUrl,
//     required String title,
//     required int count,
//     required Color color,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: color,
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
//               const SizedBox(height: 7),
//               Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               Text('$count', style: const TextStyle(color: Colors.white, fontSize: 20)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required int count,
//     required List<Color> gradientColors,
//   }) {
//     return Card(
//       elevation: gradientColors.isEmpty ? 0 : 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//           borderRadius: BorderRadius.circular(19),
//           boxShadow: gradientColors.isEmpty
//               ? []
//               : [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, spreadRadius: 2, offset: const Offset(4, 4))],
//         ),
//         child: Center(
//           child: ListTile(
//             leading: Icon(icon, color: Colors.black, size: 32),
//             title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 12)),
//             subtitle: Text(count.toString(), style: const TextStyle(color: Colors.black, fontSize: 28)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BooksByCategoryScreen extends StatelessWidget {
//   final String categoryId;
//   final String catname;

//   const BooksByCategoryScreen({super.key, required this.categoryId, required this.catname});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Books in Category: $catname'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance.collection('products_list').where('cat_id', isEqualTo: categoryId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No books available in this category.'));
//           }
//           final books = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               var book = books[index];
//               return ListTile(
//                 title: Text(book['b_name']),
//                 subtitle: Text(book['b_desc']),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }