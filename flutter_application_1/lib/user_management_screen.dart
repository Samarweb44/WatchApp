// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class OrderManagementScreen extends StatelessWidget {
//   const OrderManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Management'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () => _showFilterDialog(context),
//           ),
//         ],
//       ),
//       body: const OrderList(),
//     );
//   }

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Orders'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Add filter options here
//             const Text('Filter options coming soon...'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CLOSE'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderList extends StatelessWidget {
//   const OrderList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             itemCount: snapshot.data!.docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final order = snapshot.data!.docs[index];
//               return OrderCard(
//                 key: ValueKey(order.id),
//                 orderId: order.id,
//                 orderData: order.data() as Map<String, dynamic>,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> orderData;

//   const OrderCard({
//     super.key,
//     required this.orderId,
//     required this.orderData,
//   });

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   late String _currentStatus;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
//   }

//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown date';
//     return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Colors.orange;
//       case 'processing': return Colors.blue;
//       case 'shipped': return Colors.purple;
//       case 'delivered': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Icons.access_time;
//       case 'processing': return Icons.autorenew;
//       case 'shipped': return Icons.local_shipping;
//       case 'delivered': return Icons.check_circle;
//       case 'cancelled': return Icons.cancel;
//       default: return Icons.help_outline;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.orderData['items'] as List<dynamic>? ?? [];
//     final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
//     final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
//     final createdAt = widget.orderData['createdAt'] as Timestamp?;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ExpansionTile(
//         leading: _buildStatusIndicator(),
//         title: Text(
//           customerName,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatDate(createdAt),
//               style: const TextStyle(fontSize: 12),
//             ),
//             Text(
//               'Total: \$${totalAmount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Order Summary Section
//                 _buildSectionHeader('ORDER SUMMARY'),
//                 _buildDetailRow('Order ID:', widget.orderId),
//                 _buildDetailRow('Status:', _currentStatus),
//                 _buildDetailRow('Date:', _formatDate(createdAt)),
//                 _buildDetailRow('Total:', '\$${totalAmount.toStringAsFixed(2)}'),
                
//                 // Customer Information
//                 _buildSectionHeader('CUSTOMER INFO'),
//                 _buildDetailRow('Name:', customerName),
//                 _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'Not provided'),
//                 _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'Not provided'),
                
//                 // Shipping Information
//                 _buildSectionHeader('SHIPPING INFO'),
//                 _buildDetailRow('Address:', widget.orderData['shippingAddress']?.toString() ?? 'Not provided'),
                
//                 // Order Items
//                 _buildSectionHeader('ORDER ITEMS (${items.length})'),
//                 const SizedBox(height: 8),
//                 ...items.map((item) => _buildOrderItem(item)).toList(),
                
//                 // Status Actions
//                 _buildStatusDropdown(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_currentStatus).withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         _currentStatus.substring(0, 1).toUpperCase(),
//         style: TextStyle(
//           color: _getStatusColor(_currentStatus),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color.fromARGB(255, 4, 66, 85),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final imageUrl = itemMap['imageUrl'] as String?;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             // Product Image
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.grey[100],
//               ),
//               child: imageUrl != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => 
//                           const Icon(Icons.image_not_supported, size: 24),
//                       ),
//                     )
//                   : const Icon(Icons.image_not_supported, size: 24),
//             ),
//             const SizedBox(width: 12),
            
//             // Product Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${price.toStringAsFixed(2)} × $quantity',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Total Price
//             Text(
//               '\$${(price * quantity).toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusDropdown() {
//     final List<String> allStatuses = [
//       'PENDING',
//       'PROCESSING',
//       'SHIPPED',
//       'DELIVERED',
//       'CANCELLED'
//     ];

//     return DropdownButtonFormField<String>(
//       value: _currentStatus.toUpperCase(),
//       isExpanded: true,
//       decoration: InputDecoration(
//         labelText: 'Change Status',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       items: allStatuses.map((status) {
//         return DropdownMenuItem<String>(
//           value: status,
//           child: Row(
//             children: [
//               Icon(
//                 _getStatusIcon(status),
//                 size: 20,
//                 color: _getStatusColor(status),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 status,
//                 style: TextStyle(
//                   color: _getStatusColor(status),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: _isUpdating ? null : (newStatus) {
//         if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
//           _updateOrderStatus(newStatus);
//         }
//       },
//     );
//   }
//   // Update the _OrderCardState class in your existing order_management_screen.dart
// // Add this method to handle tracking number input
// Future<void> _addTrackingNumber() async {
//   final trackingController = TextEditingController();
//   final carrierController = TextEditingController();

