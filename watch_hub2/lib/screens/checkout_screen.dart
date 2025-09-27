// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/providers/cart_provider.dart';
// import '/models/app_state.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

  
//   Future<void> _placeOrder() async {
//   if (!_formKey.currentState!.validate()) return;

//   setState(() => _isLoading = true);

//   try {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final cart = Provider.of<CartProvider>(context, listen: false);
//     final orderData = {
//       'userId': user.uid,
//       'userEmail': user.email,
//       'customerName': _nameController.text.trim(),
//       'shippingAddress': _addressController.text.trim(),
//       'phoneNumber': _phoneController.text.trim(),
//       'items': cart.items.map((item) => {
//         'watchId': item.watchId,
//         'name': item.name,
//         'quantity': item.quantity,
//         'price': item.price,
//         'imageUrl': item.imageUrl,
//       }).toList(),
//       'totalAmount': cart.totalAmount,
//       'orderStatus': 'pending',
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     await FirebaseFirestore.instance.collection('orders').add(orderData);

//     // ✅ Just show message and go back — do not clear cart
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Order placed successfully!')),
//     );
//     Navigator.of(context).pop();

//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error placing order: ${e.toString()}')),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     final isLoggedIn = Provider.of<AppState>(context).isLoggedIn;

//     if (!isLoggedIn) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: const Text('CHECKOUT', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.transparent,
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.lock, size: 64, color: Colors.yellow),
//               const SizedBox(height: 20),
//               const Text(
//                 'Authentication Required',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Please login to proceed with checkout',
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/auth');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellow[600],
//                   foregroundColor: Colors.black,
//                 ),
//                 child: const Text('LOGIN'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('CHECKOUT', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Shipping Information Header
//               const Text(
//                 'Shipping Information',
//                 style: TextStyle(
//                   color: Colors.yellow,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Name Field
//               TextFormField(
//                 controller: _nameController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: _inputDecoration('Full Name', Icons.person),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Address Field
//               TextFormField(
//                 controller: _addressController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: _inputDecoration('Shipping Address', Icons.home),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Phone Field
//               TextFormField(
//                 controller: _phoneController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: _inputDecoration('Phone Number', Icons.phone),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   if (value.length < 10) {
//                     return 'Enter a valid phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 30),

//               // Order Summary
//               const Text(
//                 'Order Summary',
//                 style: TextStyle(
//                   color: Colors.yellow,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Consumer<CartProvider>(
//                 builder: (ctx, cart, child) => Column(
//                   children: [
//                     ...cart.items.map((item) => ListTile(
//                           leading: Image.network(
//                             item.imageUrl,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.watch, color: Colors.grey),
//                           ),
//                           title: Text(
//                             item.name,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           subtitle: Text(
//                             '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                           trailing: Text(
//                             '\$${(item.price * item.quantity).toStringAsFixed(2)}',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                     const Divider(color: Colors.grey),
//                     ListTile(
//                       title: const Text(
//                         'Total',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       trailing: Text(
//                         '\$${cart.totalAmount.toStringAsFixed(2)}',
//                         style: TextStyle(
//                             color: Colors.yellow[600],
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Place Order Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _placeOrder,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.yellow[600],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.black)
//                       : const Text(
//                           'PLACE ORDER',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: Colors.grey[400]),
//       prefixIcon: Icon(icon, color: Colors.yellow[600]),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey[800]!),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.yellow[600]!),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       filled: true,
//       fillColor: Colors.grey[900],
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/providers/cart_provider.dart';
import '/models/app_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _useProfileAddress = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        if (_useProfileAddress) {
          _addressController.text = userData['address'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _postalCodeController.text = userData['postalCode'] ?? '';
        }
      });
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final cart = Provider.of<CartProvider>(context, listen: false);
      final orderData = {
        'userId': user.uid,
        'userEmail': user.email,
        'customerName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'shippingAddress': {
          'street': _addressController.text.trim(),
          'city': _cityController.text.trim(),
          'postalCode': _postalCodeController.text.trim(),
        },
        'items': cart.items.map((item) => {
          'watchId': item.watchId,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'imageUrl': item.imageUrl,
        }).toList(),
        'totalAmount': cart.totalAmount,
        'orderStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'useProfileAddress': _useProfileAddress,
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildAddressToggle() {
    return Row(
      children: [
        Checkbox(
          value: _useProfileAddress,
          onChanged: (value) {
            setState(() {
              _useProfileAddress = value ?? false;
              if (_useProfileAddress) {
                _loadUserProfile();
              } else {
                // Clear address fields when unchecking
                _addressController.clear();
                _cityController.clear();
                _postalCodeController.clear();
              }
            });
          },
          activeColor: Colors.yellow[600],
        ),
        const Text(
          'Use my profile address',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AppState>(context).isLoggedIn;

    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('CHECKOUT', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.yellow),
              const SizedBox(height: 20),
              const Text(
                'Authentication Required',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Please login to proceed with checkout',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  foregroundColor: Colors.black,
                ),
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('CHECKOUT', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information
              const Text(
                'Contact Information',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Full Name', Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Phone Number', Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Shipping Information
              const Text(
                'Shipping Address',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildAddressToggle(),
              const SizedBox(height: 12),

              // Address Field
              TextFormField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Street Address', Icons.home),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // City Field
              TextFormField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('City', Icons.location_city),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Postal Code Field
              TextFormField(
                controller: _postalCodeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Postal Code', Icons.markunread_mailbox),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Order Summary
              const Text(
                'Order Summary',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<CartProvider>(
                builder: (ctx, cart, child) => Column(
                  children: [
                    ...cart.items.map((item) => ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.watch, color: Colors.grey),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    const Divider(color: Colors.grey),
                    ListTile(
                      title: const Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.yellow[600],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.yellow[600]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow[600]!),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.grey[900],
    );
  }
}