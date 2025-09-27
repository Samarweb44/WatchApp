// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';

// class CleanOrderTrackingScreen extends StatefulWidget {
//   const CleanOrderTrackingScreen({super.key});

//   @override
//   State<CleanOrderTrackingScreen> createState() => _CleanOrderTrackingScreenState();
// }

// class _CleanOrderTrackingScreenState extends State<CleanOrderTrackingScreen> {
//   final _trackingController = TextEditingController();
//   String? _currentTrackingNumber;

//   @override
//   void dispose() {
//     _trackingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Order Tracking'),
//           backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//           bottom: const TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.list_alt), text: 'My Orders'),
//               Tab(icon: Icon(Icons.track_changes), text: 'Track Order'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Tab 1: User's Orders with tracking info
//             _buildOrdersTab(),

//             // Tab 2: Track Order Input
//             _buildTrackingTab(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrdersTab() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.person_off, size: 50, color: Colors.grey),
//             const SizedBox(height: 20),
//             const Text('Please login to view your orders'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add your login navigation here
//               },
//               child: const Text('LOGIN'),
//             ),
//           ],
//         ),
//       );
//     }

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('orders')
//           .where('userId', isEqualTo: user.uid)
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.grey),
//                 const SizedBox(height: 20),
//                 const Text('No orders found'),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Your orders will appear here',
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             final order = snapshot.data!.docs[index];
//             final data = order.data() as Map<String, dynamic>;
//             final trackingNumber = data['trackingNumber'] as String?;
//             final status = data['orderStatus'] as String? ?? 'pending';
//             final createdAt = data['createdAt'] as Timestamp?;
//             final shortId = order.id.substring(0, 8).toUpperCase();

