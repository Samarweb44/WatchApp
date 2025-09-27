// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FetchData extends StatefulWidget {
//   const FetchData({super.key});

//   @override
//   State<FetchData> createState() => _FetchDataState();
// }

// class _FetchDataState extends State<FetchData> {
//   List<Map<String, dynamic>> _users = [];
//   TextEditingController searchController = TextEditingController();
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   // Fetching data from Firestore
//   void fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final userdata = await FirebaseFirestore.instance.collection('users').get();
//     final rawdata = userdata.docs.map((doc) {
//       var data = doc.data();
//       data['id'] = doc.id;  // Save the Firestore document ID as 'id'
//       return data;
//     }).toList();

//     setState(() {
//       _users = rawdata;
//       _isLoading = false;
//     });
//   }

//   // Update data in Firestore
//   void updateData(String docId, Map<String, dynamic> newData) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(docId)  // Use the document ID to get the correct document
//           .update(newData);  // Update specific fields
//       print("Data updated successfully!");
//     } catch (e) {
//       print("Error updating data: $e");
//     }
//   }

//   // Delete data from Firestore
//   void deleteData(String docId) async {
//     await FirebaseFirestore.instance.collection('users').doc(docId).delete();
//   }

//   // Show confirmation dialog for deleting data
//   void deleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Confirmation', style: TextStyle(color: Colors.black)),
//           content: const Text('Are you sure you want to delete this user?', style: TextStyle(color: Colors.black)),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 deleteData(docId);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Email validation function
//   bool isValidEmail(String email) {
//     final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
//     return regex.hasMatch(email);
//   }

//   // Show dialog for editing user details with Gmail validation
//   void showEditDialog(Map<String, dynamic> user) {
//     final TextEditingController nameController = TextEditingController(text: user["name"]);
//     final TextEditingController emailController = TextEditingController(text: user["email"]);
//     final TextEditingController passwordController = TextEditingController(text: user["password"]);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit User', style: TextStyle(color: Colors.black)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
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
//               onPressed: () async {
//                 final newName = nameController.text;
//                 final newEmail = emailController.text;
//                 final newPassword = passwordController.text;

//                 // Name validation - check if the name contains numbers
//                 if (RegExp(r'\d').hasMatch(newName)) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Name should not contain numbers.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Password validation - check if the password has at least 7 characters
//                 if (newPassword.length < 7) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Password should be at least 7 characters long.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Email validation - check if the email is valid
//                 if (!isValidEmail(newEmail)) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Please enter a valid email address.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Check if the email already exists in Firestore (excluding the current user's email)
//                 final querySnapshot = await FirebaseFirestore.instance
//                     .collection('users')
//                     .where('email', isEqualTo: newEmail)
//                     .get();

