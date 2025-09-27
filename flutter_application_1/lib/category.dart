// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Categorydata extends StatefulWidget {
//   const Categorydata({super.key});

//   @override
//   State<Categorydata> createState() => _CategorydataState();
// }

// class _CategorydataState extends State<Categorydata> {
//   List<Map<String, dynamic>> _users = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     try {
//       final userdata = await FirebaseFirestore.instance.collection('categories').get();
//       final rawdata = userdata.docs.map((doc) {
//         var data = doc.data();
//         data["key"] = doc.id;
//         return data;
//       }).toList();

//       setState(() {
//         _users = rawdata;
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }

//   void updateData(String docId, Map<String, dynamic> newData) async {
//     await FirebaseFirestore.instance.collection('categories').doc(docId).update(newData);
//   }

//   void deleteData(String docId) async {
//     await FirebaseFirestore.instance.collection('categories').doc(docId).delete();
//     fetchData();
//   }

//   void copyToClipboard(String id) {
//     Clipboard.setData(ClipboardData(text: id));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Category ID copied: $id"), duration: const Duration(seconds: 2)),
//     );
//   }

//   void deleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Confirmation', style: TextStyle(color: Colors.black)),
//         content: const Text('Are you sure you want to delete this category?', style: TextStyle(color: Colors.black)),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               deleteData(docId);
//               Navigator.of(context).pop();
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.black)),
//           ),
//         ],
//       ),
//     );
//   }

//   void showEditDialog(Map<String, dynamic> user) {
//     final categoryController = TextEditingController(text: user["category"]);
//     final catImageController = TextEditingController(text: user["cat_img"]);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Category', style: TextStyle(color: Colors.black)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: catImageController,
//               decoration: const InputDecoration(labelText: 'Category Image URL'),
//             ),
//             TextField(
//               controller: categoryController,
//               decoration: const InputDecoration(labelText: 'Category'),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final updatedCategory = categoryController.text;
//               final updatedCatImg = catImageController.text;

//               if (updatedCategory.isEmpty || updatedCatImg.isEmpty) {
//                 showError('Please fill in all fields.');
//                 return;
//               }

//               final querySnapshot = await FirebaseFirestore.instance
//                   .collection('categories')
//                   .where('category', isEqualTo: updatedCategory)
//                   .get();

//               if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.id != user["key"]) {
//                 showError('Category name already exists.');
//                 return;
//               }

//               final updatedData = {
//                 "cat_img": updatedCatImg,
//                 "category": updatedCategory,
//               };

//               updateData(user["key"], updatedData);
//               Navigator.of(context).pop();
//               fetchData();
//             },
//             child: const Text('Update', style: TextStyle(color: Colors.black)),
//           ),
//         ],
//       ),
//     );
//   }

//   void showError(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message, style: const TextStyle(color: Colors.red)),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void showAddCategoryDialog() {
//     final categoryIDController = TextEditingController();
//     final categoryController = TextEditingController();
//     final catImageController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Category', style: TextStyle(color: Colors.black)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: categoryIDController,
//               decoration: const InputDecoration(labelText: 'Category ID'),
//             ),
//             TextField(
//               controller: categoryController,
//               decoration: const InputDecoration(labelText: 'Category Name'),
//             ),
//             TextField(
//               controller: catImageController,
//               decoration: const InputDecoration(labelText: 'Category Image URL'),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final category = categoryController.text;
//               final catImg = catImageController.text;

//               if (category.isEmpty || catImg.isEmpty) {
//                 showError('Please fill in all fields.');
//                 return;
//               }

//               final querySnapshot = await FirebaseFirestore.instance
//                   .collection('categories')
//                   .where('category', isEqualTo: category)
//                   .get();

//               if (querySnapshot.docs.isNotEmpty) {
//                 showError('Category name already exists.');
//                 return;
//               }

//              final categoryID = categoryIDController.text.trim();
//              final Category = categoryController.text.trim();
//             final cat_img = catImageController.text.trim();

// // Check: fields empty toh error show karo
// if (categoryID.isEmpty || category.isEmpty || catImg.isEmpty) {
//   showError('Please fill in all fields.');
//   return;
// }

// // Check: category name already exists
// final nameCheck = await FirebaseFirestore.instance
//     .collection('categories')
//     .where('category', isEqualTo: category)
//     .get();

