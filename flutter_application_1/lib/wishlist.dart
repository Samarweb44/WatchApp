// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Wishlist extends StatefulWidget {
//   const Wishlist({super.key});

//   @override
//   State<Wishlist> createState() => _WishlistState();
// }

// class _WishlistState extends State<Wishlist> {
//   List<Map<String, dynamic>> _wishlist = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWishlist();
//   }

//   // Fetch wishlist data from Firestore
//   void fetchWishlist() async {
//     final userdata = await FirebaseFirestore.instance.collection('wishlist').get();
//     final rawdata = userdata.docs.map((doc) => doc.data()..['id'] = doc.id).toList(); // Add 'id' for each document
//     setState(() {
//       _wishlist = rawdata;
//       isLoading = false;
//     });
//   }

//   // Delete item from wishlist
//   void deleteItem(String docId) async {
//     try {
//       final db = FirebaseFirestore.instance.collection('wishlist');
//       await db.doc(docId).delete();  // Use document ID to delete
//       print("Item deleted successfully!");
//     } catch (e) {
//       print("Error deleting item: $e");
//     }
//   }

//   // Delete confirmation dialog
//   void deleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Confirmation', style: TextStyle(color: Colors.black)),
//           content: const Text('Are you sure you want to delete this item?', style: TextStyle(color: Colors.black)),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 deleteItem(docId);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Show edit wishlist item dialog
//   void showEditDialog(Map<String, dynamic> item) {
//     final TextEditingController itemNameController = TextEditingController(text: item["b_name"]);
//     final TextEditingController itemPriceController = TextEditingController(text: item["price"]);
    
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Wishlist Item', style: TextStyle(color: Colors.black)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: itemNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Item Name',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
            
//               TextField(
//                 controller: itemPriceController,
//                 decoration: const InputDecoration(
//                   labelText: 'Price',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final updatedData = {
//                   "b_name": itemNameController.text,
//                   "price": itemPriceController.text,
//                 };
//                 FirebaseFirestore.instance.collection('wishlist').doc(item["id"]).update(updatedData);  // Use Firestore document ID
//                 Navigator.of(context).pop();
//                 fetchWishlist();  // Refresh the list after updating the item
//               },
//               child: const Text('Update', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wishlist'),
//           backgroundColor:const Color.fromARGB(255, 4, 66, 85), // Dark blue background
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _wishlist.length,
//                     itemBuilder: (context, index) {
//                       final item = _wishlist[index];
//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Name: ${item["b_name"]}",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               Text("Price: \$${item["price"]}", style: const TextStyle(color: Colors.black)),
//                               item["b_img"] != null
//                                   ? Padding(
//                                       padding: const EdgeInsets.symmetric(vertical: 10),
//                                       child: CircleAvatar(
//                                         radius: 40,
//                                         backgroundImage: NetworkImage(item["b_img"] ?? ""),
//                                       ),
//                                     )
//                                   : const SizedBox.shrink(),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit),
//                                     onPressed: () => showEditDialog(item),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete),
//                                     onPressed: () => deleteDialog(item["id"]),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define the color palette for consistency
class AppColors {
  static const Color primaryBlack = Color(0xFF1A1A1A); // Dark charcoal/black
  static const Color accentYellow = Color(0xFFFFD166); // Muted yellow
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for card backgrounds
  static const Color textLightGrey = Color(0xFF616161); // For secondary text
  static const Color borderGrey = Color(0xFFE0E0E0); // Light grey for borders
}

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<Map<String, dynamic>> _wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  /// Fetches wishlist data from Firestore.
  Future<void> fetchWishlist() async {
    setState(() {
      isLoading = true; // Set loading to true before fetching
    });
    try {
      final userdata = await FirebaseFirestore.instance.collection('wishlist').get();
      final rawdata = userdata.docs.map((doc) => doc.data()..['id'] = doc.id).toList();

      setState(() {
        _wishlist = rawdata;
      });
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load wishlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false; // Always set loading to false after operation
      });
    }
  }

  /// Deletes an item from the wishlist in Firestore.
  Future<void> deleteItem(String docId) async {
    try {
      final db = FirebaseFirestore.instance.collection('wishlist');
      await db.doc(docId).delete();
      debugPrint("Item deleted successfully!");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted from wishlist!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      fetchWishlist(); // Refresh the list after deletion
    } catch (e) {
      debugPrint("Error deleting item: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Shows a confirmation dialog before deleting an item.
  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.backgroundWhite,
          title: const Text(
            'Delete Item',
            style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this item from your wishlist?',
            style: TextStyle(color: AppColors.textLightGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: AppColors.primaryBlack),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteItem(docId); // Perform deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: AppColors.backgroundWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to edit a wishlist item's name and price.
  void _showEditDialog(Map<String, dynamic> item) {
    final TextEditingController itemNameController = TextEditingController(text: item["b_name"]);
    final TextEditingController itemPriceController = TextEditingController(text: item["price"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.backgroundWhite,
          title: const Text(
            'Edit Wishlist Item',
            style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: const TextStyle(color: AppColors.textLightGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundWhite,
                ),
                style: const TextStyle(color: AppColors.primaryBlack),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: itemPriceController,
                keyboardType: TextInputType.number, // Ensure numeric input for price
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: const TextStyle(color: AppColors.textLightGrey),
                  prefixText: '\$', // Add a currency symbol
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundWhite,
                ),
                style: const TextStyle(color: AppColors.primaryBlack),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: AppColors.primaryBlack),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  "b_name": itemNameController.text.trim(),
                  "price": itemPriceController.text.trim(),
                };
                try {
                  await FirebaseFirestore.instance.collection('wishlist').doc(item["id"]).update(updatedData);
                  debugPrint("Item updated successfully!");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Wishlist item updated!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint("Error updating item: $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update item: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                if (mounted) {
                  Navigator.of(context).pop(); // Close the dialog
                }
                fetchWishlist(); // Refresh the list after updating
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.primaryBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'UPDATE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite, // Overall background
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: AppColors.backgroundWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryBlack, // Black app bar
        elevation: 4, // Add a subtle shadow
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentYellow, // Yellow loading indicator
              ),
            )
          : _wishlist.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: AppColors.textLightGrey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty!',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textLightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start adding your favorite items.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    final item = _wishlist[index];
                    final String itemName = item["b_name"] ?? 'No Name';
                    final String itemPrice = item["price"] ?? '0.00';
                    final String itemImage = item["b_img"] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6, // Increased elevation for a more premium look
                      shadowColor: AppColors.primaryBlack.withOpacity(0.15), // Subtle shadow
                      color: AppColors.cardBackground, // Light grey card background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image (if available)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.borderGrey, // Placeholder color
                                borderRadius: BorderRadius.circular(10), // Slightly rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryBlack.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: itemImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        itemImage,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(
                                          Icons.image_not_supported,
                                          color: AppColors.textLightGrey,
                                          size: 40,
                                        ),
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.accentYellow,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: AppColors.textLightGrey,
                                        size: 40,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlack,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Price: \$${double.tryParse(itemPrice)?.toStringAsFixed(2) ?? '0.00'}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textLightGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Tooltip(
                                        message: 'Edit item',
                                        child: IconButton(
                                          icon: const Icon(Icons.edit, color: AppColors.accentYellow, size: 28),
                                          onPressed: () => _showEditDialog(item),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Tooltip(
                                        message: 'Remove from wishlist',
                                        child: IconButton(
                                          icon: Icon(Icons.delete_forever, color: Colors.red.shade700, size: 28),
                                          onPressed: () => _showDeleteConfirmationDialog(item["id"]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