//   await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Add Tracking Information'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: trackingController,
//             decoration: const InputDecoration(
//               labelText: 'Tracking Number',
//               hintText: 'Enter tracking number',
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: carrierController,
//             decoration: const InputDecoration(
//               labelText: 'Carrier',
//               hintText: 'e.g., FedEx, UPS, USPS',
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('CANCEL'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (trackingController.text.isNotEmpty) {
//               try {
//                 await FirebaseFirestore.instance
//                     .collection('orders')
//                     .doc(widget.orderId)
//                     .update({
//                   'trackingNumber': trackingController.text,
//                   'carrier': carrierController.text,
//                   'orderStatus': 'Shipped',
//                   'updatedAt': FieldValue.serverTimestamp(),
//                 });
//                 if (!context.mounted) return;
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Tracking number added successfully'),
//                   ),
//                 );
//               } catch (e) {
//                 if (!context.mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Failed to add tracking number: $e'),
//                   ),
//                 );
//               }
//             }
//           },
//           child: const Text('SAVE'),
//         ),
//       ],
//     ),
//   );
// }

// // Add this widget to your OrderCard build method (after the status dropdown)
// Widget _buildTrackingInfo() {
//   final trackingNumber = widget.orderData['trackingNumber'] as String?;
//   final carrier = widget.orderData['carrier'] as String?;

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       _buildSectionHeader('SHIPPING INFO'),
//       if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
//         _buildDetailRow('Tracking #:', trackingNumber),
//         if (carrier != null && carrier.isNotEmpty)
//           _buildDetailRow('Carrier:', carrier),
//       ] else if (_currentStatus == 'SHIPPED' || _currentStatus == 'DELIVERED') ...[
//         _buildDetailRow('Tracking #:', 'Not provided'),
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: _isUpdating ? null : _addTrackingNumber,
//           child: const Text('Add Tracking Number'),
//         ),
//       ],
//     ],
//   );
// }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'orderStatus': newStatus,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Update local state immediately
//       setState(() {
//         _currentStatus = newStatus;
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Status updated to $newStatus'),
//           backgroundColor: _getStatusColor(newStatus),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// class OrderManagementScreen extends StatelessWidget {
//   const OrderManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Management'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () => _showFilterDialog(context),
//           ),
//         ],
//       ),
//       body: const OrderList(),
//     );
//   }

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Orders'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Add filter options here
//             const Text('Filter options coming soon...'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CLOSE'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderList extends StatelessWidget {
//   const OrderList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             itemCount: snapshot.data!.docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final order = snapshot.data!.docs[index];
//               return OrderCard(
//                 key: ValueKey(order.id),
//                 orderId: order.id,
//                 orderData: order.data() as Map<String, dynamic>,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> orderData;

//   const OrderCard({
//     super.key,
//     required this.orderId,
//     required this.orderData,
//   });

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   late String _currentStatus;
//   bool _isUpdating = false;
//   final Uuid _uuid = const Uuid();

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
//   }

//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown date';
//     return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Colors.orange;
//       case 'processing': return Colors.blue;
//       case 'shipped': return Colors.purple;
//       case 'delivered': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Icons.access_time;
//       case 'processing': return Icons.autorenew;
//       case 'shipped': return Icons.local_shipping;
//       case 'delivered': return Icons.check_circle;
//       case 'cancelled': return Icons.cancel;
//       default: return Icons.help_outline;
//     }
//   }

//   String _generateTrackingNumber() {
//     // Generate a unique tracking number with format: SHIP-{UUID}-{DATE}
//     final date = DateFormat('yyMMdd').format(DateTime.now());
//     final uuid = _uuid.v4().substring(0, 8).toUpperCase();
//     return 'SHIP-$date-$uuid';
//   }

//   Future<void> _sendNotificationToUser(String status, String? trackingNumber) async {
//     try {
//       final userId = widget.orderData['userId'] as String?;
//       if (userId == null) return;

//       // Get user's FCM token if available
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       final fcmToken = userDoc.data()?['fcmToken'] as String?;
      
//       // Update the order with notification timestamp
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Here you would typically send a push notification using FCM
//       if (fcmToken != null) {
//         // In a real app, you would send a push notification here
//         // Example:
//         // await FirebaseMessaging.instance.send(
//         //   to: fcmToken,
//         //   data: {
//         //     'title': 'Order Update',
//         //     'body': 'Your order status has changed to $status',
//         //     'orderId': widget.orderId,
//         //   },
//         // );
//       }
//     } catch (e) {
//       debugPrint('Error sending notification: $e');
//     }
//   }

//   Future<void> _addTrackingNumber() async {
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier'] ?? 'UPS' // Default carrier
//     );

//     try {
//       setState(() => _isUpdating = true);
      
//       // Generate tracking number automatically
//       final trackingNumber = _generateTrackingNumber();
      
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'trackingNumber': trackingNumber,
//         'carrier': carrierController.text.trim(),
//         'orderStatus': 'shipped',
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Send notification to user
//       await _sendNotificationToUser('shipped', trackingNumber);

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Tracking number generated and order shipped'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       setState(() {
//         _currentStatus = 'shipped';
//         _isUpdating = false;
//       });
//     } catch (e) {
//       setState(() => _isUpdating = false);
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to add tracking number: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _editTrackingNumber() async {
//     final trackingController = TextEditingController(
//       text: widget.orderData['trackingNumber']?.toString() ?? ''
//     );
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier']?.toString() ?? 'UPS'
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Tracking Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: const InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: const InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (trackingController.text.isNotEmpty) {
//                 try {
//                   setState(() => _isUpdating = true);
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.orderId)
//                       .update({
//                     'trackingNumber': trackingController.text.trim(),
//                     'carrier': carrierController.text.trim(),
//                     'updatedAt': FieldValue.serverTimestamp(),
//                   });

//                   // Send notification to user
//                   await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tracking information updated'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   setState(() => _isUpdating = false);
//                 } catch (e) {
//                   setState(() => _isUpdating = false);
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to update tracking: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text('UPDATE'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTrackingInfo() {
//     final trackingNumber = widget.orderData['trackingNumber'] as String?;
//     final carrier = widget.orderData['carrier'] as String?;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 12),
//         _buildSectionHeader('SHIPPING INFO'),
//         if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
//           _buildDetailRow('Tracking #:', trackingNumber),
//           if (carrier != null && carrier.isNotEmpty)
//             _buildDetailRow('Carrier:', carrier),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : _editTrackingNumber,
//             child: const Text('Edit Tracking Info'),
//           ),
//         ] else if (_currentStatus == 'shipped' || _currentStatus == 'delivered') ...[
//           _buildDetailRow('Tracking #:', 'Not generated yet'),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : _addTrackingNumber,
//             child: const Text('Generate Tracking Number'),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_currentStatus).withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         _currentStatus.substring(0, 1).toUpperCase(),
//         style: TextStyle(
//           color: _getStatusColor(_currentStatus),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color.fromARGB(255, 4, 66, 85),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final imageUrl = itemMap['imageUrl'] as String?;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             // Product Image
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.grey[100],
//               ),
//               child: imageUrl != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => 
//                           const Icon(Icons.image_not_supported, size: 24),
//                       ),
//                     )
//                   : const Icon(Icons.image_not_supported, size: 24),
//             ),
//             const SizedBox(width: 12),
            
//             // Product Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${price.toStringAsFixed(2)} × $quantity',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Total Price
//             Text(
//               '\$${(price * quantity).toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusDropdown() {
//     final List<String> allStatuses = [
//       'PENDING',
//       'PROCESSING',
//       'SHIPPED',
//       'DELIVERED',
//       'CANCELLED'
//     ];

//     return DropdownButtonFormField<String>(
//       value: _currentStatus.toUpperCase(),
//       isExpanded: true,
//       decoration: InputDecoration(
//         labelText: 'Change Status',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       items: allStatuses.map((status) {
//         return DropdownMenuItem<String>(
//           value: status,
//           child: Row(
//             children: [
//               Icon(
//                 _getStatusIcon(status),
//                 size: 20,
//                 color: _getStatusColor(status),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 status,
//                 style: TextStyle(
//                   color: _getStatusColor(status),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: _isUpdating ? null : (newStatus) {
//         if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
//           _updateOrderStatus(newStatus);
//         }
//       },
//     );
//   }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       // Automatically generate tracking number when status changes to shipped
//       if (newStatus == 'SHIPPED' && widget.orderData['trackingNumber'] == null) {
//         final trackingNumber = _generateTrackingNumber();
//         await FirebaseFirestore.instance
//             .collection('orders')
//             .doc(widget.orderId)
//             .update({
//           'orderStatus': newStatus,
//           'trackingNumber': trackingNumber,
//           'carrier': 'UPS', // Default carrier
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//       } else {
//         await FirebaseFirestore.instance
//             .collection('orders')
//             .doc(widget.orderId)
//             .update({
//           'orderStatus': newStatus,
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//       }

//       // Send notification to user for important status changes
//       if (newStatus == 'SHIPPED' || newStatus == 'DELIVERED' || newStatus == 'CANCELLED') {
//         await _sendNotificationToUser(newStatus, widget.orderData['trackingNumber']);
//       }

//       // Update local state immediately
//       setState(() {
//         _currentStatus = newStatus;
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Status updated to $newStatus'),
//           backgroundColor: _getStatusColor(newStatus),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.orderData['items'] as List<dynamic>? ?? [];
//     final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
//     final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
//     final createdAt = widget.orderData['createdAt'] as Timestamp?;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ExpansionTile(
//         leading: _buildStatusIndicator(),
//         title: Text(
//           customerName,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatDate(createdAt),
//               style: const TextStyle(fontSize: 12),
//             ),
//             Text(
//               'Total: \$${totalAmount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Order Summary Section
//                 _buildSectionHeader('ORDER SUMMARY'),
//                 _buildDetailRow('Order ID:', widget.orderId),
//                 _buildDetailRow('Status:', _currentStatus),
//                 _buildDetailRow('Date:', _formatDate(createdAt)),
//                 _buildDetailRow('Total:', '\$${totalAmount.toStringAsFixed(2)}'),
                
//                 // Customer Information
//                 _buildSectionHeader('CUSTOMER INFO'),
//                 _buildDetailRow('Name:', customerName),
//                 _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'Not provided'),
//                 _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'Not provided'),
                
//                 // Shipping Information
//                 _buildTrackingInfo(),
                
//                 // Order Items
//                 _buildSectionHeader('ORDER ITEMS (${items.length})'),
//                 const SizedBox(height: 8),
//                 ...items.map((item) => _buildOrderItem(item)).toList(),
                
//                 // Status Actions
//                 _buildStatusDropdown(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// // Define the color palette for consistency
// class AppColors {
//   static const Color primaryBlack = Color(0xFF1A1A1A); // Dark charcoal/black
//   static const Color accentYellow = Color(0xFFFFD166); // Muted yellow
//   static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white
//   static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for card backgrounds
//   static const Color textLightGrey = Color(0xFF616161); // For secondary text
//   static const Color borderGrey = Color(0xFFE0E0E0); // Light grey for borders
// }

// class OrderManagementScreen extends StatelessWidget {
//   const OrderManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Order Management',
//           style: TextStyle(color: AppColors.backgroundWhite, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.primaryBlack, // Black app bar
//         elevation: 4,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: AppColors.accentYellow), // Yellow filter icon
//             onPressed: () => _showFilterDialog(context),
//             tooltip: 'Filter Orders',
//           ),
//         ],
//       ),
//       body: const OrderList(),
//       backgroundColor: AppColors.backgroundWhite, // White background for the scaffold
//     );
//   }

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(
//           'Filter Orders',
//           style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
//         ),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Filter options coming soon...',
//               style: TextStyle(color: AppColors.textLightGrey),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'CLOSE',
//               style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: AppColors.backgroundWhite,
//       ),
//     );
//   }
// }



// class OrderList extends StatelessWidget {
//   const OrderList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text(
//               'Error: ${snapshot.error}',
//               style: const TextStyle(color: AppColors.primaryBlack),
//             ));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: AppColors.accentYellow,
//             ));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18, color: AppColors.textLightGrey),
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: snapshot.data!.docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final order = snapshot.data!.docs[index];
//               return OrderCard(
//                 key: ValueKey(order.id),
//                 orderId: order.id,
//                 orderData: order.data() as Map<String, dynamic>,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> orderData;

//   const OrderCard({
//     super.key,
//     required this.orderId,
//     required this.orderData,
//   });

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   late String _currentStatus;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
//   }

//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown date';
//     return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
//   }

//   // Define more vibrant colors for status based on the theme
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange.shade700;
//       case 'processing':
//         return AppColors.accentYellow; // Use accent yellow for processing
//       case 'shipped':
//         return Colors.blue.shade700;
//       case 'delivered':
//         return Colors.green.shade700;
//       case 'cancelled':
//         return Colors.red.shade700;
//       default:
//         return AppColors.textLightGrey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Icons.access_time_filled;
//       case 'processing':
//         return Icons.hourglass_full;
//       case 'shipped':
//         return Icons.local_shipping;
//       case 'delivered':
//         return Icons.check_circle;
//       case 'cancelled':
//         return Icons.cancel;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   Future<void> _sendNotificationToUser(String status, String? trackingNumber) async {
//     // This is a placeholder for actual notification logic.
//     // In a real application, you would integrate with a notification service (e.g., Firebase Cloud Messaging)
//     // to send a push notification to the user associated with this order.
//     // The 'updatedAt' field is already being updated in Firestore.
//     try {
//       final userId = widget.orderData['userId'] as String?;
//       if (userId == null) {
//         debugPrint('User ID not found for order ${widget.orderId}. Cannot send notification.');
//         return;
//       }
//       debugPrint('Simulating notification for user $userId: Order ${widget.orderId} status changed to $status.');
//       if (trackingNumber != null && status.toLowerCase() == 'shipped') {
//         debugPrint('Tracking number: $trackingNumber');
//       }
//     } catch (e) {
//       debugPrint('Error simulating notification: $e');
//     }
//   }

//   Future<void> _addTrackingNumber() async {
//     final trackingController = TextEditingController();
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier'] ?? 'UPS', // Default carrier
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Tracking Information', style: TextStyle(color: AppColors.primaryBlack)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.borderGrey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
//                 ),
//               ),
//               style: const TextStyle(color: AppColors.primaryBlack),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.borderGrey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
//                 ),
//               ),
//               style: const TextStyle(color: AppColors.primaryBlack),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL', style: TextStyle(color: AppColors.textLightGrey)),
//           ),
//           ElevatedButton(
//             onPressed: _isUpdating
//                 ? null
//                 : () async {
//                     if (trackingController.text.isNotEmpty) {
//                       try {
//                         setState(() => _isUpdating = true);
//                         await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
//                           'trackingNumber': trackingController.text.trim(),
//                           'carrier': carrierController.text.trim(),
//                           'updatedAt': FieldValue.serverTimestamp(),
//                         });

//                         await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                         if (!context.mounted) return;
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Tracking number added successfully!'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         setState(() => _isUpdating = false);
//                       } catch (e) {
//                         setState(() => _isUpdating = false);
//                         if (!context.mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Failed to add tracking number: $e'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.accentYellow, // Yellow button
//               foregroundColor: AppColors.primaryBlack, // Black text on button
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: _isUpdating
//                 ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primaryBlack, strokeWidth: 2))
//                 : const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: AppColors.backgroundWhite,
//       ),
//     );
//   }

//   Future<void> _editTrackingNumber() async {
//     final trackingController = TextEditingController(
//       text: widget.orderData['trackingNumber']?.toString() ?? '',
//     );
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier']?.toString() ?? 'UPS',
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Tracking Information', style: TextStyle(color: AppColors.primaryBlack)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.borderGrey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
//                 ),
//               ),
//               style: const TextStyle(color: AppColors.primaryBlack),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.borderGrey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
//                 ),
//               ),
//               style: const TextStyle(color: AppColors.primaryBlack),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL', style: TextStyle(color: AppColors.textLightGrey)),
//           ),
//           ElevatedButton(
//             onPressed: _isUpdating
//                 ? null
//                 : () async {
//                     if (trackingController.text.isNotEmpty) {
//                       try {
//                         setState(() => _isUpdating = true);
//                         await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
//                           'trackingNumber': trackingController.text.trim(),
//                           'carrier': carrierController.text.trim(),
//                           'updatedAt': FieldValue.serverTimestamp(),
//                         });

//                         await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                         if (!context.mounted) return;
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Tracking information updated!'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         setState(() => _isUpdating = false);
//                       } catch (e) {
//                         setState(() => _isUpdating = false);
//                         if (!context.mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Failed to update tracking: $e'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.accentYellow, // Yellow button
//               foregroundColor: AppColors.primaryBlack, // Black text on button
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: _isUpdating
//                 ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primaryBlack, strokeWidth: 2))
//                 : const Text('UPDATE', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: AppColors.backgroundWhite,
//       ),
//     );
//   }

//   Widget _buildTrackingInfo() {
//     final trackingNumber = widget.orderData['trackingNumber'] as String?;
//     final carrier = widget.orderData['carrier'] as String?;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader('SHIPPING INFO'),
//         if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
//           _buildDetailRow('Tracking #:', trackingNumber),
//           if (carrier != null && carrier.isNotEmpty) _buildDetailRow('Carrier:', carrier),
//           const SizedBox(height: 12),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: _isUpdating ? null : _editTrackingNumber,
//               icon: const Icon(Icons.edit, color: AppColors.primaryBlack),
//               label: const Text(
//                 'Edit Tracking Info',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.accentYellow,
//                 foregroundColor: AppColors.primaryBlack,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//             ),
//           ),
//         ] else ...[
//           const SizedBox(height: 8),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: _isUpdating ? null : _addTrackingNumber,
//               icon: const Icon(Icons.add_task, color: AppColors.primaryBlack),
//               label: const Text(
//                 'Add Tracking Number',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.accentYellow,
//                 foregroundColor: AppColors.primaryBlack,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_currentStatus).withOpacity(0.1), // Lighter background for the circle
//         shape: BoxShape.circle,
//         border: Border.all(color: _getStatusColor(_currentStatus), width: 1.5), // Border with status color
//       ),
//       child: Icon(
//         _getStatusIcon(_currentStatus),
//         color: _getStatusColor(_currentStatus),
//         size: 28, // Slightly larger icon
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: AppColors.primaryBlack, // Black header text
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 90, // Adjusted width for labels
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primaryBlack, // Dark text for labels
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: AppColors.textLightGrey, // Light grey for values
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final imageUrl = itemMap['imageUrl'] as String?;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 1, // Subtle elevation for item cards
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: const BorderSide(color: AppColors.borderGrey), // Light border
//       ),
//       color: AppColors.backgroundWhite, // White background for inner item cards
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Container(
//               width: 60, // Larger image container
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: AppColors.cardBackground, // Light grey background for image placeholder
//               ),
//               child: imageUrl != null && Uri.tryParse(imageUrl)?.hasAbsolutePath == true
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(Icons.broken_image, size: 30, color: AppColors.textLightGrey), // More prominent broken image icon
//                       ),
//                     )
//                   : const Icon(Icons.image_not_supported, size: 30, color: AppColors.textLightGrey),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       color: AppColors.primaryBlack,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Price: \$${price.toStringAsFixed(2)} | Qty: $quantity',
//                     style: const TextStyle(fontSize: 13, color: AppColors.textLightGrey),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               '\$${(price * quantity).toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: AppColors.primaryBlack,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusDropdown() {
//     final List<String> allStatuses = [
//       'PENDING',
//       'PROCESSING',
//       'SHIPPED',
//       'DELIVERED',
//       'CANCELLED',
//     ];

//     return AbsorbPointer(
//       absorbing: _isUpdating, // Disable dropdown while updating
//       child: DropdownButtonFormField<String>(
//         value: _currentStatus.toUpperCase(),
//         isExpanded: true,
//         decoration: InputDecoration(
//           labelText: 'Update Order Status',
//           labelStyle: const TextStyle(color: AppColors.primaryBlack),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: AppColors.borderGrey),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: AppColors.borderGrey),
//           ),
//           filled: true,
//           fillColor: AppColors.backgroundWhite,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//         dropdownColor: AppColors.backgroundWhite,
//         icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlack),
//         items: allStatuses.map((status) {
//           return DropdownMenuItem<String>(
//             value: status,
//             child: Row(
//               children: [
//                 Icon(
//                   _getStatusIcon(status),
//                   size: 20,
//                   color: _getStatusColor(status),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   status,
//                   style: TextStyle(
//                     color: _getStatusColor(status),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         onChanged: (newStatus) {
//           if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
//             _updateOrderStatus(newStatus);
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
//         'orderStatus': newStatus,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       await _sendNotificationToUser(newStatus, widget.orderData['trackingNumber']);

//       setState(() {
//         _currentStatus = newStatus;
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Status updated to $newStatus!'),
//           backgroundColor: _getStatusColor(newStatus),
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating, // Make it float for better visibility
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.orderData['items'] as List<dynamic>? ?? [];
//     final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
//     final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
//     final createdAt = widget.orderData['createdAt'] as Timestamp?;

//     return Card(
//       elevation: 6, // Increased elevation for a floating effect
//       shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15), // More rounded corners
//       ),
//       color: AppColors.cardBackground, // Light grey card background
//       child: Theme(
//         // Override the default ExpansionTile theme for a cleaner look
//         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//           tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           leading: _buildStatusIndicator(),
//           title: Text(
//             customerName.isEmpty ? 'Unknown Customer' : customerName,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: AppColors.primaryBlack,
//             ),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 4),
//               Text(
//                 _formatDate(createdAt),
//                 style: const TextStyle(fontSize: 13, color: AppColors.textLightGrey),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Total: \$${totalAmount.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 15,
//                   color: AppColors.primaryBlack,
//                 ),
//               ),
//             ],
//           ),
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Adjust padding for inner content
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionHeader('ORDER SUMMARY'),
//                   _buildDetailRow('Order ID:', widget.orderId),
//                   _buildDetailRow('Current Status:', _currentStatus),
//                   _buildDetailRow('Order Date:', _formatDate(createdAt)),
//                   _buildDetailRow('Order Total:', '\$${totalAmount.toStringAsFixed(2)}'),

//                   _buildSectionHeader('CUSTOMER INFO'),
//                   _buildDetailRow('Name:', customerName.isEmpty ? 'N/A' : customerName),
//                   _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'N/A'),
//                   _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'N/A'),

//                   _buildTrackingInfo(), // Tracking info section

//                   _buildSectionHeader('ORDER ITEMS (${items.length})'),
//                   const SizedBox(height: 8),
//                   if (items.isEmpty)
//                     const Text('No items in this order.', style: TextStyle(color: AppColors.textLightGrey))
//                   else
//                     ...items.map((item) => _buildOrderItem(item)).toList(),

//                   const SizedBox(height: 16),
//                   _buildStatusDropdown(), // Status update dropdown
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }////////////////////////////////this is final codeeeeeeeeeeeeeeeeeeeeeeeeee


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Define the color palette for consistency
class AppColors {
  static const Color primaryBlack = Color(0xFF1A1A1A); // Dark charcoal/black
  static const Color accentYellow = Color(0xFFFFD166); // Muted yellow
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for card backgrounds
  static const Color textLightGrey = Color(0xFF616161); // For secondary text
  static const Color borderGrey = Color(0xFFE0E0E0); // Light grey for borders
}

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack, // Black app bar
        elevation: 4,
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: AppColors.backgroundWhite),
          cursorColor: AppColors.accentYellow,
          decoration: InputDecoration(
            hintText: 'Search by customer name or Order ID...',
            hintStyle: TextStyle(color: AppColors.backgroundWhite.withOpacity(0.7)),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.backgroundWhite),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.backgroundWhite),
                    onPressed: _clearSearch,
                    tooltip: 'Clear Search',
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.accentYellow), // Yellow filter icon
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter Orders',
          ),
        ],
      ),
      body: OrderList(searchQuery: _searchQuery),
      backgroundColor: AppColors.backgroundWhite, // White background for the scaffold
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Filter Orders',
          style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter options coming soon...',
              style: TextStyle(color: AppColors.textLightGrey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CLOSE',
              style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.backgroundWhite,
      ),
    );
  }
}


