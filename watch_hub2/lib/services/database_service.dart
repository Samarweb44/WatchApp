import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/watch_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Watch>> get products {
    return _firestore
        .collection('products')
        .snapshots()
        .map(_productsFromSnapshot);
  }

  List<Watch> _productsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Watch.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> addProduct(Watch product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(String id, Watch product) async {
    await _firestore.collection('products').doc(id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}