// if (nameCheck.docs.isNotEmpty) {
//   showError('Category name already exists.');
//   return;
// }

// // Check: ID already exists
// final idCheck = await FirebaseFirestore.instance
//     .collection('categories')
//     .doc(categoryID)
//     .get();

// if (idCheck.exists) {
//   showError('Category ID already exists.');
//   return;
// }

// // Final data to add
// final newCategory = {
//   "cat_img": catImg,
//   "category": category,
// };

// // Add with custom ID
// await FirebaseFirestore.instance
//     .collection('categories')
//     .doc(categoryID)
//     .set(newCategory);

// Navigator.of(context).pop();
// fetchData();

//             },
//             child: const Text('Add Category', style: TextStyle(color: Colors.black)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: showAddCategoryDialog,
//           ),
//         ],
//       ),
//       body: _users.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _users.length,
//               itemBuilder: (context, index) {
//                 final user = _users[index];
//                 final imgUrl = user["cat_img"];
//                 final isValidUrl = imgUrl != null && imgUrl.toString().startsWith("http");

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Category: ${user["category"]}", style: const TextStyle(color: Colors.black)),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: CircleAvatar(
//                             radius: 40,
//                             backgroundImage: isValidUrl
//                                 ? NetworkImage(imgUrl)
//                                 : const AssetImage('assets/placeholder.png') as ImageProvider,
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.copy, color: Colors.blue),
//                               onPressed: () => copyToClipboard(user["key"]),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () => showEditDialog(user),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () => deleteDialog(user["key"]),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
                    
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showAddCategoryDialog,
//         child: const Icon(Icons.add),
//       ),
      
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Categorydata extends StatefulWidget {
  const Categorydata({super.key});

  @override
  State<Categorydata> createState() => _CategorydataState();
}