class OrderList extends StatefulWidget {
  final String searchQuery;

  const OrderList({super.key, required this.searchQuery});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: _buildOrderStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.primaryBlack),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentYellow,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.searchQuery.isEmpty ? Icons.inbox_rounded : Icons.search_off_rounded,
                    size: 80,
                    color: AppColors.textLightGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.searchQuery.isEmpty ? 'No orders found' : 'No orders match your search',
                    style: const TextStyle(fontSize: 18, color: AppColors.textLightGrey),
                  ),
                  if (widget.searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Try searching for a different customer name or order ID.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.textLightGrey.withOpacity(0.8)),
                      ),
                    ),
                ],
              ),
            );
          }

          final filteredDocs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final customerName = (data['customerName'] as String? ?? '').toLowerCase();
            final orderId = doc.id.toLowerCase(); // Use document ID for order ID search
            final query = widget.searchQuery.toLowerCase();

            return customerName.contains(query) || orderId.contains(query);
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 80,
                    color: AppColors.textLightGrey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders match your search',
                    style: TextStyle(fontSize: 18, color: AppColors.textLightGrey),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Try searching for a different customer name or order ID.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textLightGrey.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredDocs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = filteredDocs[index];
              return OrderCard(
                key: ValueKey(order.id),
                orderId: order.id,
                orderData: order.data() as Map<String, dynamic>,
              );
            },
          );
        },
      ),
    );
  }

  // Helper to build the Firestore stream dynamically based on search query
  Stream<QuerySnapshot> _buildOrderStream() {
    final CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');

    if (widget.searchQuery.isEmpty) {
      return ordersRef.orderBy('createdAt', descending: true).snapshots();
    } else {
      // For more robust search, you might need an external search service (e.g., Algolia)
      // or to store searchable fields in a way that supports full-text search.
      // Firestore's `where` clause is limited to prefix matching for single fields.
      // Here, we'll fetch all and filter in-memory for simplicity.
      // For large datasets, this approach can be inefficient.
      return ordersRef.orderBy('createdAt', descending: true).snapshots();
    }
  }
}



