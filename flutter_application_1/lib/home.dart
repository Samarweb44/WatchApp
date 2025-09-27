// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/admin.dart';
// import 'package:flutter_application_1/category.dart';
// import 'package:flutter_application_1/orders.dart';
// import 'package:flutter_application_1/read_data.dart';
// import 'package:flutter_application_1/subscribers.dart';
// import 'package:flutter_application_1/wishlist.dart';
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

// // ✅ Correct import for your product list page
// import 'product_list.dart';
// // You can uncomment these when you create these pages
// // import 'pages/user_list.dart';
// // import 'pages/order_list.dart';
// // import 'pages/review_list.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const AdminPanelApp());
// }

// class AdminPanelApp extends StatelessWidget {
//   const AdminPanelApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Admin Panel',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const AdminDashboard(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int _currentIndex = 0;

//   // ✅ Tab pages for each section
//   final List<Widget> tabs = [
//      const MyApp(),
//     const ProductsAdminScreen(),
//     const Categorydata(),
//     const FetchData(),
//     const Orders(),
//     const Subscribers(),
//     const Wishlist(),
//     // const Center(child: Text("👤 Users")), // Later replace with UserListPage()
//     // const Center(child: Text("🛒 Orders")), // Later replace with OrderListPage()
//     // const Center(child: Text("⭐ Reviews")), // Later replace with ReviewListPage()
//   ];

//   final List<String> titles = ["Products", "Users", "Orders", "Reviews"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text(titles[_currentIndex])),
//       body: tabs[_currentIndex], // ✅ dynamic tab view

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
        
//              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
//           BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits), label: 'Products'),
//             BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
//           BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'User Management'),

         

//           // BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Reviews'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.reviews),
//             label: 'Subscribers',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.heat_pump_rounded), label: 'Wishlist'),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/admin.dart';
// import 'package:flutter_application_1/category.dart';
// import 'package:flutter_application_1/orders.dart';
// import 'package:flutter_application_1/read_data.dart';
// import 'package:flutter_application_1/subscribers.dart';
// import 'package:flutter_application_1/wishlist.dart';
// import 'package:flutter_application_1/user_management_screen.dart'; // Add this import
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'product_list.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const AdminPanelApp());
// }

// class AdminPanelApp extends StatelessWidget {
//   const AdminPanelApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Admin Panel',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         appBarTheme: const AppBarTheme(
//           color: Color.fromARGB(255, 4, 66, 85),
//           iconTheme: IconThemeData(color: Colors.white),
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: const AdminDashboard(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int _currentIndex = 0;

//   final List<Widget> tabs = [
//     const MyApp(), // Home/Dashboard
//     const ProductsAdminScreen(), // Products
//     const Categorydata(), // Categories
//     const FetchData(), // Basic Users List
//     const OrderManagementScreen(), // User Management (detailed)
//     const Subscribers(), // Subscribers
//     const Wishlist(), // Wishlist
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: tabs[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: const Color.fromARGB(255, 4, 66, 85),
//         unselectedItemColor: Colors.grey,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_bag),
//             label: 'Products',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people_outline),
//             label: 'Users',
//           ),
          
//           BottomNavigationBarItem(
//             icon: Icon(Icons.manage_accounts),
//             label: 'User Mgmt',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.subscriptions),
//             label: 'Subscribers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Wishlist',
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin.dart';
import 'package:flutter_application_1/category.dart';
import 'package:flutter_application_1/orders.dart';
import 'package:flutter_application_1/read_data.dart';
import 'package:flutter_application_1/subscribers.dart';
import 'package:flutter_application_1/wishlist.dart';
import 'package:flutter_application_1/user_management_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'product_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.yellow[700],
        canvasColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.yellow[700],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          elevation: 4,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.yellow[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.yellow[700])
            .copyWith(background: Colors.black),
      ),
      home: const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    const MyApp(),
    const ProductsAdminScreen(),
    const Categorydata(),
    const FetchData(),
    const OrderManagementScreen(),
    const Subscribers(),
    const Wishlist(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'User Mgmt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
      ),
    );
  }
}
