// class Watch {
//   final String id;
//   final String name;
//   final String brand;
//   final double price;
//   final String description;
//   final List<String> images;
//   final double rating;
//   final int reviewCount;
//   final List<String> features;
//   final String category;

//   Watch({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.price,
//     required this.description,
//     required this.images,
//     this.rating = 0.0,
//     this.reviewCount = 0,
//     required this.features,
//     required this.category,
//   });

//   // For Firebase integration later, add fromMap and toMap methods
//   factory Watch.fromMap(Map<String, dynamic> map) {
//     return Watch(
//       id: map['id'] ?? '',
//       name: map['name'] ?? '',
//       brand: map['brand'] ?? '',
//       price: (map['price'] ?? 0).toDouble(),
//       description: map['description'] ?? '',
//       images: List<String>.from(map['images'] ?? []),
//       rating: (map['rating'] ?? 0).toDouble(),
//       reviewCount: map['reviewCount'] ?? 0,
//       features: List<String>.from(map['features'] ?? []),
//       category: map['category'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'brand': brand,
//       'price': price,
//       'description': description,
//       'images': images,
//       'rating': rating,
//       'reviewCount': reviewCount,
//       'features': features,
//       'category': category,
//     };
//   }
// }

// class Watch {
//   final String id;
//   final String name;
//   final String brand;
//   final double price;
//   final String description;
//   final String imageUrl;
//   final List<String>? images;
//   final double rating;
//   final int reviewCount;
//   final List<String> features;
//   final String category;

//   Watch({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.price,
//     required this.description,
//     required this.imageUrl,
//     this.images,
//     this.rating = 0.0,
//     this.reviewCount = 0,
//     required this.features,
//     required this.category,
//   });

//   // Factory constructor for Firebase integration
//   factory Watch.fromMap(Map<String, dynamic> map) {
//     return Watch(
//       id: map['id'] ?? '',
//       name: map['b_name'] ?? 'No Name',  // Matches your Firebase field
//       brand: map['brand'] ?? 'Unknown Brand',
//       price: (map['price'] as num?)?.toDouble() ?? 0.0,
//       description: map['b_desc'] ?? 'No Description',  // Matches your Firebase field
//       imageUrl: map['b_img'] ?? '',  // Primary image
//       images: map['images'] != null 
//           ? List<String>.from(map['images'])
//           : null,
//       rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
//       reviewCount: map['reviewCount'] as int? ?? 0,
//       features: map['features'] != null
//           ? List<String>.from(map['features'])
//           : <String>[],
//       category: map['category'] ?? 'Uncategorized',
//     );
//   }

//   // Convert to map for Firebase
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'b_name': name,  // Matches your Firebase field
//       'brand': brand,
//       'price': price,
//       'b_desc': description,  // Matches your Firebase field
//       'b_img': imageUrl,  // Primary image
//       if (images != null) 'images': images,
//       'rating': rating,
//       'reviewCount': reviewCount,
//       'features': features,
//       'category': category,
//     };
//   }

//   // Helper method to get the first image (or placeholder)
//   String get displayImage => imageUrl.isNotEmpty 
//       ? imageUrl 
//       : 'https://via.placeholder.com/150';

//   // Helper method to get all images
//   List<String> get allImages => images ?? [displayImage];
// }
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/foundation.dart';

class Watch {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final bool isOnSale;
  final int reviewCount;
  final List<String> features;
  final String category;
  final bool isFeatured;
  final bool isNew;
  final DateTime createdAt;
  final int stockQuantity;
  final List<String> availableColors;
  final String movementType;
  final String caseMaterial;
  final String strapMaterial;
  final double caseSize;
  final bool isWaterResistant;
  final int waterResistanceDepth;
  final String warrantyPeriod;

  const Watch({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.images = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.features = const [],
    required this.category,
    this.isFeatured = false,
    this.isNew = false,
    required this.createdAt,
    this.stockQuantity = 0,
    this.availableColors = const [],
    this.movementType = 'Automatic',
    this.caseMaterial = 'Stainless Steel',
    this.strapMaterial = 'Leather',
    this.caseSize = 42.0,
    this.isWaterResistant = true,
    this.waterResistanceDepth = 50,
      this.isOnSale = false,
    this.warrantyPeriod = '2 Years',
  });