class OrderCard extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String _currentStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
  }

  // Define more vibrant colors for status based on the theme
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'processing':
        return AppColors.accentYellow; // Use accent yellow for processing
      case 'shipped':
        return Colors.blue.shade700;
      case 'delivered':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return AppColors.textLightGrey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time_filled;
      case 'processing':
        return Icons.hourglass_full;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _sendNotificationToUser(String status, String? trackingNumber) async {
    // This is a placeholder for actual notification logic.
    // In a real application, you would integrate with a notification service (e.g., Firebase Cloud Messaging)
    // to send a push notification to the user associated with this order.
    // The 'updatedAt' field is already being updated in Firestore.
    try {
      final userId = widget.orderData['userId'] as String?;
      if (userId == null) {
        debugPrint('User ID not found for order ${widget.orderId}. Cannot send notification.');
        return;
      }
      debugPrint('Simulating notification for user $userId: Order ${widget.orderId} status changed to $status.');
      if (trackingNumber != null && status.toLowerCase() == 'shipped') {
        debugPrint('Tracking number: $trackingNumber');
      }
    } catch (e) {
      debugPrint('Error simulating notification: $e');
    }
  }

  Future<void> _addTrackingNumber() async {
    final trackingController = TextEditingController();
    final carrierController = TextEditingController(
      text: widget.orderData['carrier'] ?? 'UPS', // Default carrier
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tracking Information', style: TextStyle(color: AppColors.primaryBlack)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trackingController,
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                hintText: 'Enter tracking number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                ),
              ),
              style: const TextStyle(color: AppColors.primaryBlack),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: carrierController,
              decoration: InputDecoration(
                labelText: 'Carrier',
                hintText: 'e.g., FedEx, UPS, USPS',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                ),
              ),
              style: const TextStyle(color: AppColors.primaryBlack),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textLightGrey)),
          ),
          ElevatedButton(
            onPressed: _isUpdating
                ? null
                : () async {
                    if (trackingController.text.isNotEmpty) {
                      try {
                        setState(() => _isUpdating = true);
                        await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
                          'trackingNumber': trackingController.text.trim(),
                          'carrier': carrierController.text.trim(),
                          'updatedAt': FieldValue.serverTimestamp(),
                        });

                        await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tracking number added successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() => _isUpdating = false);
                      } catch (e) {
                        setState(() => _isUpdating = false);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add tracking number: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentYellow, // Yellow button
              foregroundColor: AppColors.primaryBlack, // Black text on button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isUpdating
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primaryBlack, strokeWidth: 2))
                : const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.backgroundWhite,
      ),
    );
  }

  Future<void> _editTrackingNumber() async {
    final trackingController = TextEditingController(
      text: widget.orderData['trackingNumber']?.toString() ?? '',
    );
    final carrierController = TextEditingController(
      text: widget.orderData['carrier']?.toString() ?? 'UPS',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tracking Information', style: TextStyle(color: AppColors.primaryBlack)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trackingController,
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                hintText: 'Enter tracking number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                ),
              ),
              style: const TextStyle(color: AppColors.primaryBlack),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: carrierController,
              decoration: InputDecoration(
                labelText: 'Carrier',
                hintText: 'e.g., FedEx, UPS, USPS',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
                ),
              ),
              style: const TextStyle(color: AppColors.primaryBlack),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textLightGrey)),
          ),
          ElevatedButton(
            onPressed: _isUpdating
                ? null
                : () async {
                    if (trackingController.text.isNotEmpty) {
                      try {
                        setState(() => _isUpdating = true);
                        await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
                          'trackingNumber': trackingController.text.trim(),
                          'carrier': carrierController.text.trim(),
                          'updatedAt': FieldValue.serverTimestamp(),
                        });

                        await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tracking information updated!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() => _isUpdating = false);
                      } catch (e) {
                        setState(() => _isUpdating = false);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update tracking: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentYellow, // Yellow button
              foregroundColor: AppColors.primaryBlack, // Black text on button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isUpdating
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primaryBlack, strokeWidth: 2))
                : const Text('UPDATE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.backgroundWhite,
      ),
    );
  }

  Widget _buildTrackingInfo() {
    final trackingNumber = widget.orderData['trackingNumber'] as String?;
    final carrier = widget.orderData['carrier'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SHIPPING INFO'),
        if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
          _buildDetailRow('Tracking #:', trackingNumber),
          if (carrier != null && carrier.isNotEmpty) _buildDetailRow('Carrier:', carrier),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: _isUpdating ? null : _editTrackingNumber,
              icon: const Icon(Icons.edit, color: AppColors.primaryBlack),
              label: const Text(
                'Edit Tracking Info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.primaryBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton.icon(
              onPressed: _isUpdating ? null : _addTrackingNumber,
              icon: const Icon(Icons.add_task, color: AppColors.primaryBlack),
              label: const Text(
                'Add Tracking Number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.primaryBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getStatusColor(_currentStatus).withOpacity(0.1), // Lighter background for the circle
        shape: BoxShape.circle,
        border: Border.all(color: _getStatusColor(_currentStatus), width: 1.5), // Border with status color
      ),
      child: Icon(
        _getStatusIcon(_currentStatus),
        color: _getStatusColor(_currentStatus),
        size: 28, // Slightly larger icon
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlack, // Black header text
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90, // Adjusted width for labels
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack, // Dark text for labels
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLightGrey, // Light grey for values
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final itemMap = item as Map<String, dynamic>;
    final imageUrl = itemMap['imageUrl'] as String?;
    final name = itemMap['name']?.toString() ?? 'No Name';
    final price = (itemMap['price'] as num? ?? 0).toDouble();
    final quantity = itemMap['quantity'] as int? ?? 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1, // Subtle elevation for item cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.borderGrey), // Light border
      ),
      color: AppColors.backgroundWhite, // White background for inner item cards
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60, // Larger image container
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.cardBackground, // Light grey background for image placeholder
              ),
              child: imageUrl != null && Uri.tryParse(imageUrl)?.hasAbsolutePath == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 30, color: AppColors.textLightGrey), // More prominent broken image icon
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
                  : const Icon(Icons.image_not_supported, size: 30, color: AppColors.textLightGrey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.primaryBlack,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)} | Qty: $quantity',
                    style: const TextStyle(fontSize: 13, color: AppColors.textLightGrey),
                  ),
                ],
              ),
            ),
            Text(
              '\$${(price * quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final List<String> allStatuses = [
      'PENDING',
      'PROCESSING',
      'SHIPPED',
      'DELIVERED',
      'CANCELLED',
    ];

    return AbsorbPointer(
      absorbing: _isUpdating, // Disable dropdown while updating
      child: DropdownButtonFormField<String>(
        value: _currentStatus.toUpperCase(),
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Update Order Status',
          labelStyle: const TextStyle(color: AppColors.primaryBlack),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentYellow, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          filled: true,
          fillColor: AppColors.backgroundWhite,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dropdownColor: AppColors.backgroundWhite,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlack),
        items: allStatuses.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  size: 20,
                  color: _getStatusColor(status),
                ),
                const SizedBox(width: 12),
                Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newStatus) {
          if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
            _updateOrderStatus(newStatus);
          }
        },
      ),
    );
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
        'orderStatus': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _sendNotificationToUser(newStatus, widget.orderData['trackingNumber']);

      setState(() {
        _currentStatus = newStatus;
        _isUpdating = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus!'),
          backgroundColor: _getStatusColor(newStatus),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Make it float for better visibility
        ),
      );
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.orderData['items'] as List<dynamic>? ?? [];
    final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
    final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
    final createdAt = widget.orderData['createdAt'] as Timestamp?;

    return Card(
      elevation: 6, // Increased elevation for a floating effect
      shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // More rounded corners
      ),
      color: AppColors.cardBackground, // Light grey card background
      child: Theme(
        // Override the default ExpansionTile theme for a cleaner look
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _buildStatusIndicator(),
          title: Text(
            customerName.isEmpty ? 'Unknown Customer' : customerName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryBlack,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                _formatDate(createdAt),
                style: const TextStyle(fontSize: 13, color: AppColors.textLightGrey),
              ),
              const SizedBox(height: 4),
              Text(
                'Total: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.primaryBlack,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Adjust padding for inner content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('ORDER SUMMARY'),
                  _buildDetailRow('Order ID:', widget.orderId),
                  _buildDetailRow('Current Status:', _currentStatus),
                  _buildDetailRow('Order Date:', _formatDate(createdAt)),
                  _buildDetailRow('Order Total:', '\$${totalAmount.toStringAsFixed(2)}'),

                  _buildSectionHeader('CUSTOMER INFO'),
                  _buildDetailRow('Name:', customerName.isEmpty ? 'N/A' : customerName),
                  _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'N/A'),
                  _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'N/A'),

                  _buildTrackingInfo(), // Tracking info section

                  _buildSectionHeader('ORDER ITEMS (${items.length})'),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const Text('No items in this order.', style: TextStyle(color: AppColors.textLightGrey))
                  else
                    ...items.map((item) => _buildOrderItem(item)).toList(),

                  const SizedBox(height: 16),
                  _buildStatusDropdown(), // Status update dropdown
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////Perfectcode
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class OrderManagementScreen extends StatelessWidget {
//   const OrderManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Management'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () => _showFilterDialog(context),
//           ),
//         ],
//       ),
//       body: const OrderList(),
//     );
//   }

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Orders'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Filter options coming soon...'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CLOSE'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderList extends StatelessWidget {
//   const OrderList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             itemCount: snapshot.data!.docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final order = snapshot.data!.docs[index];
//               return OrderCard(
//                 key: ValueKey(order.id),
//                 orderId: order.id,
//                 orderData: order.data() as Map<String, dynamic>,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> orderData;

//   const OrderCard({
//     super.key,
//     required this.orderId,
//     required this.orderData,
//   });

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   late String _currentStatus;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
//   }

//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown date';
//     return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Colors.orange;
//       case 'processing': return Colors.blue;
//       case 'shipped': return Colors.purple;
//       case 'delivered': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Icons.access_time;
//       case 'processing': return Icons.autorenew;
//       case 'shipped': return Icons.local_shipping;
//       case 'delivered': return Icons.check_circle;
//       case 'cancelled': return Icons.cancel;
//       default: return Icons.help_outline;
//     }
//   }

//   Future<void> _sendNotificationToUser(String status, String? trackingNumber) async {
//     try {
//       final userId = widget.orderData['userId'] as String?;
//       if (userId == null) return;

//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Error sending notification: $e');
//     }
//   }

//   Future<void> _addTrackingNumber() async {
//     final trackingController = TextEditingController();
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier'] ?? 'UPS'
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Tracking Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: const InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: const InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (trackingController.text.isNotEmpty) {
//                 try {
//                   setState(() => _isUpdating = true);
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.orderId)
//                       .update({
//                     'trackingNumber': trackingController.text.trim(),
//                     'carrier': carrierController.text.trim(),
//                     'updatedAt': FieldValue.serverTimestamp(),
//                   });

//                   await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tracking number added successfully'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   setState(() => _isUpdating = false);
//                 } catch (e) {
//                   setState(() => _isUpdating = false);
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to add tracking number: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text('SAVE'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _editTrackingNumber() async {
//     final trackingController = TextEditingController(
//       text: widget.orderData['trackingNumber']?.toString() ?? ''
//     );
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier']?.toString() ?? 'UPS'
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Tracking Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: const InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: const InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (trackingController.text.isNotEmpty) {
//                 try {
//                   setState(() => _isUpdating = true);
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.orderId)
//                       .update({
//                     'trackingNumber': trackingController.text.trim(),
//                     'carrier': carrierController.text.trim(),
//                     'updatedAt': FieldValue.serverTimestamp(),
//                   });

//                   await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tracking information updated'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   setState(() => _isUpdating = false);
//                 } catch (e) {
//                   setState(() => _isUpdating = false);
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to update tracking: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text('UPDATE'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTrackingInfo() {
//     final trackingNumber = widget.orderData['trackingNumber'] as String?;
//     final carrier = widget.orderData['carrier'] as String?;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 12),
//         _buildSectionHeader('SHIPPING INFO'),
//         if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
//           _buildDetailRow('Tracking #:', trackingNumber),
//           if (carrier != null && carrier.isNotEmpty)
//             _buildDetailRow('Carrier:', carrier),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : _editTrackingNumber,
//             child: const Text('Edit Tracking Info'),
//           ),
//         ],
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: _isUpdating ? null : _addTrackingNumber,
//           child: const Text('Add Tracking Number'),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_currentStatus).withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         _currentStatus.substring(0, 1).toUpperCase(),
//         style: TextStyle(
//           color: _getStatusColor(_currentStatus),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color.fromARGB(255, 4, 66, 85),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final imageUrl = itemMap['imageUrl'] as String?;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.grey[100],
//               ),
//               child: imageUrl != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => 
//                           const Icon(Icons.image_not_supported, size: 24),
//                       ),
//                     )
//                   : const Icon(Icons.image_not_supported, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${price.toStringAsFixed(2)} × $quantity',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               '\$${(price * quantity).toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusDropdown() {
//     final List<String> allStatuses = [
//       'PENDING',
//       'PROCESSING',
//       'SHIPPED',
//       'DELIVERED',
//       'CANCELLED'
//     ];

//     return DropdownButtonFormField<String>(
//       value: _currentStatus.toUpperCase(),
//       isExpanded: true,
//       decoration: InputDecoration(
//         labelText: 'Change Status',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       items: allStatuses.map((status) {
//         return DropdownMenuItem<String>(
//           value: status,
//           child: Row(
//             children: [
//               Icon(
//                 _getStatusIcon(status),
//                 size: 20,
//                 color: _getStatusColor(status),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 status,
//                 style: TextStyle(
//                   color: _getStatusColor(status),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: _isUpdating ? null : (newStatus) {
//         if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
//           _updateOrderStatus(newStatus);
//         }
//       },
//     );
//   }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'orderStatus': newStatus,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       await _sendNotificationToUser(newStatus, widget.orderData['trackingNumber']);

//       setState(() {
//         _currentStatus = newStatus;
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Status updated to $newStatus'),
//           backgroundColor: _getStatusColor(newStatus),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.orderData['items'] as List<dynamic>? ?? [];
//     final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
//     final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
//     final createdAt = widget.orderData['createdAt'] as Timestamp?;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ExpansionTile(
//         leading: _buildStatusIndicator(),
//         title: Text(
//           customerName,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatDate(createdAt),
//               style: const TextStyle(fontSize: 12),
//             ),
//             Text(
//               'Total: \$${totalAmount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildSectionHeader('ORDER SUMMARY'),
//                 _buildDetailRow('Order ID:', widget.orderId),
//                 _buildDetailRow('Status:', _currentStatus),
//                 _buildDetailRow('Date:', _formatDate(createdAt)),
//                 _buildDetailRow('Total:', '\$${totalAmount.toStringAsFixed(2)}'),
                
//                 _buildSectionHeader('CUSTOMER INFO'),
//                 _buildDetailRow('Name:', customerName),
//                 _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'Not provided'),
//                 _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'Not provided'),
                
//                 _buildTrackingInfo(),
                
//                 _buildSectionHeader('ORDER ITEMS (${items.length})'),
//                 const SizedBox(height: 8),
//                 ...items.map((item) => _buildOrderItem(item)).toList(),
                
//                 _buildStatusDropdown(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class OrderManagementScreen extends StatelessWidget {
//   const OrderManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Management'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () => _showFilterDialog(context),
//           ),
//         ],
//       ),
//       body: const OrderList(),
//     );
//   }

//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Orders'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Add filter options here
//             const Text('Filter options coming soon...'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CLOSE'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderList extends StatelessWidget {
//   const OrderList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             itemCount: snapshot.data!.docs.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final order = snapshot.data!.docs[index];
//               return OrderCard(
//                 key: ValueKey(order.id),
//                 orderId: order.id,
//                 orderData: order.data() as Map<String, dynamic>,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final Map<String, dynamic> orderData;

//   const OrderCard({
//     super.key,
//     required this.orderId,
//     required this.orderData,
//   });

//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<OrderCard> {
//   late String _currentStatus;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = (widget.orderData['orderStatus'] as String? ?? 'Pending');
//   }

//   String _formatDate(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown date';
//     return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Colors.orange;
//       case 'processing': return Colors.blue;
//       case 'shipped': return Colors.purple;
//       case 'delivered': return Colors.green;
//       case 'cancelled': return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending': return Icons.access_time;
//       case 'processing': return Icons.autorenew;
//       case 'shipped': return Icons.local_shipping;
//       case 'delivered': return Icons.check_circle;
//       case 'cancelled': return Icons.cancel;
//       default: return Icons.help_outline;
//     }
//   }

//   Future<void> _sendNotificationToUser(String status, String? trackingNumber) async {
//     try {
//       final userId = widget.orderData['userId'] as String?;
//       if (userId == null) return;

//       // Get user's FCM token if available
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       final fcmToken = userDoc.data()?['fcmToken'] as String?;
      
//       // Update the order with notification timestamp
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Here you would typically send a push notification using FCM
//       if (fcmToken != null) {
//         // In a real app, you would send a push notification here
//         // Example:
//         // await FirebaseMessaging.instance.send(
//         //   to: fcmToken,
//         //   data: {
//         //     'title': 'Order Update',
//         //     'body': 'Your order status has changed to $status',
//         //     'orderId': widget.orderId,
//         //   },
//         // );
//       }
//     } catch (e) {
//       debugPrint('Error sending notification: $e');
//     }
//   }

//   Future<void> _addTrackingNumber() async {
//     final trackingController = TextEditingController();
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier'] ?? 'UPS' // Default carrier
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Tracking Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: const InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: const InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (trackingController.text.isNotEmpty) {
//                 try {
//                   setState(() => _isUpdating = true);
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.orderId)
//                       .update({
//                     'trackingNumber': trackingController.text.trim(),
//                     'carrier': carrierController.text.trim(),
//                     'orderStatus': 'shipped',
//                     'updatedAt': FieldValue.serverTimestamp(),
//                   });

//                   // Send notification to user
//                   await _sendNotificationToUser('shipped', trackingController.text.trim());

//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tracking number added successfully'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   setState(() {
//                     _currentStatus = 'shipped';
//                     _isUpdating = false;
//                   });
//                 } catch (e) {
//                   setState(() => _isUpdating = false);
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to add tracking number: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text('SAVE'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _editTrackingNumber() async {
//     final trackingController = TextEditingController(
//       text: widget.orderData['trackingNumber']?.toString() ?? ''
//     );
//     final carrierController = TextEditingController(
//       text: widget.orderData['carrier']?.toString() ?? 'UPS'
//     );

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Tracking Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: trackingController,
//               decoration: const InputDecoration(
//                 labelText: 'Tracking Number',
//                 hintText: 'Enter tracking number',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: carrierController,
//               decoration: const InputDecoration(
//                 labelText: 'Carrier',
//                 hintText: 'e.g., FedEx, UPS, USPS',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (trackingController.text.isNotEmpty) {
//                 try {
//                   setState(() => _isUpdating = true);
//                   await FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(widget.orderId)
//                       .update({
//                     'trackingNumber': trackingController.text.trim(),
//                     'carrier': carrierController.text.trim(),
//                     'updatedAt': FieldValue.serverTimestamp(),
//                   });

//                   // Send notification to user
//                   await _sendNotificationToUser(_currentStatus, trackingController.text.trim());

//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tracking information updated'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   setState(() => _isUpdating = false);
//                 } catch (e) {
//                   setState(() => _isUpdating = false);
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to update tracking: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: const Text('UPDATE'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTrackingInfo() {
//     final trackingNumber = widget.orderData['trackingNumber'] as String?;
//     final carrier = widget.orderData['carrier'] as String?;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 12),
//         _buildSectionHeader('SHIPPING INFO'),
//         if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
//           _buildDetailRow('Tracking #:', trackingNumber),
//           if (carrier != null && carrier.isNotEmpty)
//             _buildDetailRow('Carrier:', carrier),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : _editTrackingNumber,
//             child: const Text('Edit Tracking Info'),
//           ),
//         ] else if (_currentStatus == 'shipped' || _currentStatus == 'delivered') ...[
//           _buildDetailRow('Tracking #:', 'Not provided'),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : _addTrackingNumber,
//             child: const Text('Add Tracking Number'),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: _getStatusColor(_currentStatus).withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         _currentStatus.substring(0, 1).toUpperCase(),
//         style: TextStyle(
//           color: _getStatusColor(_currentStatus),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12, bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color.fromARGB(255, 4, 66, 85),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(dynamic item) {
//     final itemMap = item as Map<String, dynamic>;
//     final imageUrl = itemMap['imageUrl'] as String?;
//     final name = itemMap['name']?.toString() ?? 'No Name';
//     final price = (itemMap['price'] as num? ?? 0).toDouble();
//     final quantity = itemMap['quantity'] as int? ?? 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             // Product Image
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.grey[100],
//               ),
//               child: imageUrl != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => 
//                           const Icon(Icons.image_not_supported, size: 24),
//                       ),
//                     )
//                   : const Icon(Icons.image_not_supported, size: 24),
//             ),
//             const SizedBox(width: 12),
            
//             // Product Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${price.toStringAsFixed(2)} × $quantity',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Total Price
//             Text(
//               '\$${(price * quantity).toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusDropdown() {
//     final List<String> allStatuses = [
//       'PENDING',
//       'PROCESSING',
//       'SHIPPED',
//       'DELIVERED',
//       'CANCELLED'
//     ];

//     return DropdownButtonFormField<String>(
//       value: _currentStatus.toUpperCase(),
//       isExpanded: true,
//       decoration: InputDecoration(
//         labelText: 'Change Status',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//       items: allStatuses.map((status) {
//         return DropdownMenuItem<String>(
//           value: status,
//           child: Row(
//             children: [
//               Icon(
//                 _getStatusIcon(status),
//                 size: 20,
//                 color: _getStatusColor(status),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 status,
//                 style: TextStyle(
//                   color: _getStatusColor(status),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: _isUpdating ? null : (newStatus) {
//         if (newStatus != null && newStatus != _currentStatus.toUpperCase()) {
//           _updateOrderStatus(newStatus);
//         }
//       },
//     );
//   }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({
//         'orderStatus': newStatus,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Send notification to user for important status changes
//       if (newStatus == 'SHIPPED' || newStatus == 'DELIVERED' || newStatus == 'CANCELLED') {
//         await _sendNotificationToUser(newStatus, widget.orderData['trackingNumber']);
//       }

//       // Update local state immediately
//       setState(() {
//         _currentStatus = newStatus;
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Status updated to $newStatus'),
//           backgroundColor: _getStatusColor(newStatus),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isUpdating = false;
//       });

//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update status: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = widget.orderData['items'] as List<dynamic>? ?? [];
//     final customerName = (widget.orderData['customerName'] as String? ?? 'No Name').trim();
//     final totalAmount = (widget.orderData['totalAmount'] as num? ?? 0).toDouble();
//     final createdAt = widget.orderData['createdAt'] as Timestamp?;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ExpansionTile(
//         leading: _buildStatusIndicator(),
//         title: Text(
//           customerName,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatDate(createdAt),
//               style: const TextStyle(fontSize: 12),
//             ),
//             Text(
//               'Total: \$${totalAmount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Order Summary Section
//                 _buildSectionHeader('ORDER SUMMARY'),
//                 _buildDetailRow('Order ID:', widget.orderId),
//                 _buildDetailRow('Status:', _currentStatus),
//                 _buildDetailRow('Date:', _formatDate(createdAt)),
//                 _buildDetailRow('Total:', '\$${totalAmount.toStringAsFixed(2)}'),
                
//                 // Customer Information
//                 _buildSectionHeader('CUSTOMER INFO'),
//                 _buildDetailRow('Name:', customerName),
//                 _buildDetailRow('Email:', widget.orderData['userEmail']?.toString() ?? 'Not provided'),
//                 _buildDetailRow('Phone:', widget.orderData['phoneNumber']?.toString() ?? 'Not provided'),
                
//                 // Shipping Information
//                 _buildTrackingInfo(),
                
//                 // Order Items
//                 _buildSectionHeader('ORDER ITEMS (${items.length})'),
//                 const SizedBox(height: 8),
//                 ...items.map((item) => _buildOrderItem(item)).toList(),
                
//                 // Status Actions
//                 _buildStatusDropdown(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }   