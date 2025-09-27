class CartItem {
  final String id;
  final String watchId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.watchId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? watchId,
    String? name,
    int? quantity,
    double? price,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      watchId: watchId ?? this.watchId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}