//                 if (querySnapshot.docs.isNotEmpty && querySnapshot.docs[0].id != user["id"]) {
//                   // If email exists and it's not the same as the current user's email, show error
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('This email is already registered. Please use a different email.',
//                             style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // If validations pass, proceed with the update
//                 final updatedData = {
//                   "name": newName,
//                   "email": newEmail,
//                   "password": newPassword,
//                 };

//                 updateData(user["id"], updatedData);  // Use Firestore document ID to update
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Update', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Add user dialog implementation with Gmail validation
//   void showAddUserDialog() {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add New User', style: TextStyle(color: Colors.black)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
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
//               onPressed: () async {
//                 final name = nameController.text;
//                 final email = emailController.text;
//                 final password = passwordController.text;

//                 // Validate if all fields are filled
//                 if (name.isEmpty || email.isEmpty || password.isEmpty) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Please fill in all fields.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Name validation - check if the name contains numbers
//                 if (RegExp(r'\d').hasMatch(name)) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Name should not contain numbers.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Password validation - check if the password has at least 7 characters
//                 if (password.length < 7) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Password should be at least 7 characters long.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Email validation - check if the email is valid
//                 if (!isValidEmail(email)) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('Please enter a valid email address.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Check for duplicate email
//                 final querySnapshot = await FirebaseFirestore.instance
//                     .collection('users')
//                     .where('email', isEqualTo: email)
//                     .get();

//                 if (querySnapshot.docs.isNotEmpty) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Error'),
//                         content: const Text('This email is already registered. Please use a different email.', style: TextStyle(color: Colors.red)),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('OK', style: TextStyle(color: Colors.black)),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   return;
//                 }

//                 // Add the new user if validation passes
//                 final newUser = {
//                   "name": name,
//                   "email": email,
//                   "password": password,
//                   "images": "", // You can add logic for default images here
//                 };

//                 try {
//                   await FirebaseFirestore.instance.collection('users').add(newUser);
//                   print("User added successfully!");
//                   Navigator.of(context).pop();
//                   fetchData(); // Refresh user list after adding
//                 } catch (e) {
//                   print("Error adding user: $e");
//                 }
//               },
//               child: const Text('Add User', style: TextStyle(color: Colors.black)),
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
//         title: const Text('Users Data', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: showAddUserDialog, // Show Add User Dialog
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: const InputDecoration(
//                 labelText: 'Search Users',
//                 labelStyle: TextStyle(color: Colors.black),
//                 prefixIcon: Icon(Icons.search, color: Colors.black),
//               ),
//               style: const TextStyle(color: Colors.black),
//               onChanged: (value) {
//                 setState(() {
//                   if (value.isEmpty) {
//                     fetchData(); // Reset the list to all users when search query is empty
//                   } else {
//                     _users = _users
//                         .where((user) => user["name"]
//                             .toLowerCase()
//                             .contains(value.toLowerCase()) || user["email"]
//                             .toLowerCase()
//                             .contains(value.toLowerCase()))
//                         .toList();
//                   }
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _users.isEmpty
//                     ? const Center(child: Text("No users found."))
//                     : ListView.builder(
//                         itemCount: _users.length,
//                         itemBuilder: (context, index) {
//                           final user = _users[index];
//                           return Card(
//                             margin: const EdgeInsets.all(10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 5,
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Name: ${user["name"]}",
//                                       style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black)),
//                                   Text("Email: ${user["email"]}",
//                                       style: const TextStyle(color: Colors.black)),
//                                   Text("Password: ${user["password"]}",
//                                       style: const TextStyle(color: Colors.black)),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       IconButton(
//                                         icon: const Icon(Icons.edit),
//                                         onPressed: () => showEditDialog(user),
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete),
//                                         onPressed: () => deleteDialog(user["id"]),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = []; // New list for filtered users
  TextEditingController searchController = TextEditingController();
  bool _isLoading = true;

  // Theme Colors
  static const Color primaryWhite = Colors.white;
  static const Color primaryBlack = Color(0xFF212121); // A slightly softer black
  static const Color accentYellow = Color(0xFFFFD700); // Gold-like yellow

  @override
  void initState() {
    super.initState();
    fetchData();
    // Add listener to search controller for real-time filtering
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  /// Handles changes in the search input and filters the user list.
  void _onSearchChanged() {
    filterUsers(searchController.text);
  }

  /// Fetches user data from Firestore.
  Future<void> fetchData() async {
    setState(() {
      _isLoading = true; // Set loading to true when fetching
    });
    try {
      final userData = await FirebaseFirestore.instance.collection('users').get();
      final rawData = userData.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Save the Firestore document ID as 'id'
        return data;
      }).toList();

      setState(() {
        _users = rawData;
        _filteredUsers = rawData; // Initialize filtered list with all users
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false; // Set loading to false even if error occurs
      });
      _showSnackBar('Failed to fetch users. Please try again.', isError: true);
    }
  }

  /// Filters the user list based on the search query.
  void filterUsers(String query) {
    List<Map<String, dynamic>> tempUsers;
    if (query.isEmpty) {
      tempUsers = _users; // If search is empty, show all users
    } else {
      tempUsers = _users.where((user) {
        final nameLower = user["name"]?.toLowerCase() ?? '';
        final emailLower = user["email"]?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) || emailLower.contains(queryLower);
      }).toList();
    }
    setState(() {
      _filteredUsers = tempUsers;
    });
  }

  /// Updates an existing user in Firestore.
  Future<void> updateData(String docId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update(newData);
      fetchData(); // Refresh data after update
      _showSnackBar("User updated successfully! ✅", isError: false);
    } catch (e) {
      print("Error updating data: $e");
      _showSnackBar('Failed to update user. Please try again.', isError: true);
    }
  }

  /// Deletes a user from Firestore.
  Future<void> deleteData(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).delete();
      fetchData(); // Refresh data after deletion
      _showSnackBar("User deleted successfully! 🗑️", isError: false);
    } catch (e) {
      print("Error deleting data: $e");
      _showSnackBar('Failed to delete user. Please try again.', isError: true);
    }
  }

  /// Shows a confirmation dialog for deleting data.
  void deleteDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: primaryWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Delete Confirmation', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to delete this user? This action cannot be undone.',
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
                backgroundColor: Colors.red, // Red for delete
                foregroundColor: primaryWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Validates if an email is in a valid format.
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Displays a SnackBar message.
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows a dialog for editing user details with validation.
  void showEditDialog(Map<String, dynamic> user) {
    final TextEditingController nameController = TextEditingController(text: user["name"]);
    final TextEditingController emailController = TextEditingController(text: user["email"]);
    final TextEditingController passwordController = TextEditingController(text: user["password"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: primaryWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Edit User', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView( // Added to prevent overflow on small screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                  obscureText: true, // Hide password
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: primaryBlack)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();
                final newPassword = passwordController.text.trim();

                // Validation Checks
                if (newName.isEmpty || newEmail.isEmpty || newPassword.isEmpty) {
                  Navigator.of(context).pop(); // Close current dialog
                  _showSnackBar('Please fill in all fields.', isError: true);
                  return;
                }
                if (RegExp(r'\d').hasMatch(newName)) {
                  Navigator.of(context).pop();
                  _showSnackBar('Name should not contain numbers.', isError: true);
                  return;
                }
                if (newPassword.length < 7) {
                  Navigator.of(context).pop();
                  _showSnackBar('Password should be at least 7 characters long.', isError: true);
                  return;
                }
                if (!isValidEmail(newEmail)) {
                  Navigator.of(context).pop();
                  _showSnackBar('Please enter a valid email address.', isError: true);
                  return;
                }

                // Check for duplicate email (excluding the current user's email)
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: newEmail)
                    .get();

                if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.id != user["id"]) {
                  Navigator.of(context).pop();
                  _showSnackBar('This email is already registered. Please use a different email.', isError: true);
                  return;
                }

                // If validations pass, proceed with the update
                final updatedData = {
                  "name": newName,
                  "email": newEmail,
                  "password": newPassword,
                };

                updateData(user["id"], updatedData); // Use Firestore document ID to update
                Navigator.of(context).pop(); // Close the edit dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentYellow,
                foregroundColor: primaryBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  /// Add new user dialog implementation with validation.
  void showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: primaryWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Add New User', style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView( // Added to prevent overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                  obscureText: true, // Hide password
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: primaryBlack)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                // Validation Checks
                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  Navigator.of(context).pop();
                  _showSnackBar('Please fill in all fields.', isError: true);
                  return;
                }
                if (RegExp(r'\d').hasMatch(name)) {
                  Navigator.of(context).pop();
                  _showSnackBar('Name should not contain numbers.', isError: true);
                  return;
                }
                if (password.length < 7) {
                  Navigator.of(context).pop();
                  _showSnackBar('Password should be at least 7 characters long.', isError: true);
                  return;
                }
                if (!isValidEmail(email)) {
                  Navigator.of(context).pop();
                  _showSnackBar('Please enter a valid email address.', isError: true);
                  return;
                }

                // Check for duplicate email
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: email)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  Navigator.of(context).pop();
                  _showSnackBar('This email is already registered. Please use a different email.', isError: true);
                  return;
                }

                // Add the new user if validation passes
                final newUser = {
                  "name": name,
                  "email": email,
                  "password": password,
                  "images": "", // You can add logic for default images here
                };

                try {
                  await FirebaseFirestore.instance.collection('users').add(newUser);
                  Navigator.of(context).pop(); // Close the add dialog
                  fetchData(); // Refresh user list after adding
                  _showSnackBar("User added successfully! 🎉", isError: false);
                } catch (e) {
                  print("Error adding user: $e");
                  _showSnackBar('Failed to add user. Please try again.', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentYellow,
                foregroundColor: primaryBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add User'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Data', style: TextStyle(color: primaryWhite, fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlack, // Dark AppBar
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: primaryWhite),
            onPressed: showAddUserDialog, // Show Add User Dialog
            tooltip: 'Add New User',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Users by Name or Email',
                labelStyle: const TextStyle(color: primaryBlack),
                prefixIcon: const Icon(Icons.search, color: primaryBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: accentYellow, width: 2.0),
                ),
                filled: true,
                fillColor: primaryWhite,
              ),
              style: const TextStyle(color: primaryBlack),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(accentYellow),
                    ),
                  )
                : _filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off_outlined, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 20),
                            Text(
                              searchController.text.isEmpty
                                  ? 'No users found.'
                                  : 'No users matching "${searchController.text}"',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          // Placeholder for user image. If 'images' field contains a URL, use NetworkImage.
                          // Otherwise, use a default asset or icon.
                          final userImage = user["images"];
                          final isValidImageUrl = userImage != null && userImage.toString().startsWith("http");

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
                                    radius: 30,
                                    backgroundColor: Colors.grey[200],
                                    // You can use a default image or icon if 'images' is empty/invalid
                                    backgroundImage: isValidImageUrl
                                        ? NetworkImage(userImage)
                                        : const AssetImage('assets/default_user.png') as ImageProvider, // Ensure you have this asset
                                    child: !isValidImageUrl && (userImage == null || userImage.isEmpty)
                                        ? Icon(Icons.person, color: primaryBlack.withOpacity(0.7), size: 35)
                                        : null,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user["name"] ?? 'N/A', // Null check for name
                                          style: const TextStyle(
                                            color: primaryBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user["email"] ?? 'N/A', // Null check for email
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${user["id"] ?? 'N/A'}', // Display Firestore ID
                                          style: TextStyle(
                                            color: Colors.grey[500],
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
                                        icon: const Icon(Icons.edit, color: accentYellow),
                                        onPressed: () => showEditDialog(user),
                                        tooltip: 'Edit User',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => deleteDialog(user["id"]),
                                        tooltip: 'Delete User',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}