//             return Card(
//               margin: const EdgeInsets.only(bottom: 12),
//               child: InkWell(
//                 onTap: trackingNumber != null
//                     ? () {
//                         setState(() {
//                           _currentTrackingNumber = trackingNumber;
//                           DefaultTabController.of(context).animateTo(1);
//                         });
//                       }
//                     : null,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Order #$shortId',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: _getStatusColor(status).withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               status.toUpperCase(),
//                               style: TextStyle(
//                                 color: _getStatusColor(status),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       if (createdAt != null)
//                         Text(
//                           'Placed on ${DateFormat('MMM dd, yyyy').format(createdAt.toDate())}',
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       const SizedBox(height: 12),
//                       if (trackingNumber != null) ...[
//                         const Divider(),
//                         Row(
//                           children: [
//                             const Icon(Icons.local_shipping, size: 20),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Tracking: $trackingNumber',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.content_copy, size: 20),
//                               onPressed: () {
//                                 Clipboard.setData(
//                                     ClipboardData(text: trackingNumber));
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Tracking number copied'),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildTrackingTab() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_currentTrackingNumber == null) ...[
//             const Icon(Icons.local_shipping, size: 60, color: Color.fromARGB(255, 4, 66, 85)),
//             const SizedBox(height: 20),
//             const Text(
//               'Track Your Order',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Enter your tracking number to check order status',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 30),
//             TextField(
//               controller: _trackingController,
//               decoration: InputDecoration(
//                 labelText: 'Tracking Number',
//                 border: const OutlineInputBorder(),
//                 prefixIcon: const Icon(Icons.confirmation_number),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.paste),
//                   onPressed: () async {
//                     final data = await Clipboard.getData('text/plain');
//                     if (data != null && data.text != null) {
//                       _trackingController.text = data.text!;
//                     }
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: () {
//                   if (_trackingController.text.trim().isNotEmpty) {
//                     setState(() {
//                       _currentTrackingNumber = _trackingController.text.trim();
//                     });
//                   }
//                 },
//                 child: const Text('TRACK ORDER'),
//               ),
//             ),
//           ] else ...[
//             _buildTrackingDetails(_currentTrackingNumber!),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _currentTrackingNumber = null;
//                   _trackingController.clear();
//                 });
//               },
//               child: const Text('Track another order'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTrackingDetails(String trackingNumber) {
//   final user = FirebaseAuth.instance.currentUser;

//   return StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('orders')
//         .where('trackingNumber', isEqualTo: trackingNumber)
//         .where('userId', isEqualTo: user?.uid ?? '')
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         // Special handling for index errors
//         if (snapshot.error.toString().contains('requires an index')) {
//           return Column(
//             children: [
//               const Icon(Icons.build, size: 50, color: Colors.orange),
//               const SizedBox(height: 20),
//               const Text(
//                 'Configuration Needed',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'This feature requires database indexing setup.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // You could launch the Firebase console URL here
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please contact support to enable this feature'),
//                     ),
//                   );
//                 },
//                 child: const Text('GET HELP'),
//               ),
//             ],
//           );
//         }

//         return Column(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.red, size: 50),
//             const SizedBox(height: 10),
//             Text(
//               'Error: ${snapshot.error}',
//               textAlign: TextAlign.center,
//             ),
//           ],
//         );
//       }

//         final order = snapshot.data!.docs.first;
//         final data = order.data() as Map<String, dynamic>;
//         final status = data['orderStatus'] as String? ?? 'pending';
//         final carrier = data['carrier'] as String? ?? 'Not specified';
//         final updatedAt = data['updatedAt'] as Timestamp?;
//         final items = data['items'] as List<dynamic>? ?? [];
//         final totalAmount = (data['totalAmount'] as num? ?? 0).toDouble();

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               Card(
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'SHIPPING STATUS',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       _buildStatusIndicator(status),
//                       const SizedBox(height: 20),
//                       _buildDetailRow('Tracking Number', trackingNumber),
//                       const Divider(),
//                       _buildDetailRow('Carrier', carrier),
//                       if (updatedAt != null) ...[
//                         const Divider(),
//                         _buildDetailRow(
//                           'Last Update',
//                           DateFormat('MMM dd, yyyy - hh:mm a').format(updatedAt.toDate()),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'ORDER SUMMARY',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...items.map((item) => _buildOrderItem(item)).toList(),
//                       const Divider(),
//                       _buildDetailRow(
//                         'Total Amount',
//                         '\$${totalAmount.toStringAsFixed(2)}',
//                         isBold: true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatusIndicator(String status) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _getStatusColor(status).withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             _getStatusIcon(status),
//             size: 30,
//             color: _getStatusColor(status),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           status.toUpperCase(),
//           style: TextStyle(
//             color: _getStatusColor(status),
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               name,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Text(
//             '\$${price.toStringAsFixed(2)} × $quantity',
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return Colors.blue;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       case 'processing':
//         return Colors.orange;
//       default: // pending
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return Icons.local_shipping;
//       case 'delivered':
//         return Icons.check_circle;
//       case 'cancelled':
//         return Icons.cancel;
//       case 'processing':
//         return Icons.autorenew;
//       default: // pending
//         return Icons.access_time;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  final _trackingController = TextEditingController();
  String? _currentTrackingNumber;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Theme colors
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _hintColor = const Color(0xFFA0A0A0);
  final Color _successGreen = const Color(0xFF4CAF50);
  final Color _errorRed = const Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _trackingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _primaryBlack,
        appBar: AppBar(
          title: const Text(
            'Order Tracking',
            style: TextStyle(color: Colors.white), // ✅ White text
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _accentYellow),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryBlack.withOpacity(0.9), _primaryBlack],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: _accentYellow,
            labelColor: _accentYellow,
            unselectedLabelColor: _hintColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(icon: Icon(Icons.message_outlined), text: 'Order History'),
              Tab(
                icon: Icon(Icons.local_shipping_outlined),
                text: 'Track Order',
              ),
            ],
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: TabBarView(
            children: [_buildMessagesTab(), _buildTrackingTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text(
          'Please login to view orders',
          style: TextStyle(color: _hintColor),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('updatedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: _errorRed),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _accentYellow));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No orders found', style: TextStyle(color: _hintColor)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final order = snapshot.data!.docs[index];
            final data = order.data() as Map<String, dynamic>;
            final trackingNumber = data['trackingNumber'] as String?;
            final orderId = order.id.substring(0, 8);
            final date = (data['updatedAt'] as Timestamp?)?.toDate();
            final items = data['items'] as List<dynamic>? ?? [];
            final totalItems = items.fold(
              0,
              (sum, item) => sum + (item['quantity'] as int? ?? 0),
            );

            // Get the first product name as representative
            final firstProductName = items.isNotEmpty
                ? items[0]['name']?.toString() ?? 'Product'
                : 'Product';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: _secondaryBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #$orderId',
                          style: TextStyle(
                            color: _white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (date != null)
                          Text(
                            DateFormat('MMM dd').format(date),
                            style: TextStyle(color: _hintColor),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$firstProductName${items.length > 1 ? ' + ${items.length - 1} more' : ''}',
                      style: TextStyle(color: _white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalItems item${totalItems != 1 ? 's' : ''}',
                      style: TextStyle(color: _hintColor, fontSize: 13),
                    ),
                    if (trackingNumber != null) ...[
                      const SizedBox(height: 8),
                      Divider(color: _primaryBlack, height: 1),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            size: 18,
                            color: _hintColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trackingNumber,
                              style: TextStyle(color: _white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrackingTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentTrackingNumber == null) ...[
            Icon(Icons.local_shipping, size: 100, color: _accentYellow),
            const SizedBox(height: 24),
            Text(
              'Track Your Order',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your tracking number to check the status of your order',
              textAlign: TextAlign.center,
              style: TextStyle(color: _hintColor),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _trackingController,
              style: TextStyle(color: _white),
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                labelStyle: TextStyle(color: _hintColor),
                hintText: 'e.g. ABC123456789',
                hintStyle: TextStyle(color: _hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: _secondaryBlack,
                prefixIcon: Icon(
                  Icons.confirmation_number_outlined,
                  color: _hintColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _accentYellow, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentYellow,
                  foregroundColor: _primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_trackingController.text.trim().isNotEmpty) {
                    setState(() {
                      _currentTrackingNumber = _trackingController.text.trim();
                    });
                  }
                },
                child: const Text(
                  'TRACK ORDER',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: _buildTrackingDetails(_currentTrackingNumber!),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentTrackingNumber = null;
                  _trackingController.clear();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 18, color: _accentYellow),
                  const SizedBox(width: 8),
                  Text(
                    'Track another order',
                    style: TextStyle(color: _accentYellow),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingDetails(String trackingNumber) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('trackingNumber', isEqualTo: trackingNumber)
          .where('userId', isEqualTo: user?.uid ?? '')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error.toString()}',
              style: TextStyle(color: _errorRed),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _accentYellow));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: _hintColor),
              const SizedBox(height: 16),
              Text(
                'No order found with this tracking number',
                style: TextStyle(color: _hintColor),
              ),
            ],
          );
        }

        try {
          final order = snapshot.data!.docs.first;
          final data = order.data() as Map<String, dynamic>;

          // Safe data extraction
          final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
          final shippingAddress = data['shippingAddress'] is Map
              ? Map<String, dynamic>.from(data['shippingAddress'] as Map)
              : null;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Order Summary Card
                Card(
                  color: _secondaryBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ORDER ITEMS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: _primaryBlack,
                                    image: item['imageUrl'] != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              item['imageUrl'].toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: item['imageUrl'] == null
                                      ? Icon(
                                          Icons.shopping_bag,
                                          color: _hintColor,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name']?.toString() ??
                                            'Unknown Product',
                                        style: TextStyle(
                                          color: _white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: ${item['quantity']?.toString() ?? '1'}',
                                        style: TextStyle(color: _hintColor),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${double.tryParse(item['price']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(color: _accentYellow),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tracking Information
                Card(
                  color: _secondaryBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'TRACKING INFORMATION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Status', 'Shipped'), // Default status
                        _buildDetailRow('Tracking Number', trackingNumber),
                        if (data['carrier'] != null)
                          _buildDetailRow(
                            'Carrier',
                            data['carrier'].toString(),
                          ),
                        if (data['updatedAt'] != null)
                          _buildDetailRow(
                            'Last Update',
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format((data['updatedAt'] as Timestamp).toDate()),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } catch (e) {
          return Center(
            child: Text(
              'Error displaying order: ${e.toString()}',
              style: TextStyle(color: _errorRed),
            ),
          );
        }
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: _hintColor, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isBold ? _accentYellow : _white,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';

// class CleanOrderTrackingScreen extends StatefulWidget {
//   const CleanOrderTrackingScreen({super.key});

//   @override
//   State<CleanOrderTrackingScreen> createState() => _CleanOrderTrackingScreenState();
// }

// class _CleanOrderTrackingScreenState extends State<CleanOrderTrackingScreen> with SingleTickerProviderStateMixin {
//   final _trackingController = TextEditingController();
//   String? _currentTrackingNumber;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _trackingController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           title: const Text('Order Tracking', style: TextStyle(fontWeight: FontWeight.w600)),
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           bottom: TabBar(
//             labelColor: Theme.of(context).primaryColor,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Theme.of(context).primaryColor,
//             labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//             tabs: const [
//               Tab(icon: Icon(Icons.message_outlined), text: 'Order History'),
//               Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Track Order'),
//             ],
//           ),
//         ),
//         body: FadeTransition(
//           opacity: _fadeAnimation,
//           child: TabBarView(
//             children: [
//               _buildMessagesTab(),
//               _buildTrackingTab(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// Widget _buildMessagesTab() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     return const Center(child: Text('Please login to view orders'));
//   }

//   return StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('orders')
//         .where('userId', isEqualTo: user.uid)
//         .orderBy('updatedAt', descending: true)
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error}'));
//       }

//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//         return const Center(child: Text('No orders found'));
//       }

//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: snapshot.data!.docs.length,
//         itemBuilder: (context, index) {
//           final order = snapshot.data!.docs[index];
//           final data = order.data() as Map<String, dynamic>;
//           final trackingNumber = data['trackingNumber'] as String?;
//           final orderId = order.id.substring(0, 8);
//           final date = (data['updatedAt'] as Timestamp?)?.toDate();
//           final items = data['items'] as List<dynamic>? ?? [];
//           final totalItems = items.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 0));

//           // Get the first product name as representative
//           final firstProductName = items.isNotEmpty 
//               ? items[0]['name']?.toString() ?? 'Product' 
//               : 'Product';

//           return Card(
//             margin: const EdgeInsets.only(bottom: 12),
//             elevation: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Order #$orderId',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       if (date != null)
//                         Text(
//                           DateFormat('MMM dd').format(date),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '$firstProductName${items.length > 1 ? ' + ${items.length - 1} more' : ''}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '$totalItems item${totalItems != 1 ? 's' : ''}',
//                     style: const TextStyle(color: Colors.grey, fontSize: 13),
//                   ),
//                   if (trackingNumber != null) ...[
//                     const SizedBox(height: 8),
//                     const Divider(height: 1),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.confirmation_number, size: 18, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             trackingNumber,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//   Widget _buildTrackingTab() {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_currentTrackingNumber == null) ...[
//             const Icon(Icons.local_shipping, size: 100, color: Colors.grey),
//             const SizedBox(height: 24),
//             const Text(
//               'Track Your Order',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Enter your tracking number to check the status of your order',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 32),
//             TextFormField(
//               controller: _trackingController,
//               decoration: InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'e.g. ABC123456789',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 prefixIcon: const Icon(Icons.confirmation_number_outlined),
//                 filled: true,
//                 fillColor: Colors.grey[50],
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (_trackingController.text.trim().isNotEmpty) {
//                     setState(() {
//                       _currentTrackingNumber = _trackingController.text.trim();
//                     });
//                   }
//                 },
//                 child: const Text('TRACK ORDER', style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//             ),
//           ] else ...[
//             Expanded(
//               child: SingleChildScrollView(
//                 child: _buildTrackingDetails(_currentTrackingNumber!),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _currentTrackingNumber = null;
//                   _trackingController.clear();
//                 });
//               },
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search, size: 18),
//                   SizedBox(width: 8),
//                   Text('Track another order'),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTrackingDetails(String trackingNumber) {
//   final user = FirebaseAuth.instance.currentUser;
  
//   return StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('orders')
//         .where('trackingNumber', isEqualTo: trackingNumber)
//         .where('userId', isEqualTo: user?.uid ?? '')
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error.toString()}'));
//       }

//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//         return const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 48, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('No order found with this tracking number'),
//           ],
//         );
//       }

//       try {
//         final order = snapshot.data!.docs.first;
//         final data = order.data() as Map<String, dynamic>;
        
//         // Safe data extraction
//         final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
//         final shippingAddress = data['shippingAddress'] is Map 
//             ? Map<String, dynamic>.from(data['shippingAddress'] as Map)
//             : null;
        
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Order Summary Card
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'ORDER ITEMS',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       ...items.map((item) => Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.grey[200],
//                                 image: item['imageUrl'] != null 
//                                     ? DecorationImage(
//                                         image: NetworkImage(item['imageUrl'].toString()),
//                                         fit: BoxFit.cover,
//                                       )
//                                     : null,
//                               ),
//                               child: item['imageUrl'] == null
//                                   ? const Icon(Icons.shopping_bag, color: Colors.grey)
//                                   : null,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item['name']?.toString() ?? 'Unknown Product',
//                                     style: const TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Qty: ${item['quantity']?.toString() ?? '1'}',
//                                     style: const TextStyle(color: Colors.grey),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '\$${double.tryParse(item['price']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

             
//               const SizedBox(height: 16),

//               // Tracking Information
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'TRACKING INFORMATION',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildDetailRow('Status', 'Shipped'), // Default status
//                       _buildDetailRow('Tracking Number', trackingNumber),
//                       if (data['carrier'] != null)
//                         _buildDetailRow('Carrier', data['carrier'].toString()),
//                       if (data['updatedAt'] != null)
//                         _buildDetailRow(
//                           'Last Update', 
//                           DateFormat('MMM dd, yyyy').format((data['updatedAt'] as Timestamp).toDate()),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       } catch (e) {
//         return Center(child: Text('Error displaying order: ${e.toString()}'));
//       }
//     },
//   );
// }

// Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//   Widget _buildOrderCard({
//     required String orderId,
//     required String? trackingNumber,
//     required DateTime? date,
//     required String status,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: _getStatusColor(status).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 _getStatusIcon(status),
//                 color: _getStatusColor(status),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order #$orderId',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     trackingNumber ?? 'Tracking not available',
//                     style: TextStyle(
//                       color: trackingNumber != null ? Colors.grey[700] : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 if (date != null)
//                   Text(
//                     DateFormat('MMM dd').format(date),
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _getStatusText(status),
//                   style: TextStyle(
//                     color: _getStatusColor(status),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey, size: 20),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(color: Colors.grey, fontSize: 13),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeline({required String status}) {
//     final steps = [
//       {'title': 'Order Placed', 'status': 'placed', 'icon': Icons.shopping_cart_outlined},
//       {'title': 'Processing', 'status': 'processing', 'icon': Icons.settings_outlined},
//       {'title': 'Shipped', 'status': 'shipped', 'icon': Icons.local_shipping_outlined},
//       {'title': 'Delivered', 'status': 'delivered', 'icon': Icons.check_circle_outlined},
//     ];

//     final currentIndex = steps.indexWhere((step) => step['status'] == status.toLowerCase());
    
//     return Column(
//       children: [
//         for (int i = 0; i < steps.length; i++) ...[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: i <= currentIndex 
//                           ? Theme.of(context).primaryColor 
//                           : Colors.grey[300],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       steps[i]['icon'] as IconData,
//                       size: 12,
//                       color: i <= currentIndex ? Colors.white : Colors.grey[500],
//                     ),
//                   ),
//                   if (i < steps.length - 1)
//                     Container(
//                       width: 1,
//                       height: 40,
//                       color: i < currentIndex 
//                           ? Theme.of(context).primaryColor 
//                           : Colors.grey[300],
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         steps[i]['title'] as String,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: i <= currentIndex ? Colors.black : Colors.grey,
//                         ),
//                       ),
//                       if (i == currentIndex)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             _getStatusDescription(status),
//                             style: const TextStyle(color: Colors.grey, fontSize: 13),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[200]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.only(bottom: 12),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             height: 80,
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//           ),
//           const SizedBox(height: 16),
//           const Text('Loading order details...'),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
//           const SizedBox(height: 24),
//           const Text(
//             'No Orders Found',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 48),
//             child: Text(
//               "You haven't placed any orders yet. When you do, they'll appear here.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAuthRequiredView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.account_circle_outlined, size: 60, color: Colors.grey),
//           const SizedBox(height: 16),
//           const Text(
//             'Authentication Required',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Please sign in to view your order history',
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               // Implement sign in navigation
//             },
//             child: const Text('SIGN IN'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorView(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 60, color: Colors.red),
//           const SizedBox(height: 16),
//           const Text(
//             'Something Went Wrong',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             error,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 24),
//           TextButton(
//             onPressed: () => setState(() {}),
//             child: const Text('RETRY'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotFoundView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.search_off, size: 60, color: Colors.grey),
//           const SizedBox(height: 24),
//           const Text(
//             'Order Not Found',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 48),
//             child: Text(
//               "We couldn't find an order with that tracking number. Please check the number and try again.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _currentTrackingNumber = null;
//                 _trackingController.clear();
//               });
//             },
//             child: const Text('TRY ANOTHER NUMBER'),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return Colors.blue;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       case 'processing':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return Icons.local_shipping_outlined;
//       case 'delivered':
//         return Icons.check_circle_outlined;
//       case 'cancelled':
//         return Icons.cancel_outlined;
//       case 'processing':
//         return Icons.settings_outlined;
//       default:
//         return Icons.shopping_cart_outlined;
//     }
//   }

//   String _getStatusText(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return 'Shipped';
//       case 'delivered':
//         return 'Delivered';
//       case 'cancelled':
//         return 'Cancelled';
//       case 'processing':
//         return 'Processing';
//       default:
//         return 'Order Placed';
//     }
//   }

//   String _getStatusDescription(String status) {
//     switch (status.toLowerCase()) {
//       case 'shipped':
//         return 'Your order is on the way';
//       case 'delivered':
//         return 'Your order has been delivered';
//       case 'cancelled':
//         return 'Your order has been cancelled';
//       case 'processing':
//         return "We're preparing your order";
//       default:
//         return "We've received your order";
//     }
//   }
// }