  factory Watch.fromMap(Map<String, dynamic> map) {
    return Watch(
      id: map['id']?.toString() ?? '',
      name: map['b_name']?.toString() ?? 'Unnamed Watch',
      brand: map['brand']?.toString() ?? 'Unknown Brand',
      price: _parseDouble(map['price']),
      description: map['b_desc']?.toString() ?? 'No description available',
      imageUrl: map['b_img']?.toString() ?? '',
      images: map['images'] != null 
          ? List<String>.from(map['images'].map((x) => x.toString()))
          : [],
      rating: _parseDouble(map['rating']),
      reviewCount: _parseInt(map['reviewCount']),
      features: map['features'] != null
          ? List<String>.from(map['features'].map((x) => x.toString()))
          : [],
      category: map['category']?.toString() ?? 'Uncategorized',
      isFeatured: map['isFeatured'] as bool? ?? false,
      isNew: map['isNew'] as bool? ?? false,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      stockQuantity: _parseInt(map['stockQuantity']),
      availableColors: map['availableColors'] != null
          ? List<String>.from(map['availableColors'].map((x) => x.toString()))
          : [],
      movementType: map['movementType']?.toString() ?? 'Automatic',
      caseMaterial: map['caseMaterial']?.toString() ?? 'Stainless Steel',
      strapMaterial: map['strapMaterial']?.toString() ?? 'Leather',
      caseSize: _parseDouble(map['caseSize']),
      isWaterResistant: map['isWaterResistant'] as bool? ?? false,
      waterResistanceDepth: _parseInt(map['waterResistanceDepth']),
      warrantyPeriod: map['warrantyPeriod']?.toString() ?? '2 Years',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'b_name': name,
      'brand': brand,
      'price': price,
      'b_desc': description,
      'b_img': imageUrl,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'features': features,
      'category': category,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'createdAt': Timestamp.fromDate(createdAt),
      'stockQuantity': stockQuantity,
      'availableColors': availableColors,
      'movementType': movementType,
      'caseMaterial': caseMaterial,
      'strapMaterial': strapMaterial,
      'caseSize': caseSize,
      'isWaterResistant': isWaterResistant,
      'waterResistanceDepth': waterResistanceDepth,
      'warrantyPeriod': warrantyPeriod,
    };
  }

  String get displayImage => imageUrl.isNotEmpty 
      ? imageUrl 
      : 'https://via.placeholder.com/500?text=${Uri.encodeComponent(name)}';

  List<String> get allImages => images.isNotEmpty ? images : [displayImage];

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}...';
  }

  String get ratingStars {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;
    return '${'★' * fullStars}${hasHalfStar ? '½' : ''}${'☆' * (5 - fullStars - (hasHalfStar ? 1 : 0))}';
  }

  bool get inStock => stockQuantity > 0;

  String get stockStatus {
    if (stockQuantity > 10) return 'In Stock';
    if (stockQuantity > 0) return 'Only $stockQuantity left';
    return 'Out of Stock';
  }

  Watch copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? description,
    String? imageUrl,
    List<String>? images,
    double? rating,
    int? reviewCount,
    List<String>? features,
    String? category,
    bool? isFeatured,
    bool? isNew,
    DateTime? createdAt,
    int? stockQuantity,
    List<String>? availableColors,
    String? movementType,
    String? caseMaterial,
    String? strapMaterial,
    double? caseSize,
    bool? isWaterResistant,
    int? waterResistanceDepth,
    String? warrantyPeriod,
  }) {
    return Watch(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      features: features ?? this.features,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      createdAt: createdAt ?? this.createdAt,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      availableColors: availableColors ?? this.availableColors,
      movementType: movementType ?? this.movementType,
      caseMaterial: caseMaterial ?? this.caseMaterial,
      strapMaterial: strapMaterial ?? this.strapMaterial,
      caseSize: caseSize ?? this.caseSize,
      isWaterResistant: isWaterResistant ?? this.isWaterResistant,
      waterResistanceDepth: waterResistanceDepth ?? this.waterResistanceDepth,
      warrantyPeriod: warrantyPeriod ?? this.warrantyPeriod,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Watch &&
        other.id == id &&
        other.name == name &&
        other.brand == brand &&
        other.price == price &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        listEquals(other.images, images) &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        listEquals(other.features, features) &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      brand,
      price,
      description,
      imageUrl,
      Object.hashAll(images),
      rating,
      reviewCount,
      Object.hashAll(features),
      category,
    );
  }

  @override
  String toString() {
    return 'Watch(id: $id, name: $name, brand: $brand, price: $price, category: $category)';
  }
}