class _CategorydataState extends State<Categorydata> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true; // Added a loading state

  // Theme Colors
  static const Color primaryWhite = Colors.white;
  static const Color primaryBlack = Colors.black87;
  static const Color accentYellow = Color(0xFFFFD700); // Gold-like yellow

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  /// Fetches category data from Firestore.
  Future<void> fetchData() async {
    setState(() {
      _isLoading = true; // Set loading to true when fetching
    });
    try {
      final categoryData = await FirebaseFirestore.instance.collection('categories').get();
      final rawData = categoryData.docs.map((doc) {
        var data = doc.data();
        data["key"] = doc.id; // Add document ID as 'key'
        return data;
      }).toList();

      setState(() {
        _categories = rawData;
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false; // Set loading to false even if error occurs
      });
      showError('Failed to fetch categories. Please try again.');
    }
  }

  /// Updates an existing category in Firestore.
  Future<void> updateData(String docId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(docId).update(newData);
      fetchData(); // Refresh data after update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category updated successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error updating data: $e");
      showError('Failed to update category. Please try again.');
    }
  }

  /// Deletes a category from Firestore.
  Future<void> deleteData(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(docId).delete();
      fetchData(); // Refresh data after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category deleted successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error deleting data: $e");
      showError('Failed to delete category. Please try again.');
    }
  }

  /// Copies a given ID to the clipboard.
  void copyToClipboard(String id) {
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Category ID copied: $id"),
        duration: const Duration(seconds: 2),
        backgroundColor: accentYellow,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows a confirmation dialog for deleting a category.
  void deleteDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Delete Confirmation', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this category? This action cannot be undone.',
            style: TextStyle(color: primaryBlack)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: primaryBlack)),
          ),
          ElevatedButton(
            onPressed: () {
              deleteData(docId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Use red for delete action
              foregroundColor: primaryWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to edit an existing category.
  void showEditDialog(Map<String, dynamic> category) {
    final categoryController = TextEditingController(text: category["category"]);
    final catImageController = TextEditingController(text: category["cat_img"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Edit Category', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: const TextStyle(color: primaryBlack),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: primaryBlack),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: catImageController,
              decoration: InputDecoration(
                labelText: 'Category Image URL',
                labelStyle: const TextStyle(color: primaryBlack),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: primaryBlack),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: primaryBlack)),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCategoryName = categoryController.text.trim();
              final updatedCatImg = catImageController.text.trim();

              if (updatedCategoryName.isEmpty || updatedCatImg.isEmpty) {
                showError('Please fill in all fields.');
                return;
              }

              // Check if the updated category name already exists (excluding the current category)
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('categories')
                  .where('category', isEqualTo: updatedCategoryName)
                  .get();

              if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.id != category["key"]) {
                showError('Category name already exists.');
                return;
              }

              final updatedData = {
                "cat_img": updatedCatImg,
                "category": updatedCategoryName,
              };

              updateData(category["key"], updatedData);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentYellow,
              foregroundColor: primaryBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  /// Shows an error dialog with a given message.
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: primaryBlack)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: primaryWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to add a new category.
  void showAddCategoryDialog() {
    final categoryIDController = TextEditingController();
    final categoryNameController = TextEditingController();
    final catImageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Add New Category', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryIDController,
              decoration: InputDecoration(
                labelText: 'Category ID (Optional, will be auto-generated if empty)',
                labelStyle: const TextStyle(color: primaryBlack),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: primaryBlack),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: const TextStyle(color: primaryBlack),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: primaryBlack),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: catImageController,
              decoration: InputDecoration(
                labelText: 'Category Image URL',
                labelStyle: const TextStyle(color: primaryBlack),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: primaryBlack),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: primaryBlack)),
          ),
          ElevatedButton(
            onPressed: () async {
              final categoryID = categoryIDController.text.trim();
              final categoryName = categoryNameController.text.trim();
              final catImg = catImageController.text.trim();

              if (categoryName.isEmpty || catImg.isEmpty) {
                showError('Please fill in category name and image URL.');
                return;
              }

              // Check if category name already exists
              final nameCheck = await FirebaseFirestore.instance
                  .collection('categories')
                  .where('category', isEqualTo: categoryName)
                  .get();

              if (nameCheck.docs.isNotEmpty) {
                showError('Category name already exists.');
                return;
              }

              // If a custom ID is provided, check if it already exists
              if (categoryID.isNotEmpty) {
                final idCheck = await FirebaseFirestore.instance.collection('categories').doc(categoryID).get();
                if (idCheck.exists) {
                  showError('Category ID already exists. Please use a different ID or leave it blank for auto-generation.');
                  return;
                }
              }

              final newCategoryData = {
                "cat_img": catImg,
                "category": categoryName,
              };

              try {
                if (categoryID.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('categories').doc(categoryID).set(newCategoryData);
                } else {
                  await FirebaseFirestore.instance.collection('categories').add(newCategoryData);
                }
                Navigator.of(context).pop();
                fetchData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Category added successfully!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                print("Error adding category: $e");
                showError('Failed to add category. Please try again.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentYellow,
              foregroundColor: primaryBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(color: primaryWhite, fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlack, // Dark AppBar
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: primaryWhite),
            onPressed: showAddCategoryDialog,
            tooltip: 'Add New Category',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentYellow),
              ),
            )
          : _categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      Text(
                        'No categories found. Add some!',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final imgUrl = category["cat_img"];
                    final isValidUrl = imgUrl != null && imgUrl.toString().startsWith("http");

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      color: primaryWhite, // White card background
                      shadowColor: Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[200], // Placeholder background
                              backgroundImage: isValidUrl
                                  ? NetworkImage(imgUrl)
                                  : const AssetImage('assets/placeholder.png') as ImageProvider, // Ensure you have a placeholder.png in your assets
                              onBackgroundImageError: (exception, stackTrace) {
                                if (kDebugMode) {
                                  print('Error loading image: $exception');
                                }
                              },
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category["category"] ?? 'N/A', // Null check
                                    style: const TextStyle(
                                      color: primaryBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'ID: ${category["key"] ?? 'N/A'}', // Null check
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy, color: Colors.blueGrey),
                                  onPressed: () => copyToClipboard(category["key"]),
                                  tooltip: 'Copy ID',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: accentYellow),
                                  onPressed: () => showEditDialog(category),
                                  tooltip: 'Edit Category',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteDialog(category["key"]),
                                  tooltip: 'Delete Category',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddCategoryDialog,
        icon: const Icon(Icons.add, color: primaryBlack),
        label: const Text('Add Category', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
        backgroundColor: accentYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}