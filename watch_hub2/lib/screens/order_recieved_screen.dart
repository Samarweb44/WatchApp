// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'user_notifications_screen.dart';

// class OrderReceivedScreen extends StatelessWidget {
//   final String orderId;
//   final String? trackingNumber;

//   const OrderReceivedScreen({
//     super.key,
//     required this.orderId,
//     this.trackingNumber,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 80,
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Order Received!',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Thank you for your purchase. We\'ve received your order and will process it shortly.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 32),
//               if (trackingNumber != null) ...[
//                 const Text(
//                   'Your tracking number:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   trackingNumber!,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OrderTrackingScreen(
//                           orderId: orderId,
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('TRACK YOUR ORDER'),
//                 ),
//               ],
//               const SizedBox(height: 24),
//               TextButton(
//                 onPressed: () {
//                   Navigator.popUntil(
//                       context, (route) => route.isFirst);
//                 },
//                 child: const Text('BACK TO HOME'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }