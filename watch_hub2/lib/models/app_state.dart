// import 'package:flutter/foundation.dart';
// import '/models/watch_model.dart';

// class AppState with ChangeNotifier {
//   final List<Watch> _cart = [];
//   final List<Watch> _wishlist = [];
//   final List<Watch> _allWatches = [];

//   List<Watch> get cart => _cart;
//   List<Watch> get wishlist => _wishlist;
//   List<Watch> get allWatches => _allWatches;

//   AppState() {
//     // Initialize with sample data
//     _allWatches.addAll([
//       Watch(
//         id: '1',
//         name: 'Chronograph Classic',
//         brand: 'TAG Heuer',
//         price: 2999.99,
//         description: 'Premium chronograph watch with leather strap',
//         images: [
//           'https://m.media-amazon.com/images/I/71z5VSuL3JL._AC_UF1000,1000_QL80_.jpg',
//         ],
//         rating: 4.5,
//         reviewCount: 128,
//         features: ['Water resistant', 'Sapphire crystal', 'Automatic movement'],
//         category: 'Luxury',
//       ),
//        Watch(
//         id: '2',
//         name: 'Royal Chronograph',
//         brand: 'PATEK PHILIPPE',
//         price: 2999.99,
//         description: 'Premium chronograph watch with leather strap',
//         images: [
//           'https://th.bing.com/th/id/R.69d1a145d71c7c3e9d039784a15d6749?rik=6gPTIZqyz%2ft%2fGA&pid=ImgRaw&r=0',
//         ],
//         rating: 4.5,
//         reviewCount: 128,
//         features: ['Water resistant', 'Sapphire crystal', 'Automatic movement'],
//         category: 'Luxury',
//       ),
//       // Add all other watches here...
//     ]);
//   }

//   // User authentication state
//   bool _isLoggedIn = false;

//   bool get isLoggedIn => _isLoggedIn;

//   void login() {
//     _isLoggedIn = true;
//     notifyListeners();
//   }

//   void logout() {
//     _isLoggedIn = false;
//     notifyListeners();
//   }

//   void addToCart(Watch watch) {
//     _cart.add(watch);
//     notifyListeners();
//   }

//   void removeFromCart(Watch watch) {
//     _cart.remove(watch);
//     notifyListeners();
//   }

//   void toggleWishlist(Watch watch) {
//     if (_wishlist.contains(watch)) {
//       _wishlist.remove(watch);
//     } else {
//       _wishlist.add(watch);
//     }
//     notifyListeners();
//   }

//   bool isInWishlist(Watch watch) {
//     return _wishlist.contains(watch);
//   }

//   void clearWishlist() {
//     _wishlist.clear();
//     notifyListeners();
//   }
// }

// import 'package:flutter/foundation.dart';
// import '/models/watch_model.dart';

// class AppState with ChangeNotifier {
//   final List<Watch> _cart = [];
//   final List<Watch> _wishlist = [];
//   final List<Watch> _allWatches = [];

//   List<Watch> get cart => _cart;
//   List<Watch> get wishlist => _wishlist;
//   List<Watch> get allWatches => _allWatches;

//   AppState() {
//     // Initialize with comprehensive watch data
//     _allWatches.addAll([
//       // Luxury Watches
     
//     ]);
//   }

//   // User authentication state
//   bool _isLoggedIn = false;

//   bool get isLoggedIn => _isLoggedIn;

//   void login() {
//     _isLoggedIn = true;
//     notifyListeners();
//   }

//   void logout() {
//     _isLoggedIn = false;
//     notifyListeners();
//   }

//   void addToCart(Watch watch) {
//     _cart.add(watch);
//     notifyListeners();
//   }

//   void removeFromCart(Watch watch) {
//     _cart.remove(watch);
//     notifyListeners();
//   }

//   void toggleWishlist(Watch watch) {
//     if (_wishlist.contains(watch)) {
//       _wishlist.remove(watch);
//     } else {
//       _wishlist.add(watch);
//     }
//     notifyListeners();
//   }

//   bool isInWishlist(Watch watch) {
//     return _wishlist.contains(watch);
//   }

//   void clearWishlist() {
//     _wishlist.clear();
//     notifyListeners();
//   }
// }

// import 'package:flutter/foundation.dart';
// import '/models/watch_model.dart';

// class AppState with ChangeNotifier {
//   final List<Watch> _cart = [];
//   final List<Watch> _wishlist = [];
//   List<Watch> _allWatches = []; // Loaded from Firebase

//   List<Watch> get cart => _cart;
//   List<Watch> get wishlist => _wishlist;
//   List<Watch> get allWatches => _allWatches;

//   // ✅ Add this getter to expose watches as List<Map> for compatibility
//   List<Map<String, dynamic>> get products =>
//       _allWatches.map((watch) => watch.toMap()).toList();

//   // User authentication state
//   bool _isLoggedIn = false;
//   bool get isLoggedIn => _isLoggedIn;

//   // Load watches from Firebase
//   Future<void> loadWatches(List<Map<String, dynamic>> products) async {
//     _allWatches = products.map((product) => Watch.fromMap(product)).toList();
//     notifyListeners();
//   }

//   void login() {
//     _isLoggedIn = true;
//     notifyListeners();
//   }

//   void logout() {
//     _isLoggedIn = false;
//     _cart.clear();
//     _wishlist.clear();
//     notifyListeners();
//   }

//   void addToCart(Watch watch) {
//     if (!_cart.any((item) => item.id == watch.id)) {
//       _cart.add(watch);
//       notifyListeners();
//     }
//   }

//   void removeFromCart(Watch watch) {
//     _cart.removeWhere((item) => item.id == watch.id);
//     notifyListeners();
//   }

//   void toggleWishlist(Watch watch) {
//     if (_wishlist.any((item) => item.id == watch.id)) {
//       _wishlist.removeWhere((item) => item.id == watch.id);
//     } else {
//       _wishlist.add(watch);
//     }
//     notifyListeners();
//   }

//   bool isInWishlist(Watch watch) {
//     return _wishlist.any((item) => item.id == watch.id);
//   }

//   void clearWishlist() {
//     _wishlist.clear();
//     notifyListeners();
//   }

//   double get cartTotal {
//     return _cart.fold(0, (sum, item) => sum + item.price);
//   }

//   int get cartItemCount {
//     return _cart.length;
//   }

//   void clearCart() {
//     _cart.clear();
//     notifyListeners();
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/watch_model.dart';

class AppState with ChangeNotifier {
  final List<Watch> _cart = [];
  final List<Watch> _wishlist = [];
  List<Watch> _allWatches = []; // Loaded from Firebase
   User? get currentUser => FirebaseAuth.instance.currentUser;

  List<Watch> get cart => _cart;
  List<Watch> get wishlist => _wishlist;
  List<Watch> get allWatches => _allWatches;

  // ✅ Add this getter to expose watches as List<Map> for compatibility
  List<Map<String, dynamic>> get products =>
      _allWatches.map((watch) => watch.toMap()).toList();

  // User authentication state
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Load watches from Firebase
  Future<void> loadWatches(List<Map<String, dynamic>> products) async {
    _allWatches = products.map((product) => Watch.fromMap(product)).toList();
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  // void logout() {
  //   _isLoggedIn = false;
  //   _cart.clear();
  //   clearWishlist(); // This now clears both locally and Firestore
  //   notifyListeners();
  // }

    Future<void> logout() async {
  try {
    
    await FirebaseAuth.instance.signOut();
    
    
    _isLoggedIn = false;
    _cart.clear();
    await clearWishlist(); 
    
    notifyListeners();
  } catch (e) {
    if (kDebugMode) {
      print('Logout error: $e');
    }
    rethrow; 
  }
}

  void addToCart(Watch watch) {
    if (!_cart.any((item) => item.id == watch.id)) {
      _cart.add(watch);
      notifyListeners();
    }
  }

  void removeFromCart(Watch watch) {
    _cart.removeWhere((item) => item.id == watch.id);
    notifyListeners();
  }

  // Toggle wishlist with Firestore sync
  Future<void> toggleWishlist(Watch watch) async {
    final userId = _user?.uid;
    if (userId == null) {
      // Optionally handle unauthenticated users here
      return;
    }

    final existingIndex = _wishlist.indexWhere((item) => item.id == watch.id);

    if (existingIndex >= 0) {
      // Remove from wishlist locally
      _wishlist.removeAt(existingIndex);

      // Remove from Firestore: find doc with userId & product id
      final snapshot = await _firestore
          .collection('wishlist')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: watch.id)
          .limit(1)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('wishlist').doc(doc.id).delete();
      }
    } else {
      // Add to wishlist locally
      _wishlist.add(watch);

      // Add to Firestore
      await _firestore.collection('wishlist').add({
        'userId': userId,
        'productId': watch.id,
        'b_name': watch.name,
        'price': watch.price.toString(),
        'b_img': watch.imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    notifyListeners();
  }

  bool isInWishlist(Watch watch) {
    return _wishlist.any((item) => item.id == watch.id);
  }

  // Clear wishlist locally and in Firestore for current user
  Future<void> clearWishlist() async {
    final userId = _user?.uid;
    if (userId != null) {
      try {
        final snapshot = await _firestore
            .collection('wishlist')
            .where('userId', isEqualTo: userId)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore.collection('wishlist').doc(doc.id).delete();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error clearing wishlist from Firestore: $e');
        }
      }
    }
    _wishlist.clear();
    notifyListeners();
  }

  double get cartTotal {
    return _cart.fold(0, (sum, item) => sum + item.price);
  }

  int get cartItemCount {
    return _cart.length;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
