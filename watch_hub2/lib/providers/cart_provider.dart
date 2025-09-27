import 'package:flutter/foundation.dart';
import '/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(String watchId, String name, double price, String imageUrl) {
    final index = _items.indexWhere((item) => item.watchId == watchId);
    if (index >= 0) {
      // Item already exists, increase quantity using copyWith
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      // Add new item
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          watchId: watchId,
          name: name,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void removeSingleItem(String watchId) {
    final existingItemIndex = _items.indexWhere((item) => item.watchId == watchId);
    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex] = _items[existingItemIndex].copyWith(
          quantity: _items[existingItemIndex].quantity - 1,
        );
      } else {
        _items.removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}