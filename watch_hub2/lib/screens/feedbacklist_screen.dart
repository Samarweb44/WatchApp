// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class FeedbackListScreen extends StatelessWidget {
//   const FeedbackListScreen({super.key});

//   // Theme colors
//   final Color _primaryBlack = const Color(0xFF121212);
//   final Color _secondaryBlack = const Color(0xFF1E1E1E);
//   final Color _accentYellow = const Color(0xFFFFD700);
//   final Color _white = const Color(0xFFFFFFFF);
//   final Color _hintColor = const Color(0xFFA0A0A0);
//   // Golden yellow for highlights
//   final Color _errorRed = const Color(0xFFD32F2F);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _primaryBlack,
//       appBar: AppBar(
//         title: const Text(
//           "Submitted Feedbacks",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             letterSpacing: 0.5,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: _accentYellow),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [_primaryBlack.withOpacity(0.9), _primaryBlack],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('feedbacks')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: _accentYellow),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error loading feedbacks',
//                 style: TextStyle(color: _errorRed),
//               ),
//             );
//           }

//           final feedbackList = snapshot.data!.docs;

//           if (feedbackList.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.feedback, size: 60, color: _hintColor),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No feedback submitted yet",
//                     style: TextStyle(color: _hintColor, fontSize: 18),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: feedbackList.length,
//             itemBuilder: (context, index) {
//               final feedback = feedbackList[index];
//               final data = feedback.data() as Map<String, dynamic>;

//               final message = data['message'] ?? 'No message';
//               final type = data['type'] ?? 'Unknown';
//               final user = data.containsKey('user')
//                   ? data['user']
//                   : 'Anonymous';
//               final timestamp = (data['timestamp'] as Timestamp).toDate();
//               final timeString = DateFormat(
//                 'MMM dd, yyyy • hh:mm a',
//               ).format(timestamp);

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Card(
//                   color: _secondaryBlack,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                   child: ExpansionTile(
//                     title: Text(
//                       type,
//                       style: TextStyle(
//                         color: _accentYellow,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       user,
//                       style: TextStyle(color: _hintColor, fontSize: 14),
//                     ),
//                     trailing: Text(
//                       DateFormat('MMM dd').format(timestamp),
//                       style: TextStyle(color: _hintColor, fontSize: 12),
//                     ),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Message:',
//                               style: TextStyle(
//                                 color: _accentYellow,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: _primaryBlack,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 message,
//                                 style: TextStyle(color: _white, height: 1.5),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               children: [
//                                 Icon(Icons.person, size: 16, color: _hintColor),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   user,
//                                   style: TextStyle(
//                                     color: _hintColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Icon(
//                                   Icons.access_time,
//                                   size: 16,
//                                   color: _hintColor,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   timeString,
//                                   style: TextStyle(
//                                     color: _hintColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/models/app_state.dart';

class FeedbackListScreen extends StatelessWidget {
  const FeedbackListScreen({super.key});

  // Theme colors
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _hintColor = const Color(0xFFA0A0A0);
  final Color _errorRed = const Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppState>(context).currentUser;

    // Show loading indicator while checking auth state
    if (currentUser == null && FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        backgroundColor: _primaryBlack,
        appBar: AppBar(
          title: const Text(
            "Your Feedbacks",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _accentYellow),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    // Handle unauthenticated users
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: _primaryBlack,
        appBar: AppBar(
          title: const Text(
            "Your Feedbacks",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _accentYellow),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: _errorRed),
              const SizedBox(height: 20),
              Text(
                "Authentication required",
                style: TextStyle(color: _white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Please sign in to view your feedback",
                style: TextStyle(color: _hintColor),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentYellow,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, 
                    vertical: 15,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/auth'),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: _primaryBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: AppBar(
        title: const Text(
          "Your Feedbacks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: _accentYellow),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _buildFeedbackList(currentUser.uid, context),
    );
  }

 Future<void> _logout(BuildContext context) async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
      ),
    );

    // Perform logout
    await Provider.of<AppState>(context, listen: false).logout();
    
    // Close loading indicator
    Navigator.of(context).pop();
    
    // Navigate to auth screen and clear navigation stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/auth',
      (route) => false,
    );
  } catch (e) {
    // Close loading indicator if still open
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout failed: ${e.toString()}'),
        backgroundColor: _errorRed,
      ),
    );
  }
}

  Widget _buildFeedbackList(String userId, BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedbacks')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: _accentYellow),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: _errorRed),
                const SizedBox(height: 20),
                Text(
                  'Failed to load feedbacks',
                  style: TextStyle(color: _white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: _hintColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Instead of refreshUser, we'll just rebuild the widget
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedbackListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentYellow,
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(color: _primaryBlack),
                  ),
                ),
              ],
            ),
          );
        }

        // Handle empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.feedback, size: 60, color: _hintColor),
                const SizedBox(height: 20),
                Text(
                  "No feedback submitted yet",
                  style: TextStyle(color: _white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your feedback will appear here once submitted",
                  style: TextStyle(color: _hintColor),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentYellow,
                  ),
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(color: _primaryBlack),
                  ),
                ),
              ],
            ),
          );
        }

        // Build feedback list
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final feedback = snapshot.data!.docs[index];
            final data = feedback.data() as Map<String, dynamic>;
            final timestamp = (data['timestamp'] as Timestamp).toDate();

            return _buildFeedbackCard(
              type: data['type'] ?? 'Unknown',
              message: data['message'] ?? 'No message',
              timestamp: timestamp,
            );
          },
        );
      },
    );
  }

  Widget _buildFeedbackCard({
    required String type,
    required String message,
    required DateTime timestamp,
  }) {
    final timeString = DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        color: _secondaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: ExpansionTile(
          title: Text(
            type,
            style: TextStyle(
              color: _accentYellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM dd').format(timestamp),
            style: TextStyle(color: _hintColor, fontSize: 14),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Message:',
                    style: TextStyle(
                      color: _accentYellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _primaryBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(color: _white, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: _hintColor),
                      const SizedBox(width: 8),
                      Text(
                        'Submitted: $timeString',
                        style: TextStyle(color: _hintColor, fontSize: 12),
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
  }
}